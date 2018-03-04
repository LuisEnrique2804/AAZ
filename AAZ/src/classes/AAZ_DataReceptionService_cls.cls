/*******************************************************************************
Desarrollado por: Avanxo México
Autor: Daniel Peñaloza
Proyecto: Banco Azteca - Afore
Descripción: Clase para servicio de Recepción de Archivos (huellas dactilares)

------ ---------- -------------------------- -----------------------------------
No.    Fecha      Autor                      Descripción
------ ---------- -------------------------- -----------------------------------
1.0    26/07/2017 Daniel Peñaloza            Clase creada

WS010
*******************************************************************************/

public class AAZ_DataReceptionService_cls {

    public static String strBase64;
    private static final String STR_SENDDATA = 'Afore_ReceptionData';
    
    // Cargar los mainsettings para las clases de prueba
    public static AppMainSetting_cs__c mainSettings = Test.isRunningTest()?
        AAZ_TestUtils_tst.getMainSettings() : AppMainSetting_cs__c.getOrgDefaults();

    // Enviar datos de huellas dactilares al servicio de recepción de datos
    public static Boolean sendData( AAZ_DataReceptionService_cls.SendDataParamsWrapper paramsInstance) {
        SendDataGrossResponse responseWrapper = new SendDataGrossResponse();
        Boolean blnResult = false;
        String strJsonRequest = '';
        String strJsonResponse = '';
        Map<String, Object> mapRequest = new Map<String,Object>{
            'In_RecepcionArchivos' => new Map<String,Object>{
                'xmlns' => 'http://www.baz.com.mx/corporate/mexico/business/enrrolamiento/1.0',
                'docServiceRq' => new Map<String,Object>{
                    'nss' => paramsInstance.strNSS,       
                    'folio' => paramsInstance.strFolio,       
                    'idArchivo' => paramsInstance.strIdArchivo,    
                    'parte' => 1,      
                    'total' => 1,    
                    'formato' => 'json',       
                    'archivoBase64' => strBase64,
                    'typo de servicio' =>paramsInstance.strProcedureTypeCode
                }
            }
        };
        try{strJsonRequest = JSON.serializePretty(mapRequest);}catch(SerializationException sE){}catch(Exception gE){} 
        System.debug('strJsonRequest : '+strJsonRequest);
        if(!String.isBlank(strJsonRequest)){
            try{strJsonResponse = AAZ_GenericCallout_cls.fn_runCallout(strJsonRequest, STR_SENDDATA, null);}catch(CalloutException cE){}catch(UnexpectedException uE){}catch(Exception gE){}
            System.debug('strJsonResponse : '+strJsonResponse);
        }
        try{responseWrapper = (SendDataGrossResponse)JSON.deserialize(strJsonResponse, SendDataGrossResponse.class);}catch(SerializationException sE){}catch(Exception gE){} 
        if(responseWrapper.Out_RecepcionArchivos != null){
            if(responseWrapper.Out_RecepcionArchivos.docServiceRs != null){
                if(responseWrapper.Out_RecepcionArchivos.docServiceRs.codError == '0'){
                    blnResult = true;
                }
            }
        }
        return blnResult;        
    }

    public class SendDataGrossResponse{
        public SenDataGrossMain Out_RecepcionArchivos;
    }

    public class SenDataGrossMain{
        SendDataLeaves docServiceRs;
    }

    public class SendDataLeaves{
        public String codError;
        public String msjError;
    }

    public class SendDataParamsWrapper{
        public String strNSS;
        public String strFolio;
        public Integer strIdArchivo;
        public String strTipoServicio;
        public String strProcedureTypeCode;
    }

}