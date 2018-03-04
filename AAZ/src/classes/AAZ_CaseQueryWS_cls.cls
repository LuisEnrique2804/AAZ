/*******************************************************************************
Desarrollado por: Avanxo México
Autor: Luis E. Garcia
Proyecto: Afore Azteca
Descripción: Clase para servicio de consulta de tramite (WS011)

------ ---------- -------------------------- -----------------------------------
No.    Fecha      Autor                      Descripción
------ ---------- -------------------------- -----------------------------------
1.0    26/07/2017 Luis E. Garcia           Clase creada
*******************************************************************************/
public class AAZ_CaseQueryWS_cls {

	private static final String strOrdersQueryConfigCode = 'Afore_QueryProcess';
    
    // Cargar los mainsettings para las clases de prueba
    public static AppMainSetting_cs__c mainSettings = Test.isRunningTest()?
        AAZ_TestUtils_tst.getMainSettings() : AppMainSetting_cs__c.getOrgDefaults();

    public static List<Case> getCaseDetails(String strNss, String strCurp, string strName, String strPaternalLastName, String strMathernalLastName){
        Account acc = new Account();
        Account accAux = new Account();
        Contact objContact = new Contact();
        Contact objNewContact = new Contact();
        Case procedureCase = new Case();
        Case objCase = new Case();
        Case objCaseAux = new Case();
        id idAcc;
        id idContact;
        String stgEmNum;
        String stgCaseInsert;
        Boolean blnSuccessfulProcess = true;

        Map<String, Object> mapRequest         = new Map<String, Object>();
        Map<String, Object> mapResponse        = new Map<String, Object>();
        List<Case>          lstfoundCases      = new List<Case>();
        String              strRequest         = '';
        String              strResponse        = '';
        Boolean             blnServiceHadError = false;
        string              stgMessage         = '';
        String              stgtype            = 'Web Service';
        id                  idCurrentCase;
        id                  idCurrentId        = UserInfo.getUserId();
        Boolean             blnIsSuccesful     = false;
        ResponseWrapper     responseWp  = new ResponseWrapper();
        Account accountProcedure = new Account();
        //System.debug(loggingLevel.Error, '*** Aqui ***');
        Map<String,Map<String,RecordType>> mapRTsByDevName = AAZ_Utils_cls.getRecordTypes('DeveloperName');
        String stgcomplainRT = mapRTsByDevName.get('Account').get('PersonAccount').Id;
        //System.debug(loggingLevel.Error, '*** stgcomplainRT: ' + stgcomplainRT);

        if(strNss != null) {
            if(!String.isBlank(strNss)) {

                strRequest = JSON.serializePretty(
                    new Map<String,Object>{
                        'employedServiceRq' => new Map<String,Object>{
                            'codigoServicio' => '1',
                            'nss'=> strNss
                        }
                    }
                );
            }
        }

        if(strCurp != null) {
            if(!String.isBlank(strCurp)) {
                strRequest = JSON.serializePretty(
                    new Map<String,Object>{
                        'employedServiceRq' => new Map<String,Object>{
                            'codigoServicio' => '1',
                            'curp'=> strCurp
                        }
                    }
                );
            }
        }

        if(strName != null) {
            if(strPaternalLastName != null) {
                if(!String.isBlank(strName)) {
                    if(!String.isBlank(strPaternalLastName)) {
                        strRequest = JSON.serializePretty(
                            new Map<String,Object>{
                                'employedServiceRq' => new Map<String,Object>{
                                    'codigoServicio' => '1',
                                    'mathernalLastName'=> strMathernalLastName,
                                    'pathernalLastName' => strPaternalLastName,
                                    'name'=> strName
                                }
                            }
                        );
                    }
                }
            }
        }


        System.debug(loggingLevel.Error, '*** strRequest: ' + strRequest);
        if(strRequest != null || String.isNotBlank(strRequest)) {
            try {
                strResponse = AAZ_GenericCallout_cls.fn_runCallout(strRequest, strOrdersQueryConfigCode, null);
            } catch(Exception gE) {
                blnServiceHadError = true;
                stgMessage = gE.getMessage();
            }
            System.debug(loggingLevel.Error, '*** strResponse: ' + strResponse);
            if (String.isNotBlank(strResponse) && strResponse != null) {
                try {
                    responseWp = (ResponseWrapper)JSON.deserialize(strResponse, ResponseWrapper.class);
                } catch(Exception e) {
                    System.debug(loggingLevel.Error, '*** e: ' + e);
                }
                System.debug(loggingLevel.Error, '*** responseWp: ' + responseWp);
                if(responseWp.Out_ConsultaTramites != null) {
                    if(responseWp.Out_ConsultaTramites.newServiceRequest != null) {
                        if(responseWp.Out_ConsultaTramites.newServiceRequest.isSuccessful == 'true') {
                            if(responseWp.Out_ConsultaTramites.newServiceRequest.searchResult != null) {
                                if(responseWp.Out_ConsultaTramites.newServiceRequest.searchResult.workerData != null) {
                                    accountProcedure = new Account(
                                        NSS__c              = responseWp.Out_ConsultaTramites.newServiceRequest.searchResult.workerData.nss,
                                        FirstName           = responseWp.Out_ConsultaTramites.newServiceRequest.searchResult.workerData.name,
                                        LastName            = responseWp.Out_ConsultaTramites.newServiceRequest.searchResult.workerData.fatherLastName,
                                        PaternalLastName__c = responseWp.Out_ConsultaTramites.newServiceRequest.searchResult.workerData.fatherLastName,
                                        MaternalLastName__c = responseWp.Out_ConsultaTramites.newServiceRequest.searchResult.workerData.motherLastName,
                                        CURP__c             = responseWp.Out_ConsultaTramites.newServiceRequest.searchResult.workerData.curp,
                                        Phone               = responseWp.Out_ConsultaTramites.newServiceRequest.searchResult.workerData.phoneNumber,
                                        street__c           = responseWp.Out_ConsultaTramites.newServiceRequest.searchResult.workerData.street,
                                        InternalNumber__c   = responseWp.Out_ConsultaTramites.newServiceRequest.searchResult.workerData.internalNumber,
                                        ExternalNumber__c   = responseWp.Out_ConsultaTramites.newServiceRequest.searchResult.workerData.externalNumber,
                                        Suburb__c           = responseWp.Out_ConsultaTramites.newServiceRequest.searchResult.workerData.suburb,
                                        postalCode__c       = responseWp.Out_ConsultaTramites.newServiceRequest.searchResult.workerData.postalCode,
                                        Delegation__c       = responseWp.Out_ConsultaTramites.newServiceRequest.searchResult.workerData.delegation,
                                        state__c            = responseWp.Out_ConsultaTramites.newServiceRequest.searchResult.workerData.state,
                                        country__c          = responseWp.Out_ConsultaTramites.newServiceRequest.searchResult.workerData.country,
                                        RecordTypeId        = stgcomplainRT
                                    );
                                }

                                if(responseWp.Out_ConsultaTramites.newServiceRequest.searchResult.procedureData != null) {
                                    procedureCase = new Case(
                                        numberAgreement__c = responseWp.Out_ConsultaTramites.newServiceRequest.searchResult.procedureData.numberAgreement,
                                        AforeToPassG__c    = responseWp.Out_ConsultaTramites.newServiceRequest.searchResult.procedureData.AforeToPassG,
                                        CertificateDate__c = (responseWp.Out_ConsultaTramites.newServiceRequest.searchResult.procedureData.CertificateDateG != null) ? Date.valueOf(responseWp.Out_ConsultaTramites.newServiceRequest.searchResult.procedureData.CertificateDateG) : null,
                                        EndDate__c         = responseWp.Out_ConsultaTramites.newServiceRequest.searchResult.procedureData.EndDateG,
                                        DateToPass__c      = responseWp.Out_ConsultaTramites.newServiceRequest.searchResult.procedureData.DateToPass,
                                        DaysToPermance__c  = responseWp.Out_ConsultaTramites.newServiceRequest.searchResult.procedureData.DaysToPermanceG,
                                        idServiceType__c   = '1',
                                        FolioNSS__c        = responseWp.Out_ConsultaTramites.newServiceRequest.searchResult.folio,
                                        employeeNumber__c  = responseWp.Out_ConsultaTramites.newServiceRequest.searchResult.employeeNumber
                                    );
                                }
                            }
                        }
                    }
                }
            }
        }



        SavePoint sp = Database.setSavePoint();
        //System.debug(loggingLevel.Error, '*** accountProcedure.NSS__c: ' + accountProcedure.NSS__c);
        //System.debug(loggingLevel.Error, '*** accountProcedure.RFC__c: ' + accountProcedure.RFC__c);
        //System.debug(loggingLevel.Error, '*** String.isNotBlank(accountProcedure.NSS__c): ' + String.isNotBlank(accountProcedure.NSS__c));
        //System.debug(loggingLevel.Error, '*** String.isNotBlank(accountProcedure.RFC__c): ' + String.isNotBlank(accountProcedure.RFC__c));
        if(String.isNotBlank(accountProcedure.NSS__c) || String.isNotBlank(accountProcedure.RFC__c)) {
            if(accountProcedure.NSS__c != null || accountProcedure.RFC__c != null) {
                if(String.isNotBlank(accountProcedure.NSS__c)){
                    if(accountProcedure.NSS__c != null) {
                        //System.debug(loggingLevel.Error, '***1: ');
                        SObjectField f = Account.Field.NSS__c;
                        Database.UpsertResult ur = Database.upsert(accountProcedure, f, true);
                        idAcc = ur.getId();
                        if(!ur.isSuccess()){
                            blnSuccessfulProcess = false;
                            Database.rollBack(sp);
                        }
                    }
                }if(String.isNotBlank(accountProcedure.RFC__c)){
                    if(accountProcedure.RFC__c != null) {
                        //System.debug(loggingLevel.Error, '***2: ');
                        SObjectField f = Account.Field.RFC__c;
                        Database.UpsertResult ur = Database.upsert(accountProcedure, f, true);
                        idAcc = ur.getId();
                        if(!ur.isSuccess()){
                            blnSuccessfulProcess = false;
                            Database.rollBack(sp);
                        }
                    }
                }
            }
        }
        if(String.isNotBlank(objContact.EmployeeNumber__c)) {
            SObjectField f = Contact.Field.EmployeeNumber__c;
            stgEmNum = objContact.EmployeeNumber__c;
            try{idContact = [SELECT id FROM Contact WHERE EmployeeNumber__c =: stgEmNum].id;}catch(Exception e) {System.debug(loggingLevel.Error, '*** 4');  blnServiceHadError = true; stgMessage = e.getMessage();}
            List<SObject> lstRequestObjects = new SObject[]{ objContact };
            Map<String, Object> mapExtraAttrs = new Map<String, Object>();
            if(idContact == null) {
                try{objNewContact = AAZ_AgentQuery_cls.getLockUnlockAPList(lstRequestObjects, mapExtraAttrs);}catch(CalloutException qE){System.debug(loggingLevel.Error, '***5');blnServiceHadError = true;stgMessage = qE.getMessage();}catch(UnexpectedException uE){System.debug(loggingLevel.Error, '***5');blnServiceHadError = true; stgMessage = uE.getMessage();}catch(Exception gE){System.debug(loggingLevel.Error, '***6');blnServiceHadError = true;stgMessage = gE.getMessage();}
                if(objNewContact != null) {
                    //System.debug(loggingLevel.Error, '*** objNewContact: ' + objNewContact);
                    Database.UpsertResult ur3 = Database.upsert(objNewContact, f, true);
                    if(ur3.isSuccess()) {
                        idContact = ur3.getId();
                    }
                }
            }
        }

        if(String.isNotBlank(procedureCase.FolioNSS__c)) {
            //System.debug(loggingLevel.Error, '***Aquí***');
            //System.debug(loggingLevel.Error, '*** idAcc: ' + idAcc);
            //System.debug(loggingLevel.Error, '*** idContact: ' + idContact);
            SObjectField f = Case.Field.FolioNSS__c;
            procedureCase.AccountId = idAcc;
            procedureCase.ContactId = idContact;
            Database.UpsertResult ur2 = Database.upsert(procedureCase, f, true);
            //System.debug(loggingLevel.Error, '*** ur2: ' + ur2);
            stgCaseInsert = ur2.getId();
            if(!ur2.isSuccess()){
                blnSuccessfulProcess = false;
            }
        }

        if(blnServiceHadError == true) {
            //AAZ_Utils_cls.insertIncidence(stgMessage,stgtype,idCurrentCase,idCurrentId);
        }
        return lstfoundCases;
    }

    public class ResponseWrapper {
        public OutService Out_ConsultaTramites;
    }

    public class OutService {
        public ServiceRequest newServiceRequest;
    }

    public class ServiceRequest {
        public string isSuccessful;
        public Search searchResult;
    }

    public class Search {
        public String folio;
        public String employeeNumber;
        public Worker workerData;
        public Procedure procedureData;
    }

    public class Worker {
        public String nss;
        public String name;
        public String fatherLastName;
        public String motherLastName;
        public String curp;
        public String phoneNumber;
        public String email;
        public String street;
        public String internalNumber;
        public String externalNumber;
        public String suburb;
        public String postalCode;
        public String delegation;
        public String state;
        public String country;
    }

    public class Procedure {
        public String numberAgreement;
        public String AforeToPassG;
        public Date CertificateDateG;
        public Date EndDateG;
        public Date DateToPass;
        public String DaysToPermanceG;
    }
}