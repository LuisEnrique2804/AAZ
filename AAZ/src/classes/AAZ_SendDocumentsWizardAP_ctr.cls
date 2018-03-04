public class AAZ_SendDocumentsWizardAP_ctr {
	
	public Id contactId;
	public Attachment attchmntInstance{set;get;}
	public Contact contactInstance{set;get;}
    public Documentos_AP__c docAPInstance{set;get;}
    public Boolean blnSuccessfulProcedure{set;get;}
    public String strMode{set;get;}
    public List<String> lstSuccessMsgs{set;get;}
    public List<String> lstErrorMsgs{set;get;}
    public List<Documentos_AP__c> lstSucceededDocsSending{set;get;}
    private static final String STR_DOCQUERYSERVICECODE = 'Afore_QueryDocument';

    public AAZ_SendDocumentsWizardAP_ctr(ApexPages.StandardController stdr){
		contactId = stdr.getId();
        initiateVars();
    }

    public void initMsgs(){
        lstSuccessMsgs = new List<String>();
        lstErrorMsgs = new List<String>();
    }

    public List<SelectOption> getDocumentTypeOptions(){
        return new List<SelectOption>{
            new SelectOption('Acta Administrativa','Acta Administrativa'),
            new SelectOption('Carta compromiso','Carta compromiso'),
            new SelectOption('Guia de Consejeria','Guia de Consejeria'),
            new SelectOption('Oficio de queja','Oficio de queja'),
            new SelectOption('Otro','Otro')
        };
    }

    public void initiateVars(){
    	contactInstance = [SELECT Id, LockOrUnlockAction__c, Status__c, EmployeeNumber__c, APDocsCase__c, ChoosenAPDocument__c FROM Contact WHERE Id =: contactId];
    	contactInstance.ChoosenAPDocument__c = null;
        attchmntInstance = new Attachment();
        lstSucceededDocsSending = new List<Documentos_AP__c>();
        docAPInstance = new Documentos_AP__c();
        blnSuccessfulProcedure = false;
        strMode = '';
        initMsgs();
        getModeOptions();
    }

    public List<SelectOption> getModeOptions(){
        List<SelectOption> lstOptions = new List<SelectOption>();
        lstOptions.add(new SelectOption('Alta','Alta'));
        lstOptions.add(new SelectOption('Reemplazo','Reemplazo'));
        lstOptions.add(new SelectOption('Baja','Baja'));
        return lstOptions;
    }
    
    public Boolean validateInputs(){
        Boolean blnEverythingWentFine = true;
        if(strMode != 'Baja'){
            if(docAPInstance.DocName__c == null || String.isBlank(docAPInstance.DocName__c)){
                blnEverythingWentFine = false;
                lstErrorMsgs.add('Debe establecer un nombre para el documento.');
            }
            //if(contactInstance.APDocsCase__c == null){
            //    blnEverythingWentFine = false;
            //    lstErrorMsgs.add('Debe elegir la afiliación a la cuál el documento será relacionado.');
            //}
            if(attchmntInstance.Body == null){
                blnEverythingWentFine = false;
                lstErrorMsgs.add('Debe seleccionar el fichero / archivo.');
            }
            if(docAPInstance.DocumentType__c == null || String.isBlank(docAPInstance.DocumentType__c)){
                blnEverythingWentFine = false;
                lstErrorMsgs.add('Debe establecer un tipo de documento.');
            }
            //if(strMode == 'Reemplazo'){
            //    if(contactInstance.ChoosenAPDocument__c == null){
            //        blnEverythingWentFine = false;
            //        lstErrorMsgs.add('Debe elegir la afiliación a la cuál el documento será relacionado.');
            //    }
            //}
        }else{
            if(contactInstance.ChoosenAPDocument__c == null){
                blnEverythingWentFine = false;
                lstErrorMsgs.add('Debe seleccionar un documento a eliminar.'); 
            }
        }
        return blnEverythingWentFine;
    } 

    public void docQuery(){
        Boolean blnSuccessfulProcess = false;
        Boolean blnWasThereAnException = false;
        String strRequest = '';
        List<Documentos_AP__c> lstfoundDocuments = new List<Documentos_AP__c>();
        Map<String, Object> mapRequest = new Map<String, Object>();
        string stgMessage = '';
        String strExcptnType = '';
        Id idCurrentId = UserInfo.getUserId();
        String strResponse = '';
        AAZ_DocumentQueryWS_cls.ResponseWrapper     responseWp  = new AAZ_DocumentQueryWS_cls.ResponseWrapper();
        
        strRequest = JSON.serializePretty(
            new Map<String,Object>{
                'In_ConsultaDocumentos' => new Map<String,Object>{
                    'docServiceRq' => new Map<String,Object>{
                        'codigoServicio' => '4',
                        'employeeNumber' => contactInstance.employeeNumber__c,
                        'nss' =>  contactInstance.NSS__c
                    }
                }
            }
        );
        System.debug(loggingLevel.Error, '*** strRequest: ' + strRequest);
        if(strRequest != null || String.isNotBlank(strRequest)) {
            try{strResponse = AAZ_GenericCallout_cls.fn_runCallout(strRequest, STR_DOCQUERYSERVICECODE, null);}catch(CalloutException cE){stgMessage = cE.getMessage();}catch(UnexpectedException uE){stgMessage = uE.getMessage();}catch(Exception gE){stgMessage = gE.getMessage();}
            System.debug(loggingLevel.Error, '*** strResponse: ' + strResponse);
            if (String.isNotBlank(strResponse) && strResponse != null) {
                try {responseWp = (AAZ_DocumentQueryWS_cls.ResponseWrapper)JSON.deserialize(strResponse, AAZ_DocumentQueryWS_cls.ResponseWrapper.class);} catch(Exception e) {System.debug(loggingLevel.Error, '*** e: ' + e);}
                System.debug(loggingLevel.Error, '*** responseWp: ' + responseWp);
                if(responseWp.Out_ConsultaDocumentos != null) {
                    if(responseWp.Out_ConsultaDocumentos.docServiceRs != null) {
                        if(!responseWp.Out_ConsultaDocumentos.docServiceRs.docsDigitalizados.isEmpty()) {    
                            for(Integer i = 0; i < responseWp.Out_ConsultaDocumentos.docServiceRs.docsDigitalizados.size(); i++) {
                                Documentos_AP__c documents = new Documentos_AP__c(
                                    FileURL__c        = responseWp.Out_ConsultaDocumentos.docServiceRs.docsDigitalizados[i].ruta,
                                    DocName__c        = responseWp.Out_ConsultaDocumentos.docServiceRs.docsDigitalizados[i].digitalNumber,
                                    DocumentType__c = responseWp.Out_ConsultaDocumentos.docServiceRs.docsDigitalizados[i].idDoctoTienda
                                );
                                lstfoundDocuments.add(documents);
                            }
                        }
                    }
                }

            }
        }
    }

    public void executeOperation(){
        initMsgs();
        Boolean executeCallOut = false;
        blnSuccessfulProcedure = false;
        if(validateInputs()){
            if(strMode == 'Alta'){
                docAPInstance.Id = null;
                executeCallOut = true;
            }else if(strMode == 'Reemplazo'){
                docAPInstance.Id = contactInstance.ChoosenAPDocument__c;
                executeCallOut = true;
            }else if(strMode == 'Baja'){
                docAPInstance.Id = contactInstance.ChoosenAPDocument__c;
                executeCallOut = true;
            }
        }
        if(executeCallOut){
        	Blob blbFileBody = attchmntInstance.Body;
        	attchmntInstance.Body = null;
        	Case auxCaseInstance = new Case();
        	if(contactInstance.APDocsCase__c != null){
        		try{auxCaseInstance = [SELECT Id, FolioNSS__c FROM Case WHERE Id =:contactInstance.APDocsCase__c];}catch(QueryException qE){}catch(UnexpectedException uE){}catch(Exception gE){}
        	}
            List<SObject> lstRequestObjects = new List<SObject>();
            String strExistingAPDocumentFolio = null;
            lstRequestObjects.add(contactInstance);
            if(contactInstance.ChoosenAPDocument__c != null){
                try{strExistingAPDocumentFolio = [SELECT Name FROM Documentos_AP__c WHERE Id =: contactInstance.ChoosenAPDocument__c limit 1].Name;}catch(QueryException qE){}catch(Exception gE){}
            }
            AAZ_PromoterDocumentsService_cls.PromoterAgentDocsWrapperAnswer serviceCallResponseInstance = new AAZ_PromoterDocumentsService_cls.PromoterAgentDocsWrapperAnswer(); 
            String strBase64File = null;
            if(blbFileBody != null){
                strBase64File = EncodingUtil.base64Encode(blbFileBody);
            }
            Map<String,Object> mapExtraAttribs =  new Map<String,Object>{
            	'In_DocumentosPromotor' => new Map<String,Object>{
            		'approveServiceRq' => new Map<String,Object>{
            			'documentType' => docAPInstance.DocumentType__c,
            			'name' => docAPInstance.DocName__c,
            			'pagina' => '1',
            			'mode' => (strMode == 'Baja')?'BAJA':(strMode == 'Reemplazo')?'REEMPLAZO':(strMode == 'Alta')?'ALTA':'ALTA',
		                'folio' => (auxCaseInstance.FolioNSS__c != null && !String.isBlank(auxCaseInstance.FolioNSS__c))?auxCaseInstance.FolioNSS__c:null,
		                'docFolio' => ((strMode == 'Baja' || strMode == 'Reemplazo'))?strExistingAPDocumentFolio:null,
            			'documents' => new Map<String,Object>{
            				'document' => new Map<String, Object>{
            					'file' => strBase64File
            				}
            			}
            		}
            	}
            };
            try{serviceCallResponseInstance = AAZ_PromoterDocumentsService_cls.sendFormats(lstRequestObjects,mapExtraAttribs);}catch(UnexpectedException uE){}catch(Exception gE){}            
            if(serviceCallResponseInstance.Out_DocumentosPromotor != null){
            	if(serviceCallResponseInstance.Out_DocumentosPromotor.approveServiceRs != null){
            		if(serviceCallResponseInstance.Out_DocumentosPromotor.approveServiceRs.isSucessful != null){
            			if(serviceCallResponseInstance.Out_DocumentosPromotor.approveServiceRs.isSucessful == 'True'){
            				if(strMode == 'Alta' || strMode == 'Reemplazo'){
			                    //if(serviceCallResponseInstance.Out_DocumentosPromotor.approveServiceRs.strDocURL != null){
			                    	if(docAPInstance.DocumentType__c == 'Acta Administrativa'){
			                            docAPInstance.AdministrativeActContact__c = contactId;
			                        }else if(docAPInstance.DocumentType__c == 'Guia de Consejeria'){
			                            docAPInstance.GuideContact__c = contactId;
			                        }else{
			                            docAPInstance.OtherDocContact__c = contactId;
			                        }
			                        docAPInstance.FileURL__c = serviceCallResponseInstance.Out_DocumentosPromotor.approveServiceRs.strDocURL;
			                        docAPInstance.associateProcess__c = contactInstance.APDocsCase__c;
			                        //Consulta documentos ******
                                    docQuery();
                                    //****** Fin Consulta Documentos
                                    Database.UpsertResult upsrtrsltInstance = Database.upsert(docAPInstance,false);
			                        if(upsrtrsltInstance.isSuccess()){
			                            blnSuccessfulProcedure = true;
			                        }else{
			                            lstErrorMsgs.add('Hubo un error al intentar registrar la URL del documento en Salesforce. Contacte a su administrador.');
			                            AAZ_Utils_cls.insertIncidence(upsrtrsltInstance.getErrors()[0].getMessage(),'DML',null,UserInfo.getUserId());
			                        }   
			                    //}else{
			                	   // lstErrorMsgs.add('No se recibió una URL válida por parte del servicio web. Consulte a su administrador.');
			                    //}
			                }else if(strMode == 'Baja'){
			                    Database.DeleteResult dResult = Database.delete(docAPInstance,false);
			                    if(!dResult.isSuccess()){
			                        lstErrorMsgs.add('El documento se dio de baja de manera exitosa. Sin embargo, no fue posible darlo de baja localmente. Detalles : '+dResult.getErrors()[0].getMessage());    
			                    }else{
			                        blnSuccessfulProcedure = true;
			                    }
			                }
            			}
            		}
            	}
            }else{
                lstErrorMsgs.add('El servicio web de alta de documentos no respondió adecuadamente. Consulte a su administrador.');    
            }
        }
    }

}