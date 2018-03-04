public class AAZ_UpdateCase_ctr {
    public String strCaseId { set; get; }
    public List<SystemIssue__c> lstISId = new List<SystemIssue__c>();
    public List<Document__c> lstCase = new List<Document__c> ();
    public List<Case> lstCasetoUpdate = new List<Case> ();
    public boolean blnEvrytingIsOK = true;
    public boolean blnQuerysWasSuccesful = false; 
    public List<Document__c>   documentCase    = new List<Document__c>();
    public Map<String, Object> mapExtras       = new Map<String, Object>();
    
    public AAZ_UpdateCase_ctr(ApexPages.StandardController stdCtr) {
        strCaseId = stdCtr.getId();

    }
    
    public void updateDocs(){
        List<Group> lstQueues = new List<Group>();
        system.debug('===>strCaseId: '+strCaseId);
        lstISId = [SELECT CaseId__c FROM SystemIssue__c WHERE ID =: strCaseId LIMIT 1];
        system.debug('===>lstCase: '+lstISId);
        lstCasetoUpdate = [Select id, idServiceType__c, employeeNumber__c, FolioNSS__c, Account.NSS__c, completeDocs__c, Type, SubType__c, SubSubType__c, OwnerId, Status FROM Case Where id = :lstISId[0].CaseId__c];
        //lstCasetoUpdate = [Select id, idServiceType__c, employeeNumber__c, FolioNSS__c, Account.NSS__c, completeDocs__c, Type, SubType__c, SubSubType__c, OwnerId, Status FROM Case Where Status = 'PENDIENTE POR DOCUMENTO' LIMIT 25];
        

        lstCase = [SELECT ID FROM Document__c WHERE RelatedProcedure__c =: lstISId[0].CaseId__c];
        system.debug('===>lstCase: '+lstCase);
        Map<String,String> mapQueuesIdsByDevName = new Map<String,String>();
        try{lstQueues = [SELECT Id, DeveloperName FROM Group WHERE Type =: 'Queue' ];}catch(QueryException qE){}catch(UnexpectedException uE){}catch(Exception gE){}
        for(Group iterator: lstQueues){
            mapQueuesIdsByDevName.put(iterator.DeveloperName,iterator.Id);
        }

        List<Case> lstCasesUpd  = new List<Case>();
        List<Case> lstCasesUpd2 = new List<Case>();
        if(lstCase.size()>0){
			Database.DeleteResult[] dRCase = Database.delete(lstCase,true);
            for(Database.DeleteResult dr : dRCase) {
                if(dr.isSuccess()){
                    blnEvrytingIsOK = true;
                }else{
                    blnEvrytingIsOK = false;
                }
            }
        }
        if(blnEvrytingIsOK){
            try{
				documentCase    = AAZ_DocumentQueryWS_cls.getDocList(lstCasetoUpdate,mapExtras);
				blnQuerysWasSuccesful = true;
	        }catch(CalloutException qE){System.debug(loggingLevel.Error, '*** qE: ' + qE.getMessage());}catch(UnexpectedException uE){System.debug(loggingLevel.Error, '*** uE: ' + uE.getMessage());}catch(Exception gE){System.debug(loggingLevel.Error, '*** gE: ' + gE.getMessage());}
	        for(Case caseIterator: lstCasetoUpdate) {
		    	if(blnQuerysWasSuccesful) {    	
	           		for(Integer i = 0; i < documentCase.size(); i++) {
                        documentCase[i].RelatedProcedure__c = caseIterator.id;
                        //Ajuste para agregar un 4000 al valor de digitalización solo en caso de que el tipo de tramite sea 4
                        if(caseIterator.idServiceType__c == '4' ) {
                            if(documentCase[i].DocumentTypeId__c == '1' || documentCase[i].DocumentTypeId__c == '2') {
                                documentCase[i].DocumentTypeId__c = 4000+documentCase[i].DocumentTypeId__c;
                            }
                        }
                        //Ajuste para agregar un 4000 al valor de digitalización solo en caso de que el tipo de tramite sea 4
                        if(caseIterator.idServiceType__c == '59' || caseIterator.idServiceType__c == '60' || caseIterator.idServiceType__c == '41' || caseIterator.idServiceType__c == '997') {
                            if(documentCase[i].DocumentTypeId__c == '1' || documentCase[i].DocumentTypeId__c == '2') {
                                documentCase[i].DocumentTypeId__c = 92+documentCase[i].DocumentTypeId__c;
                            }
                        }
                        if(caseIterator.idServiceType__c == '017' || caseIterator.idServiceType__c == '46'|| caseIterator.idServiceType__c == '47'||caseIterator.idServiceType__c =='401'||caseIterator.idServiceType__c =='402'||caseIterator.idServiceType__c =='404'||caseIterator.idServiceType__c =='1'||caseIterator.idServiceType__c =='2') {
                            if(documentCase[i].DocumentTypeId__c == '2') {
                                documentCase[i].DocumentTypeId__c = 17+documentCase[i].DocumentTypeId__c;
                            }
                        }
                        if(caseIterator.idServiceType__c == '017' || caseIterator.idServiceType__c == '46' || caseIterator.idServiceType__c == '47'||caseIterator.idServiceType__c =='401'||caseIterator.idServiceType__c =='402'||caseIterator.idServiceType__c =='404'||caseIterator.idServiceType__c =='405'||caseIterator.idServiceType__c =='1'||caseIterator.idServiceType__c =='2'||caseIterator.idServiceType__c =='39') {
                            if(documentCase[i].DocumentTypeId__c == '1') {
                                documentCase[i].DocumentTypeId__c = 92+documentCase[i].DocumentTypeId__c;
                            }
                        }
                        System.debug(loggingLevel.Error, '*** documentCase[i].DocumentTypeId__c: ' + documentCase[i].DocumentTypeId__c);
                    }
                    Database.SaveResult[] srD = Database.insert(documentCase, true);
                    //for(Database.SaveResult sR: srD) {
                    //    if(sR.isSuccess()) {
                    //        caseIterator.completeDocs__c = AAZ_Utils_cls.documentsRequiredComplete(caseIterator);
                    //    }
                    //}
                }
                //if(caseIterator.completeDocs__c) {
                //    System.debug(loggingLevel.Error, '*** Paso 1: ');
                //    if(mapQueuesIdsByDevName.containsKey('Emergencia_Prioridad_Alta')){
                //        System.debug(loggingLevel.Error, '*** Paso 2: ');
                //        System.debug(loggingLevel.Error, '*** Paso 2: '+ mapQueuesIdsByDevName.get('Emergencia_Prioridad_Alta'));
                //        caseIterator.OwnerId =  mapQueuesIdsByDevName.get('Emergencia_Prioridad_Alta');
                //        System.debug(loggingLevel.Error, '*** caseIterator.OwnerId: ' + caseIterator.OwnerId);
                //    }
                //}
                lstCasesUpd.add(caseIterator);
            }

            for(Case caseIterator: lstCasesUpd) {
                caseIterator.completeDocs__c = AAZ_Utils_cls.documentsRequiredComplete(caseIterator);
                if(caseIterator.completeDocs__c) {
                    System.debug(loggingLevel.Error, '*** Paso 1: ');
                    if(mapQueuesIdsByDevName.containsKey('Emergencia_Prioridad_Alta')){
                        System.debug(loggingLevel.Error, '*** Paso 2: ');
                        System.debug(loggingLevel.Error, '*** Paso 2: '+ mapQueuesIdsByDevName.get('Emergencia_Prioridad_Alta'));
                        caseIterator.OwnerId =  mapQueuesIdsByDevName.get('Emergencia_Prioridad_Alta');
                        caseIterator.Status = 'EN VALIDACION';
                        System.debug(loggingLevel.Error, '*** caseIterator.OwnerId: ' + caseIterator.OwnerId);
                    }
                }
            lstCasesUpd2.add(caseIterator);
            }

            System.debug(loggingLevel.Error, '*** lstCasesUpd2: ' + lstCasesUpd2);
            Database.SaveResult[] sr = Database.update(lstCasesUpd2, true);
            for(Database.SaveResult s: sr) {
                if(s.isSuccess()) {
                    System.debug(loggingLevel.Error, '*** IsUpdate: ');
                }
            }
        }
    }
}