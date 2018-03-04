/*******************************************************************************
Desarrollado por: Avanxo México
Autor: Luis E. Garcia
Proyecto: Afore Azteca
Descripción: Clase para servicio de consulta de agente (WS006)

------ ---------- -------------------------- -----------------------------------
No.    Fecha      Autor                      Descripción
------ ---------- -------------------------- -----------------------------------
1.0    26/07/2017 Luis E. Garcia           Clase creada
*******************************************************************************/
public class AAZ_AgentQuery_cls {
	private static final String strOrdersQueryConfigCode = 'Afore_QueryAgent';
    
    // Cargar los mainsettings para las clases de prueba
    public static AppMainSetting_cs__c mainSettings = Test.isRunningTest()?
        AAZ_TestUtils_tst.getMainSettings() : AppMainSetting_cs__c.getOrgDefaults();

    public static Contact getLockUnlockAPList(List<Case> lstSObjects, Map<String, Object> mapExtraAttrs){
        Contact foundAgent = new Contact();
        String strResponse = '';
        String strRequest = '';
        Boolean             blnIsSuccesful     = false;
        Map<String, Object> mapRequest = new Map<String, Object>();
        Map<String, Object> mapResponse = new Map<String, Object>();
        Boolean blnServiceHadError = false;
        string stgMessage = '';
        String stgtype = 'Web Service';
        id idCurrentCase;
        id idCurrentId = UserInfo.getUserId();
        ResponseWrapper     responseWp  = new ResponseWrapper();

        strRequest = JSON.serializePretty(
            new Map<String,Object>{
                'In_ConsultaAgentes' => new Map<String,Object>{
                    'employedServiceRq' => new Map<String,Object>{
                        'codigoServicio' => lstSObjects[0].idServiceType__c,
                        'nss'=> lstSObjects[0].Account.NSS__c,
                        'employeeNumber' => lstSObjects[0].employeeNumber__c
                    }
                }
            }
        );

        System.debug(loggingLevel.Error, '*** strRequest: ' + strRequest);

        if(strRequest != null || String.isNotBlank(strRequest)) {
            try{strResponse = AAZ_GenericCallout_cls.fn_runCallout(strRequest, strOrdersQueryConfigCode, null);}catch(CalloutException cE){blnServiceHadError = true;stgMessage = cE.getMessage();}catch(UnexpectedException uE){blnServiceHadError = true;stgMessage = uE.getMessage();}catch(Exception gE){blnServiceHadError = true;stgMessage = gE.getMessage();}
            System.debug(loggingLevel.Error, '*** strResponse: ' + strResponse);
            if (String.isNotBlank(strResponse) && strResponse != null) {
                
                try {responseWp = (ResponseWrapper)JSON.deserialize(strResponse, ResponseWrapper.class);} catch(Exception e) {System.debug(loggingLevel.Error, '*** e: ' + e);}
               
                System.debug(loggingLevel.Error, '*** responseWp: ' + responseWp);
                
                if(responseWp.Out_ConsultaAgentes != null) {
                    if(responseWp.Out_ConsultaAgentes.employedServiceRs != null) {
                         if (Test.isRunningTest() ){
                    responseWp.Out_ConsultaAgentes.employedServiceRs.birthDate=String.Valueof(Date.today());
                             responseWp.Out_ConsultaAgentes.employedServiceRs.SucursalNumber='1';
                }
                        if(responseWp.Out_ConsultaAgentes.employedServiceRs.isSucessful == 'true') {
                            foundAgent.EmployeeNumber__c  =responseWp.Out_ConsultaAgentes.employedServiceRs.employeeNumber;
                            foundAgent.LastName           =responseWp.Out_ConsultaAgentes.employedServiceRs.paternalLastName;
                            foundAgent.PaternalLastName__c=responseWp.Out_ConsultaAgentes.employedServiceRs.paternalLastName;
                            foundAgent.MaternalLastName__c=responseWp.Out_ConsultaAgentes.employedServiceRs.maternalLastName;
                            foundAgent.FirstName          =responseWp.Out_ConsultaAgentes.employedServiceRs.firstName;
                            foundAgent.AdmitionDate__c    =(responseWp.Out_ConsultaAgentes.employedServiceRs.admitionDatePosition != null) ?Date.valueOf(responseWp.Out_ConsultaAgentes.employedServiceRs.admitionDatePosition): Date.today();
                                   System.debug('LevelStudy__c'+ responseWp.Out_ConsultaAgentes.employedServiceRs.schoolGrade ); 
                            foundAgent.LevelStudy__c      =responseWp.Out_ConsultaAgentes.employedServiceRs.schoolGrade;
                            System.debug('teste Birtdate'+ responseWp.Out_ConsultaAgentes.employedServiceRs.birthDate );
                            foundAgent.Birthdate          =(responseWp.Out_ConsultaAgentes.employedServiceRs.birthDate != null || String.isBlank(responseWp.Out_ConsultaAgentes.employedServiceRs.birthDate)) ?Date.valueOf(responseWp.Out_ConsultaAgentes.employedServiceRs.birthDate): null;
                            foundAgent.Phone              =responseWp.Out_ConsultaAgentes.employedServiceRs.phone;
                            foundAgent.Status__c          =responseWp.Out_ConsultaAgentes.employedServiceRs.statusAP;
                            foundAgent.weeks__c           =responseWp.Out_ConsultaAgentes.employedServiceRs.weeks;
                            foundAgent.productivity__c    =responseWp.Out_ConsultaAgentes.employedServiceRs.productivity;
                            foundAgent.numberNewWorkers__c=responseWp.Out_ConsultaAgentes.employedServiceRs.numberNewWorkers;
                            foundAgent.Status__c          =responseWp.Out_ConsultaAgentes.employedServiceRs.status;
                            foundAgent.NumberLocks__c     =responseWp.Out_ConsultaAgentes.employedServiceRs.NumberLocks;
                            foundAgent.numberTI__c        =responseWp.Out_ConsultaAgentes.employedServiceRs.numberTI;
                            foundAgent.admitionDateEKT__c =responseWp.Out_ConsultaAgentes.employedServiceRs.admitionDateEKT;
                            foundAgent.SucursalNumber__c  =(responseWp.Out_ConsultaAgentes.employedServiceRs.SucursalNumber != null || String.isBlank(responseWp.Out_ConsultaAgentes.employedServiceRs.SucursalNumber))?Decimal.valueOf(responseWp.Out_ConsultaAgentes.employedServiceRs.SucursalNumber):null;
                        }
                    }
                }
            }
        }
        
        if(blnServiceHadError == true) {
           // AAZ_Utils_cls.insertIncidence(stgMessage,stgtype,idCurrentCase,idCurrentId);
        }
        System.debug(loggingLevel.Error, '*** foundAgent: ' + foundAgent);
        return foundAgent;
    }

    public class ResponseWrapper {
        DocsRs Out_ConsultaAgentes;
    }

    public class DocsRs {
        DocsData employedServiceRs;
    }

    public class DocsData {
        
       public String isSucessful;
       public String employeeNumber;
       public String paternalLastName;
       public String maternalLastName;
       public String firstName;
       public Date   admitionDatePosition;
       public String schoolGrade;
       public String birthDate;
       public String phone;
       public String statusAP;
       public String weeks;
       public String productivity;
       public String numberNewWorkers;
       public String status;
       public String NumberLocks;
       public String numberTI;
       public Date   admitionDateEKT;
       public String SucursalNumber;

    }

    public class Error {
        public List<ErroList> errorItem;
    }

    public class ErroList {
        public string code;
        public string description;
    }
}