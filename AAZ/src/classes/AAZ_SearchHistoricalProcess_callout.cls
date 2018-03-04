global class AAZ_SearchHistoricalProcess_callout
{
   private static final String strConfigName = 'SearchHistoricalProcess';
    
    // Cargar los mainsettings para las clases de prueba
    public static AppMainSetting_cs__c mainSettings = Test.isRunningTest()?
        AAZ_TestUtils_tst.getMainSettings() : AppMainSetting_cs__c.getOrgDefaults();


   public class SearchObject
   {
       
        public String    startDate=''; 
        public String    endDate ='';
        public String    nss =''; 
        public String    curp =''; 
        public String    rfc =''; 
        public String    status =''; 
        public String    serviceType =''; 
        public String    serviceSubType =''; 
        public String    withdrawtype ='';
        public String    securitytype ='';
        public String    pensiontype ='';
        public String    regimeType ='';
        public String    divisional ='';
        public String    estate ='';
        public String    municipality =''; 
        public String    regional ='';
        public String    implement ='';
        public String    promoterAgent ='';
        public String    analistValidate ='';
        public String    apNumber ='';
        public String    idSearch = '';
       
   }
   
    public static ResponseWrapper callOut(SearchObject objParameter) {
      
        String strJsonRequest='[]';
        String strJsonResponse='';
        ResponseWrapper     responseWp  = new ResponseWrapper();

        strJsonRequest = JSON.serializePretty(
            new Map<String,Object>
            {
                'numeroAP' => objParameter.apNumber,
                'analistaValidador' => objParameter.analistValidate,
                'agentePromotor' => objParameter.promoterAgent,
                'implementador' => objParameter.implement,
                'regional' => objParameter.regional,
                'municipio' => objParameter.municipality, 
                'estado' => objParameter.estate,
                'divisional' => objParameter.divisional,
                'tipoRegimen' => objParameter.regimeType,
                'tipoPension' => objParameter.pensiontype,
                'tipoSeguro' => objParameter.securitytype,
                'tipoRetiro' => objParameter.withdrawtype,
                'subtipoServicio' => objParameter.serviceSubType, 
                'tipoServicio' => objParameter.serviceType, 
                'estatus' => objParameter.status, 
                'rfc' => objParameter.rfc, 
                'curp' => objParameter.curp, 
                'nss' => objParameter.nss, 
                'fechaFin' => objParameter.endDate,
                'fechaInicio' => objParameter.startDate,
                'Id' => objParameter.idSearch
                    //"NombreAP":"TEST",
                    //"email":"TEST"
            }
        );
      
        try
        {
            System.debug(loggingLevel.Error, '*** strJsonRequest: ' + strJsonRequest);
            //llama al servicio
            strJsonResponse = AAZ_GenericCallout_cls.fn_runCallout(strJsonRequest, strConfigName, null);
            System.debug('strJsonResponse = '+strJsonResponse);
            responseWp = (ResponseWrapper)JSON.deserialize(strJsonResponse, ResponseWrapper.class);
            System.debug(loggingLevel.Error, '*** strJsonResponse: ' + strJsonResponse);
            System.debug(loggingLevel.Error, '*** responseWp: ' + responseWp);
        }
        catch(Exception gE)
        { 
            System.debug(loggingLevel.Error, '*** ge: ' + ge.getMessage() );
        }
     
        System.debug(loggingLevel.Error, '*** strJsonResponse: ' + strJsonResponse);
        System.debug('IVAN = '+ responseWp);
        return responseWp;
    }

    @TestVisible public class ResponseWrapper {
        public HistoricalRS Out_ConsultaHistoricos;
    }

    @TestVisible public class HistoricalRS {
        public Boolean isSucessful;
        public Error errorList;

    }

     @TestVisible public class Error {
        public String code;
        public String description;
    }
}