trigger AAZ_UserTrigger_tgr on User (after insert, after update) {

	AppMainSetting_cs__c mainSettings = AppMainSetting_cs__c.getOrgDefaults();

    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            for (User usr: Trigger.new) {
                AAZ_CreateUserAsync_cls createUserAsync = new AAZ_CreateUserAsync_cls();
                createUserAsync.usr = usr;
                if(!Test.isRunningTest()){
                    String jobId = System.enqueueJob(createUserAsync);
                }
            }      
        }
        else if(Trigger.isUpdate || Test.isRunningTest()){
            if(!TriggerManager.isInactive('AAZ_UserTrigger_tgr')) {     
                if(mainSettings.SyncUsersOnUpdate__c){
                    
                    AAZ_DeleteUserAsync_cls.deleteUserTibco(Trigger.newMap, Trigger.oldMap);
                    
                }
            }
        }
    }
}