global class AAZ_CallOutFuture_cls {

    private static final String strConfigName = 'Afore_ApprovalRejectProcess';
    
    public static  AppMainSetting_cs__c mainSettings = Test.isRunningTest()?
        AAZ_TestUtils_tst.getMainSettings() : AppMainSetting_cs__c.getOrgDefaults();
    
    private static List<Case> lstAuxCase;

    public static void callOuts(set<Id> setIdCase) {
                
        List<Document__c>   documentCase    = new List<Document__c>();
        List<People__c>     beneficiaryCase = new List<People__c>();
        List<People__c>     referenceCase   = new List<People__c>();
        Contact             agentCase       = new Contact();
        List<Case>          lstCases        = new List<Case>();
        List<Case>          lstCasesUpd     = new List<Case>();
        Map<String, Object> mapExtras       = new Map<String, Object>();
        Boolean blnQuerysWasSuccesful       = false;
        Boolean blnAgenLockUnlock = false;

        Map<String,Map<String,RecordType>> mapRTsByDevName = AAZ_Utils_cls.getRecordTypes('DeveloperName');
        Map<String,Map<String,RecordType>> mapRTsById = AAZ_Utils_cls.getRecordTypes('Id');
        String stgcomplainRT = mapRTsByDevName.get('People__c').get('Reference').Id;
        List<Id> lstCaseSet = new List<Id>(setIdCase);
            
        String strQueryCase = 'SELECT '+String.join(new List<String>(SObjectType.Case.Fields.getMap().keySet()),', ')+', Account.NSS__c, Account.RFC__c, Contact.EmployeeNumber__c, Contact.SucursalNumber__c, Contact.NSS__c ,RecordType.DeveloperName ,APValidationContact__r.NSS__c FROM Case WHERE Id IN (\''+ String.join(new List<id>(setIdCase) ,'\',\'')+'\') limit 1000';
        try{lstCases = Database.query(strQueryCase);}catch(QueryException qE){}catch(UnexpectedException uE){}catch(Exception gE){}
        String strRecordTypeComplain = mapRTsByDevName.get('Case').get('Complain').DeveloperName;
        String strRecordTypeProcedure = '';
        System.debug(loggingLevel.Error, '*** lstCases: ' + lstCases);
        for(Case caseObj: lstCases) {
            String strQueryAP = 'SELECT '+String.join(new List<String>(SObjectType.Contact.Fields.getMap().keySet()),', ')+' FROM Contact WHERE EmployeeNumber__c =\''+caseObj.employeeNumber__c+'\''; 
            //agentCase = Database.query(strQueryAP);
            strRecordTypeProcedure = caseObj.RecordType.DeveloperName;  
        }

        if(strRecordTypeProcedure != strRecordTypeComplain) {
            try{
                beneficiaryCase = AAZ_BeneficiaryQuery_cls.getBeneficiaryList(lstCases,mapExtras);
                referenceCase   = AAZ_Afore_QueryReference_cls.getReferenceList(lstCases,mapExtras);
                documentCase    = AAZ_DocumentQueryWS_cls.getDocList(lstCases,mapExtras);
                agentCase       = AAZ_AgentQuery_cls.getLockUnlockAPList(lstCases,mapExtras);
                blnQuerysWasSuccesful = true;
            }catch(CalloutException qE){System.debug(loggingLevel.Error, '*** qE: ' + qE.getMessage());}catch(UnexpectedException uE){System.debug(loggingLevel.Error, '*** uE: ' + uE.getMessage());}catch(Exception gE){System.debug(loggingLevel.Error, '*** gE: ' + gE.getMessage());}
            for(Case caseIterator: lstCases) {
                if(blnQuerysWasSuccesful) {     
                    for(Integer i = 0; i < beneficiaryCase.size(); i++) {
                        beneficiaryCase[i].ParentIdBeneficiary__c = caseIterator.id;
                    }
                    for(Integer i = 0; i < referenceCase.size(); i++) {
                        referenceCase[i].ParentIdReference__c = caseIterator.id;
                        referenceCase[i].RecordTypeId = stgcomplainRT;
                    }
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
                        if(caseIterator.idServiceType__c == '3' || caseIterator.idServiceType__c == '017' || caseIterator.idServiceType__c == '46' || caseIterator.idServiceType__c == '47'||caseIterator.idServiceType__c =='401'||caseIterator.idServiceType__c =='402'||caseIterator.idServiceType__c =='404'||caseIterator.idServiceType__c =='405'||caseIterator.idServiceType__c =='1'||caseIterator.idServiceType__c =='2'||caseIterator.idServiceType__c =='39') {
                            if(documentCase[i].DocumentTypeId__c == '1') {
                                documentCase[i].DocumentTypeId__c = 92+documentCase[i].DocumentTypeId__c;
                            }
                        }
                        System.debug(loggingLevel.Error, '*** documentCase[i].DocumentTypeId__c: ' + documentCase[i].DocumentTypeId__c);
                    }
                    SObjectField f = Contact.Field.EmployeeNumber__c;
                    Database.SaveResult[] srB = Database.insert(beneficiaryCase, true);
                    Database.SaveResult[] srR = Database.insert(referenceCase, true);
                    Database.SaveResult[] srD = Database.insert(documentCase, true);
                    caseIterator.completeDocs__c = AAZ_Utils_cls.documentsRequiredComplete(caseIterator);
                    if(agentCase.EmployeeNumber__c != null || String.isNotBlank(agentCase.EmployeeNumber__c)) {
                        Database.UpsertResult srContact = Database.upsert(agentCase,f,true);
                        if(srContact.isSuccess()) {
                            if(caseIterator.idServiceType__c == '4') {System.debug(loggingLevel.Error, '*** 1: ');
                                caseIterator.AP__c     = srContact.getId();
                                caseIterator.ContactId = srContact.getId();
                            } else {System.debug(loggingLevel.Error, '*** 2: ');
                                caseIterator.ContactId       = srContact.getId();
                            }
                        }                   
                    }
                    lstCasesUpd.add(caseIterator);
                }
            }
            Database.SaveResult[] sr = Database.update(lstCasesUpd, true); 
            for(Database.SaveResult srL: sr) {
                if(srL.isSuccess() ) {
                    System.debug(loggingLevel.Error, '*** Tramite Asociado exitosamente: ');
                }else {
                    System.debug(loggingLevel.Error, '*** srL: ' + srL.getErrors() );
                }
            }
        }
    }

    
    public static void approveRejectProcedure(Map<Id,Case> mapNewStatus, Map<Id,Case> mapOldStatus){
        Set<Id> setCaseToApprove = new Set<Id>();
        Set<Id> setCaseToReject = new Set<Id>();
        Set<Id> setCaseWithContact = new Set<Id>();
        for(Id idCase: mapOldStatus.keySet()) {
            if(mapOldStatus.get(idCase).Status != mapNewStatus.get(idCase).Status) {
                if(mapNewStatus.get(idCase).Status == 'APROBADO') {
                    setCaseToApprove.add(idCase);
                }
                else if (mapNewStatus.get(idCase).Status == 'RECHAZADO') {
                    System.debug(loggingLevel.Error, '*** Fue Rechazado: ');
                    setCaseToReject.add(idCase);    
                }   
            }else if (mapNewStatus.get(idCase).Status == 'RECHAZADO') {
                if(mapNewStatus.get(idCase).isReversed__c) {    
                    System.debug(loggingLevel.Error, '*** Fue Rechazado: ');
                    setCaseToReject.add(idCase);    
                }
            }

            if(mapOldStatus.get(idCase).Subsidiary__c != mapNewStatus.get(idCase).Subsidiary__c) {
                if(mapNewStatus.get(idCase).Subsidiary__c != null) {
                    setCaseWithContact.add(idCase);
                }
                
            }

            //if(mapOldStatus.get(idCase).AP__c != mapNewStatus.get(idCase).AP__c) {
            //  if(mapNewStatus.get(idCase).AP__c != null) {
            //      setCaseWithContact.add(idCase);
            //  }
                
            //}
        }

        for(Id objCase: setCaseToApprove) {
            processCase(objCase, true);
        }

        for(Id objCase: setCaseToReject) {
            processCase(objCase, false);
        }

        for(Id objCase: setCaseWithContact) {
            updateSubsidary(objCase);
        }
    }

    @future(callout=true)
    public static void processCase (Id objCase, Boolean blnIsApproval){
        Case objCaseProcedure = new Case();
        User userQuery = null;
        String strComents = '';
        Map<String, Object> mapExtraAttrs = new Map<String, Object>();
        Map<String, Object> mapResponse = new Map<String, Object>();
        String strJsonRequest = '';
        String strJsonResponse = '';
        ResponseWrapper     responseWp  = new ResponseWrapper();
        System.debug(loggingLevel.Error, '*** blnIsApproval: ' + blnIsApproval);
        String stgQueryOverCase = 'SELECT '+String.join(new List<String>(SObjectType.Case.Fields.getMap().keySet()), ', ')+', Account.NSS__c FROM Case WHERE Id = \''+objCase+'\' limit 1';
        try {objCaseProcedure = Database.query(stgQueryOverCase);} catch(DmlException dE){} catch(Exception e) {}
        List<ReasonRejection__c> lstRejections = [
            SELECT Id, ReasonRejectionID2__c, DescripcionComentario__c
            FROM ReasonRejection__c
            WHERE ProcedureId__c = :objCaseProcedure.Id
        ];
        userQuery = AAZ_Utils_cls.getUserCustomInfo(UserInfo.getUserId());

        for(ReasonRejection__c iteratosRR: lstRejections) {
            System.debug(loggingLevel.Error, '*** iteratosRR.DescripcionComentario__c: ' + iteratosRR.DescripcionComentario__c);
            if(iteratosRR.ReasonRejectionID2__c == '011' || iteratosRR.ReasonRejectionID2__c == '214') {
            //if(iteratosRR.DescripcionComentario__c != '' && String.isBlank(iteratosRR.DescripcionComentario__c) && iteratosRR.DescripcionComentario__c  != null && iteratosRR.DescripcionComentario__c  != 'null') {
                System.debug(loggingLevel.Error, '*** entro: ');
                strComents = strComents + iteratosRR.DescripcionComentario__c;
            }
        }

        strJsonRequest = JSON.serializePretty(
            new Map<String,Object>{ 
                'In_AprobacionRechazoTramites' => new Map<String,Object>{
                    'approveServiceRq' => new Map<String,Object>{
                        'comments'=> strComents,
                        'codigoRechazo'=>objCaseProcedure.rejectionComments__c,
                        'isReverted'=>objCaseProcedure.isReversed__c,
                        'codigoServicio'=>objCaseProcedure.IdTypeService__c,
                        'ususario'=>userQuery.EmployeeNumber, 
                        'nss'=>objCaseProcedure.Account.NSS__c,
                        'isApproved'=>objCaseProcedure.isApproved__c, 
                        'folio'=> objCaseProcedure.FolioNSS__c
                    }
                }
            }
        );

        System.debug(loggingLevel.Error, '*** strJsonRequest: ' + strJsonRequest);

        if(strJsonRequest != null) {
            if(!String.isBlank(strJsonRequest)) {   
                try{strJsonResponse = AAZ_GenericCallout_cls.fn_runCallout(strJsonRequest, strConfigName, null);}
                catch(CalloutException cE){System.debug(loggingLevel.Error, '*** cE: ' + cE.getMessage() );}catch(UnexpectedException uE){System.debug(loggingLevel.Error, '*** uE.: ' + uE.getMessage() );}catch(Exception gE){ System.debug(loggingLevel.Error, '*** ge: ' + ge.getMessage() );}
                System.debug(loggingLevel.Error, '*** strJsonResponse: ' + strJsonResponse);

                if (String.isNotBlank(strJsonResponse) && strJsonResponse != null) {
                    responseWp = (ResponseWrapper)JSON.deserialize(strJsonResponse, ResponseWrapper.class);
                    System.debug(loggingLevel.Error, '*** responseWp: ' + responseWp);
                    if(responseWp.Out_AprobacionRechazoTramites != null) {
                        if(responseWp.Out_AprobacionRechazoTramites.approveServiceRs != null) {
                            if(responseWp.Out_AprobacionRechazoTramites.approveServiceRs.isSucessful == 'False') {
                                objCaseProcedure.Status = 'EN VALIDACION';
                                objCaseProcedure.OwnerId= System.Label.HighLevel;
                                CaseComment caseComen = new CaseComment(
                                    ParentId = objCaseProcedure.Id,
                                    CommentBody = responseWp.Out_AprobacionRechazoTramites.approveServiceRs.errorList.errorItem[0].description
                                    );
                                insert caseComen;
                                Database.SaveResult srC = Database.update(objCaseProcedure, true);
                                if(srC.isSuccess()) {
                                    System.debug(loggingLevel.Error, '*** Caso actualizado: ');
                                } else {
                                    System.debug(loggingLevel.Error, '*** Caso No actualizado: ');
                                }

                            }
                        }
                    }
                }else {
                    objCaseProcedure.Status = 'EN VALIDACION';
                    objCaseProcedure.OwnerId= System.Label.HighLevel;            
                    Database.SaveResult srC = Database.update(objCaseProcedure, true);
                    if(srC.isSuccess()) {
                        System.debug(loggingLevel.Error, '*** Caso actualizado: ');
                    } else {
                        System.debug(loggingLevel.Error, '*** Caso No actualizado: ');
                    }
                }

            }
        }
    }

    public class ResponseWrapper {
        public ApproveReject Out_AprobacionRechazoTramites;
    }

    public class ApproveReject {
        public ReferenceData approveServiceRs;
    }

    public class ReferenceData {
        public String isSucessful;
        public Error errorList;
    }

    public class Error {
        public List<ErroList> errorItem;
    }

    public class ErroList {
        public string code;
        public string description;
    }
    
    @future(callout=true)
    public static void updateSubsidary(id idCaseWithContact){
        Case                subsidiaryCase  = new Case();
        Map<String, Object> mapExtras       = new Map<String, Object>();
        List<Case> lstSucursalNumber = new List<Case>();
        try{subsidiaryCase  = AAZ_SubsidiaryQuery_cls.getSubsidiaryList(idCaseWithContact,mapExtras);}catch(CalloutException qE){System.debug(loggingLevel.Error, '*** qE: ' + qE.getMessage());}catch(UnexpectedException uE){System.debug(loggingLevel.Error, '*** uE: ' + uE.getMessage());}catch(Exception gE){System.debug(loggingLevel.Error, '*** gE: ' + gE.getMessage());}
        subsidiaryCase.id = idCaseWithContact;
        System.debug(loggingLevel.Error, '*** subsidiaryCase: ' + subsidiaryCase);  
        Database.SaveResult srC = Database.update(subsidiaryCase, true);
        if(srC.isSuccess()) {
            System.debug(loggingLevel.Error, '*** Caso actualizado: ');
            System.debug(loggingLevel.Error, '*** subsidiaryCase: ' + subsidiaryCase);
        } else {
            System.debug(loggingLevel.Error, '*** Caso No actualizado: ');
        }
    }

}