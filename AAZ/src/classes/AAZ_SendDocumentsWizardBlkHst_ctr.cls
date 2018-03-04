public class AAZ_SendDocumentsWizardBlkHst_ctr {

	public Id blockHistoryId;
	public Attachment attchmntInstance{set;get;}
	public BlockHistory__c bHistoryInstance{set;get;}
    public Documentos_AP__c  docAPInstance{set;get;}
    public Boolean blnSuccessfulProcedure{set;get;}
    public String strMode{set;get;}
    public List<String> lstSuccessMsgs{set;get;}
    public List<String> lstErrorMsgs{set;get;}
    public List<Documentos_AP__c> lstSucceededDocsSending{set;get;}
		public List<SObject> lstRequestObjects{set;get;}

	public AAZ_SendDocumentsWizardBlkHst_ctr(ApexPages.StandardController stdr){
		blockHistoryId = stdr.getId();
        initiateVars();
    }

    public void initMsgs(){
        lstSuccessMsgs = new List<String>();
        lstErrorMsgs = new List<String>();
    }

    public void initiateVars(){
    	bHistoryInstance = [SELECT Id, PromotorAgentName__c, Tramite__c FROM BlockHistory__c WHERE Id =: blockHistoryId];
    	bHistoryInstance.ChoosenAPDocument__c = null;
        attchmntInstance = new Attachment();
        lstSucceededDocsSending = new List<Documentos_AP__c>();
        docAPInstance = new Documentos_AP__c();
				lstRequestObjects = new List<SObject>();

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
            if(bHistoryInstance.Tramite__c == null){
                blnEverythingWentFine = false;
                lstErrorMsgs.add('Debe elegir la afiliación a la cuál el documento será relacionado.');
            }
            if(attchmntInstance.Body == null){
                blnEverythingWentFine = false;
                lstErrorMsgs.add('Debe seleccionar el fichero / archivo.');
            }
            if(strMode == 'Reemplazo'){
                if(bHistoryInstance.ChoosenAPDocument__c == null){
                    blnEverythingWentFine = false;
                    lstErrorMsgs.add('Debe elegir la afiliación a la cuál el documento será relacionado.');
                }
            }
        }else{
            if(bHistoryInstance.ChoosenAPDocument__c == null){
                blnEverythingWentFine = false;
                lstErrorMsgs.add('Debe seleccionar un documento a eliminar.');
            }
        }
        return blnEverythingWentFine;
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
                docAPInstance.Id = bHistoryInstance.ChoosenAPDocument__c;
                executeCallOut = true;
            }else if(strMode == 'Baja'){
                docAPInstance.Id = bHistoryInstance.ChoosenAPDocument__c;
                executeCallOut = true;
            }
        }
        if(executeCallOut){
        	Case auxCaseInstance = new Case();
        	if(bHistoryInstance.Tramite__c != null){
        		try{auxCaseInstance = [SELECT Id, FolioNSS__c FROM Case WHERE Id =:bHistoryInstance.Tramite__c];}catch(QueryException qE){}catch(UnexpectedException uE){}catch(Exception gE){}
        	}
            String strExistingAPDocumentFolio = null;
            if(bHistoryInstance.PromotorAgentName__c != null){
                Contact contactInstance = new Contact();
                try{contactInstance = [SELECT Id, LockOrUnlockAction__c, Status__c, EmployeeNumber__c FROM Contact WHERE Id =: bHistoryInstance.PromotorAgentName__c];}catch(QueryException qE){}catch(Exception gE){}
                lstRequestObjects.add(contactInstance);
            }
            if(bHistoryInstance.ChoosenAPDocument__c != null){
                try{strExistingAPDocumentFolio = [SELECT Name FROM Documentos_AP__c WHERE Id =: bHistoryInstance.ChoosenAPDocument__c limit 1].Name;}catch(QueryException qE){}catch(Exception gE){}
            }
            AAZ_PromoterDocumentsService_cls.PromoterAgentDocsWrapperAnswer serviceCallResponseInstance = new AAZ_PromoterDocumentsService_cls.PromoterAgentDocsWrapperAnswer();
            String strBase64File = null;
            if(attchmntInstance.Body != null){
                strBase64File = EncodingUtil.base64Encode(attchmntInstance.Body);
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
            attchmntInstance.Body = null;
            try{serviceCallResponseInstance = AAZ_PromoterDocumentsService_cls.sendFormats(lstRequestObjects,mapExtraAttribs);}catch(UnexpectedException uE){}catch(Exception gE){}
						if(serviceCallResponseInstance.Out_DocumentosPromotor != null){
            	if(serviceCallResponseInstance.Out_DocumentosPromotor.approveServiceRs != null){
            		if(serviceCallResponseInstance.Out_DocumentosPromotor.approveServiceRs.isSucessful != null){
            			if(serviceCallResponseInstance.Out_DocumentosPromotor.approveServiceRs.isSucessful == 'True'){
            				if(strMode == 'Alta' || strMode == 'Reemplazo'){
			                    if(serviceCallResponseInstance.Out_DocumentosPromotor.approveServiceRs.strDocURL != null){
			                        docAPInstance.FileURL__c = serviceCallResponseInstance.Out_DocumentosPromotor.approveServiceRs.strDocURL;
			                        docAPInstance.associateProcess__c = bHistoryInstance.Tramite__c;
                                    docAPInstance.Historial_de_Bloqueos__c = blockHistoryId;
			                        Database.UpsertResult upsrtrsltInstance = Database.upsert(docAPInstance,false);
			                        if(upsrtrsltInstance.isSuccess()){
			                            blnSuccessfulProcedure = true;
			                        }else{
			                            lstErrorMsgs.add('Hubo un error al intentar registrar la URL del documento en Salesforce. Contacte a su administrador.');
			                            AAZ_Utils_cls.insertIncidence(upsrtrsltInstance.getErrors()[0].getMessage(),'DML',null,UserInfo.getUserId());
			                        }
			                    }else{
			                	    lstErrorMsgs.add('No se recibió una URL válida por parte del servicio web. Consulte a su administrador.');
			                    }
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