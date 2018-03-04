/*******************************************************************************
Desarrollado por: Avanxo México
Autor: Daniel Peñaloza
Proyecto: Banco Azteca - Afore
Descripción: Clase para servicio de Consulta de Estatus y Registro de Componentes

------ ---------- -------------------------- -----------------------------------
No.    Fecha      Autor                      Descripción
------ ---------- -------------------------- -----------------------------------
1.0    26/07/2017 Daniel Peñaloza            Clase creada

WS008, WS009
*******************************************************************************/

public class AAZ_ComponentsService_cls {

	private static final String STR_REGCOMPSERV = 'Afore_ComponentSign';
    private static final String STR_COMPSTAT = 'Afore_ComponentStatus'; 
    
    // Cargar los mainsettings para las clases de prueba
    public static AppMainSetting_cs__c mainSettings = Test.isRunningTest()?
        AAZ_TestUtils_tst.getMainSettings() : AppMainSetting_cs__c.getOrgDefaults();

    // Registro de componente
    public static Boolean registerComponent(RegisterComponentParamsWrapper paramsInstance) {
        Boolean blnResult = false;
        RegisterComponentGrossResponse responseWrapper = new RegisterComponentGrossResponse();
        String strJsonRequest = '';
        String strJsonResponse = '';
        Map<String, Object> mapRequest = new Map<String,Object>{
            'In_RegistraComponente' => new Map<String,Object>{
                'xmlns' => 'http://www.baz.com.mx/corporate/mexico/business/enrrolamiento/1.0',
                'docServiceRq' => new Map<String,Object>{
                    'folio' => ''+paramsInstance.strFolio,
                    'nss' => paramsInstance.strNss,
                    'nombreComponente' => 'VALID_MESA',
                    'aplicacion' => 'MC'     
                }
            }
        };
        try{strJsonRequest = JSON.serializePretty(mapRequest);}catch(SerializationException sE){}catch(Exception gE){} 
        System.debug('strJsonRequest : '+strJsonRequest);
        if(!String.isBlank(strJsonRequest)){
            try{strJsonResponse = AAZ_GenericCallout_cls.fn_runCallout(strJsonRequest, STR_REGCOMPSERV, null);}catch(CalloutException cE){}catch(UnexpectedException uE){}catch(Exception gE){}
            System.debug('strJsonResponse : '+strJsonResponse);
        }
        try{responseWrapper = (RegisterComponentGrossResponse)JSON.deserialize(strJsonResponse, RegisterComponentGrossResponse.class);}catch(SerializationException sE){}catch(Exception gE){} 
        System.debug('responseWrapper : '+responseWrapper);
        if(responseWrapper.Out_RegistraComponente != null){
            if(responseWrapper.Out_RegistraComponente.docServiceRs != null){
                if(responseWrapper.Out_RegistraComponente.docServiceRs.codError != null){
                    if(responseWrapper.Out_RegistraComponente.docServiceRs.codError.equalsIgnoreCase('0')){
                        blnResult = true;
                    }
                }
            }
        }
        return blnResult;
    }

    // Obtener estatus de componente
    public static AAZ_DocumentValidate_ctr.StatusComponentResultWrapper getComponentStatus(StatusComponentParamsWrapper paramsInstance) {
        AAZ_DocumentValidate_ctr.StatusComponentResultWrapper statusWrapperInstance = new AAZ_DocumentValidate_ctr.StatusComponentResultWrapper();
        StatusComponentWrapper responseWrapper = new StatusComponentWrapper();
        String strJsonRequest = '';
        String strJsonResponse = '';
        Map<String, Object> mapRequest = new Map<String,Object>{
            'In_ConsultaEstatus' => new Map<String,Object>{
                'xmlns' => 'http://www.baz.com.mx/corporate/mexico/business/enrrolamiento/1.0',
                'docServiceRq' => new Map<String,Object>{
                    'nss' => paramsInstance.strNss,
                    'folio' => paramsInstance.strFolio,
                    'nombreComponente' => 'VALID_MESA'       
                }
            }
        };
        try{strJsonRequest = JSON.serializePretty(mapRequest);}catch(SerializationException sE){}catch(Exception gE){} 
        System.debug('strJsonRequest : '+strJsonRequest);
        if(!String.isBlank(strJsonRequest)){
            try{strJsonResponse = AAZ_GenericCallout_cls.fn_runCallout(strJsonRequest, STR_COMPSTAT, null);}catch(CalloutException cE){}catch(UnexpectedException uE){}catch(Exception gE){}
            System.debug('strJsonResponse : '+strJsonResponse);
        }
        try{responseWrapper = (StatusComponentWrapper)JSON.deserialize(strJsonResponse, StatusComponentWrapper.class);}catch(SerializationException sE){}catch(Exception gE){} 
        System.debug('responseWrapper : '+responseWrapper);
        if(responseWrapper.Out_ConsultaEstatus != null){
            if(responseWrapper.Out_ConsultaEstatus.docServiceRs != null){
                if(responseWrapper.Out_ConsultaEstatus.docServiceRs.estatus != null){
                    if(responseWrapper.Out_ConsultaEstatus.docServiceRs.respuestaComp != null){
                        if(responseWrapper.Out_ConsultaEstatus.docServiceRs.estatus != null){
                            statusWrapperInstance.blnIsSuccessful = (responseWrapper.Out_ConsultaEstatus.docServiceRs.estatus == '2')?true:false;
                            statusWrapperInstance.lstBase64FingerPrints = new List<String>{responseWrapper.Out_ConsultaEstatus.docServiceRs.respuestaComp};
                        }
                    }
                }
            }
        }
        return statusWrapperInstance;
    }


    public class StatusComponentWrapper{
        public DocServiceResponse Out_ConsultaEstatus;
        public StatusComponentWrapper(){
            Out_ConsultaEstatus = new DocServiceResponse();
        }
    }

    public class DocServiceResponse{
        public DocServiceResponseData docServiceRs;
        public DocServiceResponse(){
            docServiceRs = new DocServiceResponseData();
        }
    }

    public class DocServiceResponseData{
        public String estatus;
        public String respuestaComp;
        public DocServiceResponseData(){
            estatus = '';
            respuestaComp = '';
        }
    }

    public class RegisterComponentGrossResponse{
        public RegisterComponentGrossMain Out_RegistraComponente;
        public RegisterComponentGrossResponse(){
            Out_RegistraComponente = new RegisterComponentGrossMain();
        }
    }

    public class RegisterComponentGrossMain{
        public RegisterComponentLeaves docServiceRs;
        public void RegisterComponentGrossMain(){
            docServiceRs = new RegisterComponentLeaves();
        }
    }

    public class RegisterComponentLeaves{
        public String codError;
        public String msjError;
        public RegisterComponentLeaves(){
            codError = '';
            msjError = '';
        }
    }

    public class RegisterComponentParamsWrapper{
        public String strNss;
        public String strFolio;
    }

    public class StatusComponentParamsWrapper{
        public String strNss;
        public String strFolio;
    }

}