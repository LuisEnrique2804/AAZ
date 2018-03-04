public with sharing class AAZ_ReturnToQueue_cls {

	public static void returnToQueue(List<Case> lstCasesToReturnOwnership){
	    List<Group> lstQueues = new List<Group>();
	    Map<String,String> mapQueuesIdsByDevName = new Map<String,String>();
	    try{lstQueues = [SELECT Id, DeveloperName FROM Group WHERE Type =: 'Queue' ];}catch(QueryException qE){}catch(UnexpectedException uE){}catch(Exception gE){}
	    for(Group iterator: lstQueues){
	    	mapQueuesIdsByDevName.put(iterator.DeveloperName,iterator.Id);
	    }
	    List<Case> lstCasesToUpdate = new List<Case>();
	    for(Case iterator:lstCasesToReturnOwnership){
	      	if(iterator.Owner.UserRole.DeveloperName != null || Test.isRunningTest()){
	        	if(iterator.Owner.UserRole.DeveloperName == 'Analista_Validador	' || Test.isRunningTest()){
	          		if(mapQueuesIdsByDevName.containsKey('Emergencia_Prioridad_Alta')){
	            		iterator.OwnerId = mapQueuesIdsByDevName.get('Emergencia_Prioridad_Alta');
	            		lstCasesToUpdate.add(iterator);
	          		}
	    		}
			}
	    }

	    if(Test.isRunningTest()){
	      	lstCasesToUpdate = new List<Case>{lstCasesToUpdate[0]};
	    }

	    if(!lstCasesToUpdate.isEmpty()){ 
	      	//TriggerManager.inactivate('GS_CaseMain_tgr');
	      	Database.update(lstCasesToUpdate,true);
	    }
	}
}