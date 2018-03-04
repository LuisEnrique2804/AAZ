/*******************************************************************************
Desarrollado por: Avanxo México
Autor: Luis E. Garcia
Proyecto: Afore Azteca
Descripción: Clase para servicio de consulta de sucursal (WS015)

------ ---------- -------------------------- -----------------------------------
No.    Fecha      Autor                      Descripción
------ ---------- -------------------------- -----------------------------------
1.0    26/07/2017 Luis E. Garcia           Clase creada
*******************************************************************************/
public class AAZ_SubsidiaryQuery_cls {
	private static final String strOrdersQueryConfigCode = 'Afore_QuerySubsidiary';
    
    // Cargar los mainsettings para las clases de prueba
    AppMainSetting_cs__c mainSettings = Test.isRunningTest()?
        AAZ_TestUtils_tst.getMainSettings() : AppMainSetting_cs__c.getOrgDefaults();

    /*
        Método que efectúa la búsqueda de sucursales y la almacena en el objeto "Case"
    */

    public static Case getSubsidiaryList(Id idCasewithContact, Map<String, Object> mapExtraAttrs){
        String stgMessage = '';
        String stgtype = 'Web Service';
        Boolean blnSuccessfulProcess = false;
        Id idCurrentId = UserInfo.getUserId(); 
        Case foundSubsidiary = new Case();
        Map<String, Object> mapRequest  = new Map<String, Object>();
        String strRequest = '';
        String strResponse = '';
        ResponseWrapper     responseWp  = new ResponseWrapper();
        String strSucursalNumber = 'SELECT Subsidiary__c, Contact.SucursalNumber__c, AP__r.SucursalNumber__c FROM Case WHERE id =\''+idCasewithContact+'\'';
        List<Case> lstSucursalNumber = Database.query(strSucursalNumber);
        System.debug(loggingLevel.Error, '*** lstSucursalNumber: ' + lstSucursalNumber);
        
        try{
            strRequest = JSON.serializePretty(
                new Map<String,Object>{ 'In_ConsultaSucursales' => new Map<String,Object>{
                    'employedServiceRq' => new Map<String,Object>{
                        'numeroSucursal' => lstSucursalNumber[0].Subsidiary__c
                    }
                }
            });
            }catch(SerializationException sE){stgMessage = sE.getMessage();}catch(Exception gE){stgMessage = gE.getMessage();}   
        System.debug('strRequest : '+strRequest);
        if(strRequest != null || String.isNotBlank(strRequest)) {
            strResponse = AAZ_GenericCallout_cls.fn_runCallout(strRequest, strOrdersQueryConfigCode, null);
            //try{strResponse = AAZ_GenericCallout_cls.fn_runCallout(strRequest, strOrdersQueryConfigCode, null);}catch(CalloutException cE){stgMessage = cE.getMessage();}catch(UnexpectedException uE){stgMessage = uE.getMessage();}catch(Exception gE){stgMessage = gE.getMessage();}
            if (String.isNotBlank(strResponse) && strResponse != null) {
                try {responseWp = (ResponseWrapper)JSON.deserialize(strResponse, ResponseWrapper.class);} catch(Exception e) {System.debug(loggingLevel.Error, '*** e: ' + e);}
                System.debug(loggingLevel.Error, '*** responseWp: ' + responseWp);
                if(responseWp.Out_ConsultaSucursales != null) {
                    if(responseWp.Out_ConsultaSucursales.employedServiceRs != null) {
                        if(responseWp.Out_ConsultaSucursales.employedServiceRs.isSucessful == 'true') {
                            foundSubsidiary = new Case(
                                sucursalName__c           = responseWp.Out_ConsultaSucursales.employedServiceRs.sucursalName,
                                sucursalEconomicNumber__c = responseWp.Out_ConsultaSucursales.employedServiceRs.sucursalEconomicNumber,
                                phoneSucursal__c          = responseWp.Out_ConsultaSucursales.employedServiceRs.phoneSucursal,
                                RegionalName__c           = responseWp.Out_ConsultaSucursales.employedServiceRs.regionalName,
                                PhoneRegional__c          = responseWp.Out_ConsultaSucursales.employedServiceRs.regionalPhone,
                                IdCC__c                   = responseWp.Out_ConsultaSucursales.employedServiceRs.IdCC,
                                idEntity__c               = responseWp.Out_ConsultaSucursales.employedServiceRs.idEntity,
                                chanel__c                 = responseWp.Out_ConsultaSucursales.employedServiceRs.chanel,
                                ccRegional__c             = responseWp.Out_ConsultaSucursales.employedServiceRs.ccRegional,
                                ccZone__c                 = responseWp.Out_ConsultaSucursales.employedServiceRs.ccZone,
                                zoneSF__c                 = responseWp.Out_ConsultaSucursales.employedServiceRs.zoneSF,
                                ccTerritorial__c          = responseWp.Out_ConsultaSucursales.employedServiceRs.ccTerritorial,
                                territorialSF__c          = responseWp.Out_ConsultaSucursales.employedServiceRs.territorialSF,
                                ccImplement__c            = responseWp.Out_ConsultaSucursales.employedServiceRs.ccImplement,
                                Implement__c              = responseWp.Out_ConsultaSucursales.employedServiceRs.Implement,
                                employeImplement__c       = responseWp.Out_ConsultaSucursales.employedServiceRs.employeImplement,
                                ImplementName__c          = responseWp.Out_ConsultaSucursales.employedServiceRs.ImplementName,
                                phoneImplement__c         = responseWp.Out_ConsultaSucursales.employedServiceRs.phoneImplement,
                                implementEmail__c         = responseWp.Out_ConsultaSucursales.employedServiceRs.implementEmail,
                                ccDivisional__c           = responseWp.Out_ConsultaSucursales.employedServiceRs.ccDivisional,
                                employeDivisional__c      = responseWp.Out_ConsultaSucursales.employedServiceRs.employeDivisional,
                                divisionalName__c         = responseWp.Out_ConsultaSucursales.employedServiceRs.divisionalName,
                                divisionalPhone__c        = responseWp.Out_ConsultaSucursales.employedServiceRs.divisionalPhone,
                                divisionalEmail__c        = responseWp.Out_ConsultaSucursales.employedServiceRs.divisionalEmail
                            );
                             
                                 
                        }
                    }
                }
            }
        }

        if(!blnSuccessfulProcess) {
            if(strResponse != null && !String.isEmpty(strResponse)){
                //AAZ_Utils_cls.insertIncidence(stgMessage,stgtype,null,idCurrentId);
            }
        }
        return foundSubsidiary;
    }

    public class ResponseWrapper {
        public SubsidaryRsp Out_ConsultaSucursales;
    }

    public class SubsidaryRsp {
        public SucursalData employedServiceRs;
    }

    public class SucursalData {
        public String isSucessful;
        public String sucursalName;
        public String sucursalEconomicNumber;
        public String phoneSucursal;
        public String regionalName;
        public String zone;
        public String regionalPhone;
        public String IdCC;
        public String idEntity;
        public String chanel;
        public String ccRegional;
        public String ccZone;
        public String zoneSF;
        public String ccTerritorial;
        public String territorialSF;
        public String ccImplement;
        public String Implement;
        public String employeImplement;
        public String ImplementName;
        public String phoneImplement;
        public String implementEmail;
        public String ccDivisional;
        public String employeDivisional;
        public String divisionalName;
        public String divisionalPhone;
        public String divisionalEmail;

        ErrorIm errorList;

    }

    public class ErrorIm {
        List<Error> errorItem;
    }

    public class Error {
        String code;
        String description;
    }

}