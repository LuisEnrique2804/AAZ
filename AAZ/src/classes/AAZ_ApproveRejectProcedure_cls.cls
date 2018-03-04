public with sharing class AAZ_ApproveRejectProcedure_cls {

    @InvocableMethod(label='Get Approve or Reject Procedure' description='Get the status approve or reject on procedure ')
    public static void getAproveRejectProcedureAsync(List<Id> lstCaseIds) {
        Boolean    blnServiceHadError = false;
        String     stgMessage         = '';
        String     stgtype            = 'Otro';
        Id         idCurrentCase      = lstCaseIds[0];
        Id         idCurrentId        = UserInfo.getUserId();
        Case       caseInstance       = new Case();
        String strQueryOverAccsStmnt = 'SELECT '+String.join(new List<String>(SObjectType.Case.Fields.getMap().keySet()),', ')+' FROM Case WHERE Id IN (\''+String.join(lstCaseIds,'\',\'')+'\') limit 1';        
        try{caseInstance = Database.query(strQueryOverAccsStmnt);}catch(QueryException qE){blnServiceHadError = true; stgMessage = qE.getMessage();}catch(Exception gE){blnServiceHadError = true; stgMessage = gE.getMessage();}
        if(blnServiceHadError) {
            //AAZ_Utils_cls.insertIncidence(stgMessage,stgtype,idCurrentCase,idCurrentId);
        }else{
            if(caseInstance.Status == 'Aprobado'  || caseInstance.Status == 'Rechazado'){
                caseInstance.isApproved__c = (caseInstance.Status == 'Aprobado')?true:false;
                GetApproveRejectAsync approveRejectAsync = new GetApproveRejectAsync();
                approveRejectAsync.objCase = caseInstance;
                Id promoterJobId = System.enqueueJob(approveRejectAsync);
            }
        }
    }

    /**
     * Clase para ejecutar llamado al servicio de consulta de Agente Promotor de manera asíncrona.
     */
    public class GetApproveRejectAsync implements Queueable, Database.AllowsCallouts {
        public Case objCase { get; set; }

        // Ejecutar llamado a servicio de consulta de Agente Promotor
        public void execute(QueueableContext context) {
            List<SObject> lstRequestObjects = new SObject[]{objCase};
            Map<String, Object> mapExtraAttrs = new Map<String, Object>();
            try {
                Boolean blnProcedureHadBeenSend = AAZ_ApprovalProcessService_cls.sendForApproval(lstRequestObjects, mapExtraAttrs,false);
                if(blnProcedureHadBeenSend) {
                    objCase.ImpactProcedure__c = true;
                }
                Database.SaveResult sr = Database.update(objCase, true);
                if(!sr.isSuccess()) {
                    AAZ_Utils_cls.insertIncidence(sr.getErrors()[0].getMessage(), 'Web Service', objCase.Id, UserInfo.getUserId());
                }
            } catch (Exception ex) {
                AAZ_Utils_cls.insertIncidence(ex.getMessage(), 'Web Service', objCase.Id, UserInfo.getUserId());
            }
        }
    }
}