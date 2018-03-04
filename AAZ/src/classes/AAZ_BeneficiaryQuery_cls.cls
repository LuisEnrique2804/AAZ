/*******************************************************************************
Desarrollado por: Avanxo México
Autor: Luis E. Garcia
Proyecto: Afore Azteca
Descripción: Clase para servicio de Consulta de beneficiario (WS013)

------ ---------- -------------------------- -----------------------------------
No.    Fecha      Autor                      Descripción
------ ---------- -------------------------- -----------------------------------
1.0    26/07/2017 Luis E. Garcia           Clase creada
*******************************************************************************/
public class AAZ_BeneficiaryQuery_cls {
    private static final String strOrdersQueryConfigCode = 'Afore_QueryBeneficiary';
    // Cargar los mainsettings para las clases de prueba
   public static  AppMainSetting_cs__c mainSettings = Test.isRunningTest()?
        AAZ_TestUtils_tst.getMainSettings() : AppMainSetting_cs__c.getOrgDefaults();
    
    public static List<People__c> getBeneficiaryList(List<Case> lstSObjects, Map<String, Object> mapExtraAttrs){
        
        Map<String, Object> mapRequest         = new Map<String, Object>(); 
        Map<String, Object> mapResponse        = new Map<String, Object>(); 
        List<People__c>     lstfoundDocuments  = new List<People__c>();
        String              strRequest         = '';
        String              strResponse        = '';
        Boolean             blnServiceHadError = false;
        string              stgMessage         = '';
        String              stgtype            = 'Web Service';
        id                  idCurrentCase;
        id                  idCurrentId        = UserInfo.getUserId(); 
        Boolean             blnIsSuccesful     = false;
        ResponseWrapper     responseWp  = new ResponseWrapper();
        
        strRequest = JSON.serializePretty(
            new Map<String,Object>{
                'In_ConsultaBeneficiarios' => new Map<String,Object>{
                    'employedServiceRq' => new Map<String,Object>{
                        'codigoServicio' => lstSObjects[0].idServiceType__c,
                        'nss'=> lstSObjects[0].Account.NSS__c,
                        'folio'=> lstSObjects[0].FolioNSS__c
                    }
                }
            }
        );
         
        System.debug(loggingLevel.Error, '*** strRequest: ' + strRequest);
        if(strRequest != null || String.isNotBlank(strRequest)) {
            try{strResponse = AAZ_GenericCallout_cls.fn_runCallout(strRequest, strOrdersQueryConfigCode, null);}catch(CalloutException cE){blnServiceHadError = true;stgMessage = cE.getMessage();}catch(UnexpectedException uE){blnServiceHadError = true;stgMessage = uE.getMessage();}catch(Exception gE){blnServiceHadError = true;stgMessage = gE.getMessage();}
            System.debug(loggingLevel.Error, '*** strResponse: ' + strResponse);
            if (String.isNotBlank(strResponse) && strResponse != null) {
                try {responseWp = (ResponseWrapper)JSON.deserialize(strResponse, ResponseWrapper.class);} catch(Exception e) {System.debug( '*** e: ' + e);}
                System.debug(loggingLevel.Error, '*** responseWp: ' + responseWp);
                System.debug('*** responseWp.Out_ConsultaBeneficiarios: ' + responseWp.Out_ConsultaBeneficiarios);
                if(responseWp.Out_ConsultaBeneficiarios != null) {
                    if(responseWp.Out_ConsultaBeneficiarios.employedServiceRs != null) {
                        if(responseWp.Out_ConsultaBeneficiarios.employedServiceRs.isSucessful == 'true') {
                            if(responseWp.Out_ConsultaBeneficiarios.employedServiceRs.beneficiaries != null) {
                                if(!responseWp.Out_ConsultaBeneficiarios.employedServiceRs.beneficiaries.beneficiary.isEmpty()) {    
                                    for(Integer i = 0; i < responseWp.Out_ConsultaBeneficiarios.employedServiceRs.beneficiaries.beneficiary.size(); i++) {
                                        People__c beneficiary = new People__c(
                                            isUpdateData__c     = (responseWp.Out_ConsultaBeneficiarios.employedServiceRs.beneficiaries.beneficiary[i].isUpdateData != null)?Boolean.valueOf(responseWp.Out_ConsultaBeneficiarios.employedServiceRs.beneficiaries.beneficiary[i].isUpdateData): false,
                                            Name__c             = responseWp.Out_ConsultaBeneficiarios.employedServiceRs.beneficiaries.beneficiary[i].name,
                                            FatherLastName__c   = responseWp.Out_ConsultaBeneficiarios.employedServiceRs.beneficiaries.beneficiary[i].paternalLastName,
                                            MaternalLastName__c = responseWp.Out_ConsultaBeneficiarios.employedServiceRs.beneficiaries.beneficiary[i].maternalLastName,
                                            Gender__c           = responseWp.Out_ConsultaBeneficiarios.employedServiceRs.beneficiaries.beneficiary[i].gender,
                                            BirthDate__c        = (responseWp.Out_ConsultaBeneficiarios.employedServiceRs.beneficiaries.beneficiary[i].birthDate != null && !String.isBlank(responseWp.Out_ConsultaBeneficiarios.employedServiceRs.beneficiaries.beneficiary[i].birthDate)) ? Date.valueOf(responseWp.Out_ConsultaBeneficiarios.employedServiceRs.beneficiaries.beneficiary[i].birthDate) : null,
                                            BirthState__c       = responseWp.Out_ConsultaBeneficiarios.employedServiceRs.beneficiaries.beneficiary[i].birthState,
                                            CURP__c             = responseWp.Out_ConsultaBeneficiarios.employedServiceRs.beneficiaries.beneficiary[i].curp,
                                            Relationship__c     = responseWp.Out_ConsultaBeneficiarios.employedServiceRs.beneficiaries.beneficiary[i].relationship,
                                            Phone__c            = responseWp.Out_ConsultaBeneficiarios.employedServiceRs.beneficiaries.beneficiary[i].phone,
                                            PhoneType__c        = responseWp.Out_ConsultaBeneficiarios.employedServiceRs.beneficiaries.beneficiary[i].phoneType,
                                            Percentage__c       = responseWp.Out_ConsultaBeneficiarios.employedServiceRs.beneficiaries.beneficiary[i].percentage,
                                            Bank__c             = responseWp.Out_ConsultaBeneficiarios.employedServiceRs.beneficiaries.beneficiary[i].bank,
                                            Bank_Account__c     = responseWp.Out_ConsultaBeneficiarios.employedServiceRs.beneficiaries.beneficiary[i].account,
                                            CLABE__c            = responseWp.Out_ConsultaBeneficiarios.employedServiceRs.beneficiaries.beneficiary[i].clabeAccount
                                        );
                                        lstfoundDocuments.add(beneficiary);
                                    }
                                }
                            }
                        }
                    }
                }
            }  

        }
        if(blnServiceHadError == true) {
            //AAZ_Utils_cls.insertIncidence(stgMessage,stgtype,idCurrentCase,idCurrentId);
        }   
        return lstfoundDocuments;
    }

     @TestVisible public class ResponseWrapper {
        public  BeneficaryRs Out_ConsultaBeneficiarios;
    }

     @TestVisible public class BeneficaryRs {
        public  BeneficaryData employedServiceRs;
    }

     @TestVisible public class BeneficaryData {
        public String isSucessful;
        public Beneficiary beneficiaries;
        //ErrorIm errorList;
        public List<Error> errorItem;

    }

     @TestVisible public class Beneficiary {
        public List<BeneficiaryCase> beneficiary;
    }

     @TestVisible public class BeneficiaryCase {

        public String isUpdateData;
        public String name;
        public String paternalLastName;
        public String maternalLastName;
        public String gender;
        public String birthDate;
        public String birthState;
        public String curp;
        public String relationship;
        public String phone;
        public String phoneType;
        public String percentage;
        public String bank;
        public String account;
        public String clabeAccount;
        
    }

     @TestVisible public class ErrorIm {
        public List<Error> errorItem;
    }

     @TestVisible public class Error {
        public String code;
        public String description;
    }
}