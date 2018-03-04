public class AAZ_PromoterDocumentsService_cls {

    private static final String STR_PROMDOCSSENDSERVCONF = 'Afore_DocAP';
    
    // Cargar los mainsettings para las clases de prueba
    public static AppMainSetting_cs__c mainSettings = Test.isRunningTest()?
        AAZ_TestUtils_tst.getMainSettings() : AppMainSetting_cs__c.getOrgDefaults();

    public static PromoterAgentDocsWrapperAnswer sendFormats(List<SObject> lstRequestObjects, Map<String, Object> mapExtraAttrs) {
        PromoterAgentDocsWrapperAnswer responseWpInstance = new PromoterAgentDocsWrapperAnswer();
        Map<String, Object> mapRequest = new Map<String, Object>();
        String strJsonRequest = '';
        String strJsonResponse = '';
        System.debug('Primer antes query--lstRequestObjects='+ lstRequestObjects +' y el mapa es ='+mapExtraAttrs);
        try{mapRequest = AAZ_GenericCallout_cls.generateRequestMap(STR_PROMDOCSSENDSERVCONF,lstRequestObjects,mapExtraAttrs);}catch(NullPointerException nPE){ throw nPE;}catch(UnexpectedException uE){throw uE;}catch(Exception gE){throw gE;}
        System.debug('mapRequest : '+mapRequest);
        if(!mapRequest.isEmpty()){    
            try{strJsonRequest = JSON.serializePretty(mapRequest);}catch(SerializationException sE){}catch(Exception gE){} 
            if(!String.isBlank(strJsonRequest) && strJsonRequest != null){    
                System.debug('strJsonRequest : '+strJsonRequest);
                try{strJsonResponse = AAZ_GenericCallout_cls.fn_runCallout(strJsonRequest, STR_PROMDOCSSENDSERVCONF, null);}catch(CalloutException cE){}catch(UnexpectedException uE){}catch(Exception gE){}
                System.debug('strJsonResponse : '+strJsonResponse);
                if(String.isNotBlank(strJsonResponse) && strJsonResponse != null){
                    try {responseWpInstance = (PromoterAgentDocsWrapperAnswer)JSON.deserialize(strJsonResponse, PromoterAgentDocsWrapperAnswer.class);}catch(SerializationException sE){}catch(Exception gE){}
                }
            } 
        }
        System.debug('responseWpInstance : '+responseWpInstance);
        return responseWpInstance;
    }

    public class PromoterAgentDocsWrapperAnswer {
        public ApproveServiceRs Out_DocumentosPromotor;
    }

    public class ApproveServiceRs {
        public BeneficaryData approveServiceRs;
    }

    public class BeneficaryData {
        public String strDocURL;
        public String isSucessful; 
        public string comments;
        public ErrorListEstct errorList;
    }

    public class ErrorListEstct {
        public List<Error> errorItem;
    }

    public class Error {
        public String code;
        public String description;
    }

}