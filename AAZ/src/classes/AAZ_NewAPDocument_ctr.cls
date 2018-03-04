public class AAZ_NewAPDocument_ctr {
    
    // Cargar los mainsettings para las clases de prueba
    public static AppMainSetting_cs__c mainSettings = Test.isRunningTest()?
        AAZ_TestUtils_tst.getMainSettings() : AppMainSetting_cs__c.getOrgDefaults();

    public Attachment attchmntInstance{set;get;}
    public String strSelectedDocType{set;get;}
    public Case caseInstance{set;get;}
    public Documentos_AP__c  docAPInstance{set;get;}
    public Boolean blnSuccessfulProcedure{set;get;}
    public Boolean blnCaseReferenceReceived{set;get;}
    public Boolean blnShowDocumentLookUp{set;get;}
    public String strMode{set;get;}
    public List<String> lstSuccessMsgs{set;get;}
    public List<String> lstErrorMsgs{set;get;}
    public List<Documentos_AP__c> lstSucceededDocsSending{set;get;}
    public List<SelectOption> lstSelectOptionsForMode{set;get;}

    public AAZ_NewAPDocument_ctr(){
        initiateVars();
        processCaseReference();
    }

    public void initMsgs(){
        lstSuccessMsgs = new List<String>();
        lstErrorMsgs = new List<String>();
    }

    public void determinateWhatAppliesBasedOnMode(){
        blnShowDocumentLookUp = false;
        if(strMode == 'Reemplazo'){
            blnShowDocumentLookUp = true;
        }
        if(strMode == 'Baja'){
            blnShowDocumentLookUp = true;
        }
    }
    
    public void initiateVars(){
        attchmntInstance = new Attachment();
        lstSucceededDocsSending = new List<Documentos_AP__c>();
        caseInstance = new Case();
        docAPInstance = new Documentos_AP__c();
        blnSuccessfulProcedure = false;
        blnCaseReferenceReceived = false;
        blnShowDocumentLookUp = false;
        strSelectedDocType = '';
        strMode = 'strMode';
        initMsgs();
        getModeOptions();
    }

    public void processCaseReference(){
        String strCaseId = ApexPages.currentPage().getParameters().get('caseId');
        if(strCaseId != null){
            if(!String.isEmpty(strCaseId)){
                blnCaseReferenceReceived = true;
                strMode = 'Alta';
                caseInstance.Id = strCaseId;
            }
        }
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

    public void getModeOptions(){
        lstSelectOptionsForMode =  new List<SelectOption>{
            new SelectOption('Alta','Alta'),
            new SelectOption('Reemplazo','Reemplazo'),
            new SelectOption('Baja','Baja')
        };
    }
    
    /*

    public Boolean validateInputs(){
        Boolean blnEverythingWentFine = true;
        if(caseInstance.ContactId == null){
            blnEverythingWentFine = false; 
            lstErrorMsgs.add('Debe seleccionar el agente promotor');
        }
        if(docAPInstance.Name == null || String.isBlank(docAPInstance.Name)){
            blnEverythingWentFine = false;
            lstErrorMsgs.add('Debe establecer un nombre para el documento');
        }
        if(attchmntInstance.Body == null){
            blnEverythingWentFine = false;
            lstErrorMsgs.add('Debe seleccionar un archivo');
        }
        return blnEverythingWentFine;
    } 

    public void sendDocument(){
        initMsgs();
        if(validateInputs()){
            Contact contactInstance = new Contact();
            contactInstance = [SELECT LockOrUnlockAction__c, Status__c, EmployeeNumber__c FROM Contact WHERE Id =: caseInstance.ContactId];
            List<SObject> lstRequestObjects = new List<SObject>();
            lstRequestObjects.add(contactInstance);
            lstRequestObjects.add(docAPInstance); 
            AAZ_PromoterDocumentsService_cls.PromoterAgentDocsWrapperAnswer serviceCallResponseInstance = new AAZ_PromoterDocumentsService_cls.PromoterAgentDocsWrapperAnswer(); 
            String strBase64File = EncodingUtil.base64Encode(attchmntInstance.Body);
            System.debug('blob : '+attchmntInstance.Body);
            Map<String,Object> mapExtraAttribs =  new Map<String,Object>{
                'documents' => new Map<String,Object>{
                    'file' => strBase64File
                },
                'name' => strSelectedDocType
            };
            System.debug('mapExtraAttribs : '+mapExtraAttribs);
            attchmntInstance.Body = null;
            try{serviceCallResponseInstance = AAZ_PromoterDocumentsService_cls.sendFormats(lstRequestObjects,mapExtraAttribs);}catch(UnexpectedException uE){}catch(Exception gE){}            
            System.debug(loggingLevel.Error, '*** serviceCallResponseInstance: ' + serviceCallResponseInstance);
            if(serviceCallResponseInstance.strDocURL != null && !String.isBlank(serviceCallResponseInstance.strDocURL)){
                Documentos_AP__c apDocInstance = new Documentos_AP__c();
                if(strSelectedDocType == 'Acta Administrativa'){
                    apDocInstance.AdministrativeActContact__c = caseInstance.ContactId;
                }else if(strSelectedDocType == 'Guia de Consejeria'){
                    apDocInstance.GuideContact__c = caseInstance.ContactId;
                }else{
                    apDocInstance.OtherDocContact__c = caseInstance.ContactId;
                }
                apDocInstance.FileURL__c = serviceCallResponseInstance.strDocURL;
                apDocInstance.Name =  docAPInstance.Name;
                Database.SaveResult sr = Database.insert(apDocInstance,false);
                if(sr.isSuccess()){
                    blnSuccessfulProcedure = true;
                }else{
                    lstErrorMsgs.add('Hubo un error al intentar registrar la URL del documento en Salesforce. Contacte a su administrador.');
                    AAZ_Utils_cls.insertIncidence(sr.getErrors()[0].getMessage(),'DML',null,UserInfo.getUserId());
                }
            }else{
                lstErrorMsgs.add('Hubo un error al intentar enviar el documento. Contacte a su administrador.');
            }
        }
    }*/
    
}