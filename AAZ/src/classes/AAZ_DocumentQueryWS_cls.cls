/*******************************************************************************
Desarrollado por: Avanxo México
Autor: Luis E. Garcia
Proyecto: Afore Azteca
Descripción: Clase para servicio de consulta de documento (WS007)

------ ---------- -------------------------- -----------------------------------
No.    Fecha      Autor                      Descripción
------ ---------- -------------------------- -----------------------------------
1.0    26/07/2017 Luis E. Garcia           Clase creada
*******************************************************************************/
public class AAZ_DocumentQueryWS_cls {

	private static final String STR_DOCQUERYSERVICECODE = 'Afore_QueryDocument';
    
    // Cargar los mainsettings para las clases de prueba
   public static  AppMainSetting_cs__c mainSettings = Test.isRunningTest()?
        AAZ_TestUtils_tst.getMainSettings() : AppMainSetting_cs__c.getOrgDefaults();

    public static List<Document__c> getDocList(List<Case> lstSObjects, Map<String, Object> mapExtraAttrs){
        Boolean blnSuccessfulProcess = false;
        Boolean blnWasThereAnException = false;
        String strRequest = '';
        List<Document__c> lstfoundDocuments = new List<Document__c>();
        Map<String, Object> mapRequest = new Map<String, Object>();
        mapExtraAttrs.put('source','MValidacion');
        string stgMessage = '';
        String strExcptnType = '';
        Id idCurrentId = UserInfo.getUserId();
        String strResponse = '';
        ResponseWrapper     responseWp  = new ResponseWrapper();
        
        for(Integer x = 0; x < lstSObjects.size(); x++) {
            strRequest = JSON.serializePretty(
                new Map<String,Object>{
                    'In_ConsultaDocumentos' => new Map<String,Object>{
                        'docServiceRq' => new Map<String,Object>{
                            'codigoServicio' => lstSObjects[x].idServiceType__c,
                            'employeeNumber' => (lstSObjects[x].employeeNumber__c == null)?lstSObjects[x].Contact.EmployeeNumber__c:lstSObjects[x].employeeNumber__c,
                            'folio' => lstSObjects[x].FolioNSS__c,
                            'nss' =>  (lstSObjects[x].Account.NSS__c == null)?lstSObjects[x].APValidationContact__r.NSS__c:lstSObjects[x].Account.NSS__c
                        }
                    }
                }
            );
        
            System.debug(loggingLevel.Error, '*** strRequest: ' + strRequest);
            if(strRequest != null || String.isNotBlank(strRequest)) {
                try{strResponse = AAZ_GenericCallout_cls.fn_runCallout(strRequest, STR_DOCQUERYSERVICECODE, null);}catch(CalloutException cE){stgMessage = cE.getMessage();}catch(UnexpectedException uE){stgMessage = uE.getMessage();}catch(Exception gE){stgMessage = gE.getMessage();}
                System.debug(loggingLevel.Error, '*** strResponse: ' + strResponse);
                if (String.isNotBlank(strResponse) && strResponse != null) {
                    try {responseWp = (ResponseWrapper)JSON.deserialize(strResponse, ResponseWrapper.class);} catch(Exception e) {System.debug(loggingLevel.Error, '*** e: ' + e);}
                    System.debug(loggingLevel.Error, '*** responseWp: ' + responseWp);
                    if(responseWp.Out_ConsultaDocumentos != null) {
                        if(responseWp.Out_ConsultaDocumentos.docServiceRs != null) {
                            if(!responseWp.Out_ConsultaDocumentos.docServiceRs.docsDigitalizados.isEmpty()) {    
                                for(Integer i = 0; i < responseWp.Out_ConsultaDocumentos.docServiceRs.docsDigitalizados.size(); i++) {
                                    Document__c documents = new Document__c(
                                        Orden__c          = responseWp.Out_ConsultaDocumentos.docServiceRs.docsDigitalizados[i].orden,
                                        FileURL__c        = responseWp.Out_ConsultaDocumentos.docServiceRs.docsDigitalizados[i].ruta,
                                        DocName__c        = responseWp.Out_ConsultaDocumentos.docServiceRs.docsDigitalizados[i].digitalNumber,
                                        DocumentTypeId__c = responseWp.Out_ConsultaDocumentos.docServiceRs.docsDigitalizados[i].idDoctoTienda,
                                        page__c           = responseWp.Out_ConsultaDocumentos.docServiceRs.docsDigitalizados[i].page
                                    );
                                    System.debug(loggingLevel.Error, '*** documents.DocumentTypeId__c: ' + documents.DocumentTypeId__c);
                                    lstfoundDocuments.add(documents);
                                }
                            }
                        }
                    }

                }
            }
        }
        
        if(!blnSuccessfulProcess) {
            //AAZ_Utils_cls.insertIncidence(stgMessage,strExcptnType,null,idCurrentId);
        }
        return lstfoundDocuments;
    }

    public class ResponseWrapper {
        public DocsRs Out_ConsultaDocumentos;
    }

    public class DocsRs {
        public DocsData docServiceRs;
    }

    public class DocsData {
        public List<Doc> docsDigitalizados;

    }

    public class Doc {
        public Integer orden;
        public String ruta;
        public String digitalNumber;
        public String idDoctoTienda;
        public Integer page;
        public Error errorList;
    }

    public class Error {
        public List<ErroList> errorItem;
    }

    public class ErroList {
        public string code;
        public string description;
    }
}