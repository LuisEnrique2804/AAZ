global class DeleteHistoricalProcess_bch implements Database.Batchable<sObject>{

    public String strFecha='';
    public String strSolicitudId='';
    global Database.QueryLocator start(Database.BatchableContext BC){

        return Database.getQueryLocator('SELECT id FROM case where Historical__c=true and createdDate<'+strFecha+'T00:00:00.000Z');

    }

 

    global void execute(Database.BatchableContext BC, List<sObject> scope){
         // elimina los casos
         if(scope.size()>0)
         {
             List<Case> lstCasos=(List<Case>)scope;
             delete lstCasos;
         } 
    }

    global void finish(Database.BatchableContext BC){

    }

}