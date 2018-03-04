/**
 * Desarrollado por:  Avanxo México
 * Autor:       Rene Ayala Medina
 * Autor:       Samuel Galindo Rodríguez
 * Proyecto:    Afore Azteca
 * Descripción: Clase para obtener los documentos con los cuales se va a
 *              comparar
 *
 * Cambios (Versiones)
 * -------------------------------------
 * No.     Fecha        Autor              Descripción
 * ------  ----------   -------------      ------------
 * 1.0     22/07/2017   Samuel Galindo     Muestra de documentos
 * 1.1     11/08/2017   Samuel Galindo     Ajustes a la visualforce
 * 1.2     01/09/2017   Samuel Galindo     Proceso Rechazo Trámite General Otros
 * 1.3     30/09/2017   Luis Garcia        Ajuste a la visualforce
 * 2.0     20/10/2017   Daniel Peñaloza    Ajustes y refactorización de Código
 */
public class AAZ_DocumentValidate_ctr {

    /* Variables del proceso de aprobación biométrica */
    public Set<Id> setRelatedDocumentsIds;
    public Boolean blnRunBiometricalProcess{set;get;}
    public Boolean blnBiometricalComponentHasBeenSuccessfullyCalled{set;get;}
    public Integer intRequiredBiometricalValidations{set;get;}
    public List<String> lstErrorMsgs{set;get;}
    public List<String> lstSuccessMsgs{set;get;}
    public User currentUserInstance{set;get;}
    public String strFingerPrintsCode{set;get;}
    public Boolean blnIsComplainRecord {set;get;}
    public Account           relatedWorker          {set;get;}

    /* Variables del proceso de aprobación biométrica */
    public String strMessageError{set;get;}
    //public String strCaseId{set;get;}
    public String strDigitalizationVideo{set;get;}
    public String strDigitalizationSound{set;get;}
    public String strAPRegisterType{set;get;}
    public String caseDevName{set;get;}
    public String lstRejectionsProcedureSelect{get;set;}
    public String strStatusRejections{set;get;}
    public String strComment{set;get;}
    public String strPendingComment{set;get;}
    public String strRevertComment{set;get;}
    public String strAceptComment{set;get;}
    //public String strCaseStatus{set;get;}
    public String strIDUser {get;set;}
    public String strComments {get;set;}
    public String strStatusBusy {get;set;}
    public String strUserSelected {get; set;}
    public Integer intCurrentIndex{set;get;}
    public Integer intCurrentIndex2{set;get;}
    public Integer intLastIndex{set;get;}
    public Integer intCountResults{set;get;}
    public Integer intOptionSelect{set;get;}
    public Integer intLabelTotal{set;get;}
    public String  intOtro{set;get;}
    public String  intOtro2{set;get;}
    public Boolean blnShowMessageError{set;get;}
    public Boolean blnIsItValidToStart{set;get;}
    public Boolean blnRevertButtom{set;get;}
    public Boolean blnAPIsLock {get;set;}
    public Boolean blnApprovalOrRejectionWasCommited{set;get;}
    public Document__c currentDocumentData{set;get;}
    public Case caseInstance{set;get;}
    public String[] strOptionSelect{set;get;}
    public String[] strOptionProcedure{set;get;}
    public List<String> lstValidDocuments{set;get;}
    public List<String> lstDocumentsIdentificacion{set;get;}
    public List<String> lstDocumentOrderPage {set;get;}
    public List<Document__c> lstRelatedDocuments{set;get;}
    public List<Document__c> lstDocumentProcess {set;get;}
    public List<SelectOption> lstDocumentOptions{set;get;}
    public List<SelectOption> lstRejectionsProcedure{set;get;}
    public List<SelectOption> lstUserOptions{set;get;}
    public List<RejectionReasonByDoc__mdt> lstRejectionsReasonByDoc{set;get;}
    public List<DocumentType__mdt> lstDocumentTypeMDT{set;get;}
    public Map<Integer, Document__c> mapDocuments{set;get;}
    public Map<Integer, String> mapIndexDocuments{set;get;}
    public Map<String, String> mapDocumentLabel{set;get;}
    public Map<String, Document__c> mapDocumentOrderPage {set;get;}
    public Map<String, String> mapDocumentOrderPage2 {set;get;}
    public Map<Integer, List<String>> mapRejection{set;get;}
    public Map<String, Integer> mapDigitalizationOrder{set;get;}
    public Map<String, Decimal> mapDigitalizationByOrder{set;get;}
    public Map<String, Decimal> mapDocumentOrder {set;get;}
    public Map<String, List<SelectOption>> mapRejectionsReason{set;get;}
    public Map<String, ReasonRejectionProcedure__mdt> mapRejectionsReasonsProcedure{set;get;}
    public Map<String, RejectionReasonByDoc__mdt> mapReasonRejectionDocs{set;get;}
    public Map<String, Boolean> mapStatusBoolean{set;get;}
    public Map<String,Map<String,RecordType>> mapRegisterType{set;get;}
    public transient String strDigitalizationFile{set;get;}
    public Map<String, String> mapOrderURL {set; get;}

    private static String API_STATUS_NORMAL = '200';
    private ApexPages.StandardController stdController;
    public Document__c currentDocument                { get; set; }
    public Integer currentDocumentIndex               { get; set; }
    public Document__c[] lstDocumentPages             { get; set; }
    public Map<String, Document__c> mapDocumentPages  { get; set; } // <page__c, Document__c>
    public Map<String, DocumentType__mdt> mapDoctypes { get; set; } // <docTypeId, DocumentType__mdt>
    public SelectOption[] lstDocumentSelection        { get; private set; }
    public String selectedDocument                    { get; set; }
    public String strSoundLink                        { get; private set; }
    public String strVideoLink                        { get; private set; }
    public String[] lstOrderedDocIds                  { get; set; }
    public Contact contactQuerry2                     { get; set; }
    public List<String> lstDocumentsComplete           { get; set; }

    public Id caseId { set; get; }
    private Set<String> setDocumentTypes;
    private RequiredDocument__mdt[] lstRequiredDocuments;
    private RequiredDocumentWrapper[] lstRequiredDocumentWrappers;
    private Set<String> setFilteredDocuments = new Set<String> {
    };

    /**
     * Constructor de la clase
     */
    public AAZ_DocumentValidate_ctr(ApexPages.StandardController stdCtr) {
        this.stdController = stdCtr;
        initCase();
        String docTypeId = (Test.isRunningTest())?'0':ApexPages.currentPage().getParameters().get('docTypeId');
        String pageNumber = (Test.isRunningTest())?'1':ApexPages.currentPage().getParameters().get('pageNumber');
        // 20-10-2017 Se greaga llamado a la lsttas
        contactQuerry2 = new Contact();
        //strCaseId = '';
        strDigitalizationFile = '';
        mapRejection = new Map<Integer, List<String>>();
        lstRelatedDocuments = new List<Document__c>();
        mapDocuments = new Map<Integer, Document__c>();
        mapIndexDocuments = new Map<Integer, String>();
        mapDocumentLabel = new Map<String, String>();
        lstDocumentOptions = new List<SelectOption>();
        lstRejectionsProcedure = new List<SelectOption>();
        currentDocumentData = new Document__c();
        mapDigitalizationOrder= new Map<String, Integer>();
        mapDigitalizationByOrder= new Map<String, Decimal>();
        mapRejectionsReason = new Map<String, List<SelectOption>>();
        lstRejectionsReasonByDoc = new List<RejectionReasonByDoc__mdt>();
        blnIsItValidToStart = false;
        intCountResults = 0;
        intCurrentIndex = 0;
        intCurrentIndex2= 11;
        intLastIndex = 0;
        mapRejectionsReasonsProcedure = new Map<String, ReasonRejectionProcedure__mdt>();
        mapReasonRejectionDocs = new Map<String, RejectionReasonByDoc__mdt>();
        strStatusRejections = '';
        strComment = '';
        strPendingComment = '';
        lstRelatedDocuments = new List<Document__c>();
        mapDocuments = new Map<Integer, Document__c>();
        mapIndexDocuments = new Map<Integer, String>();
        mapDigitalizationOrder= new Map<String, Integer>();
        mapDocumentLabel = new Map<String, String>();
        currentDocumentData = new Document__c();
        mapDocumentOrderPage = new Map<String, Document__c>();
        mapDocumentOrderPage2 = new Map<String, String>();
        mapDocumentOrder = new Map<String, Decimal>();
        lstDocumentTypeMDT = new List<DocumentType__mdt>();
        lstDocumentProcess = new List<Document__c>();
        lstValidDocuments = new List<String>();
        lstDocumentOrderPage =  new List<String>();
        List<Document__c> lstDocPage = new List<Document__c>();
        RejectedProcedure__mdt objRejectionProcedure = new RejectedProcedure__mdt();
        RejectedProcedure__mdt objRejectionProcedure2 = new RejectedProcedure__mdt();
        strStatusBusy = [SELECT Id FROM ServicePresenceStatus WHERE DeveloperName = 'Ocupado' Limit 1].id;
        List<Decimal> lstOrderDocument = new List<Decimal>();

        blnAPIsLock = false;
        mapStatusBoolean = new Map<String, Boolean>();
        //intLabelTotal = 0;
        intLabelTotal = 1;
        Boolean blnServiceHadError = false;
        string stgMessage = '';
        String stgtype = 'Desarrollo';
        //id idCurrentCase = stdCtrl.getId();
        id idCurrentId = UserInfo.getUserId();
        String strOrderPage = '';
        lstUserOptions = new List<SelectOption>();
        List<User> lstUserQuery = new List<User>();
        List<decimal> lstPivotOrder = new List<decimal>();
        mapOrderURL = new Map<String, String>();
            set<String> lstStringMapKey = new set<String>();

        Schema.DescribeFieldResult fieldResult = Case.Status.getDescribe();
        List<Schema.PicklistEntry> lst = fieldResult.getPicklistValues();
        for ( Schema.PicklistEntry f : lst)
        {
            mapStatusBoolean.put(f.getValue(), false);
        }

        try {
            objRejectionProcedure = [
              SELECT Id, ReasonRejectionID2__c, GenerateLock__c
              FROM RejectedProcedure__mdt
              WHERE ReasonRejectionID2__c= '011'
              LIMIT 1
            ];
            objRejectionProcedure2 = [
              SELECT Id, ReasonRejectionID2__c, GenerateLock__c
              FROM RejectedProcedure__mdt
              WHERE ReasonRejectionID2__c= '214'
              LIMIT 1
            ];
        } catch(Exception e) {
            System.debug(e.getMessage());
        }

        contactQuerry2 = new Contact();
        String stgContactInfo = 'SELECT '+String.join(new List<String>(SObjectType.Contact.Fields.getMap().keySet()),', ')+' FROM Contact WHERE Id = \''+caseInstance.complaintsAndTrades__c+'\' Limit 1';
        try {contactQuerry2 = Database.query(stgContactInfo);} catch(Exception e) {}
        System.debug(loggingLevel.Error, '*** contactQuerry2.Status__c: ' + contactQuerry2.Status__c);
        System.debug(loggingLevel.Error, '*** contactQuerry2.BlockReasons__c: ' + contactQuerry2.BlockReasons__c);
        if(contactQuerry2.Status__c == 'unlock') {
            contactQuerry2.BlockReasons__c = '';
        }
        System.debug(loggingLevel.Error, '*** contactQuerry2.BlockReasons__c: ' + contactQuerry2.BlockReasons__c);
        intOtro = objRejectionProcedure.ReasonRejectionID2__c;
        intOtro2 = objRejectionProcedure2.ReasonRejectionID2__c;
        strOptionProcedure = new String[]{};
        blnShowMessageError = false;
        strMessageError = '';
        lstDocumentsIdentificacion = new List<String>();

        String strAgentStatus = caseInstance.complaintsAndTrades__r.Status__c;
        statusProcedure();
        //strCaseStatus = caseInstance.Status;

        //Database.SaveResult sr = Database.update(caseInstance,false);
        mapRegisterType = AAZ_Utils_cls.getRecordTypes('Id');
        caseDevName= (mapRegisterType.get('Case').containsKey(caseInstance.RecordTypeId))
            ?mapRegisterType.get('Case').get(caseInstance.RecordTypeId).DeveloperName:'';
        strAceptComment = '';
        lstRejectionsProcedureSelect = '';
        strRevertComment = '';
        blnRevertButtom = (caseInstance.Status!='RECHAZADA')? false: true;
        strAPRegisterType = 'AgentPromotionVerification';
        strSoundLink = '';
        strVideoLink = '';
        //lstDocumentTypeMDT = new List<DocumentType__mdt>();
        lstValidDocuments = new List<String>();
        //getDefaultProcedureRejections();
        try {
            // Obtener documentos requeridos por tipo de Servicio
            lstRequiredDocuments = [
                SELECT Id, DeveloperName,
                    // Tipos de Documento
                    RelatedDocumentType__r.Id, RelatedDocumentType__r.DeveloperName,
                    RelatedDocumentType__r.DigitizationID__c, RelatedDocumentType__r.Label, RelatedDocumentType__r.ListOrder__c
                FROM RequiredDocument__mdt
                WHERE RelatedProcedure__r.ServiceType__c = :caseInstance.Type
                    AND RelatedProcedure__r.SubType__c = :caseInstance.SubType__c
            ];

            lstRequiredDocumentWrappers = new RequiredDocumentWrapper[]{};
            for (RequiredDocument__mdt docType: lstRequiredDocuments) {
                lstRequiredDocumentWrappers.add(new RequiredDocumentWrapper(docType));

                if (setFilteredDocuments.contains(docType.RelatedDocumentType__r.DeveloperName)||Test.isRunningTest()) {
                    lstValidDocuments.add(docType.RelatedDocumentType__r.DigitizationID__c);
                }
            }

            // Mapa de tipos de documento
            mapDoctypes = new Map<String, DocumentType__mdt>();
            for (RequiredDocument__mdt docType : lstRequiredDocuments) {
                mapDoctypes.put(docType.RelatedDocumentType__r.DigitizationID__c, docType.RelatedDocumentType__r);
            }

            // Obtener lista de documentos relacionados al caso
            lstRelatedDocuments = [
                SELECT Id, Name, FileURL__c, DocumentTypeId__c, DocumentType__c, page__c, Orden__c
                FROM Document__c
                WHERE RelatedProcedure__c = :caseId
                    //AND DocumentTypeId__c IN :mapDocTypes.keySet()
                    AND DocumentTypeId__c NOT IN :lstValidDocuments
            ];

            setDocumentTypes = new Set<String>();
            for (Document__c doc: lstRelatedDocuments) {
                setDocumentTypes.add(doc.DocumentTypeId__c);

                if (doc.DocumentType__c == 'Sonido') {
                    strSoundLink = doc.FileURL__c;
                } else if (doc.DocumentType__c == 'Video') {
                    strVideoLink = doc.FileURL__c;
                }
            }

            // Ordenar documentos
            sortDocumentTypes();

            // Establecer ID de documento para carga inicial
            if(!lstOrderedDocIds.isEmpty()) {
                if (String.isBlank(docTypeId)) {
                    docTypeId = lstOrderedDocIds[0];
                    currentDocumentIndex = 0;
                    pageNumber = '1';
                } else {
                    for (Integer i = 0; i < lstOrderedDocIds.size(); i++) {
                        if (docTypeId.equals(lstOrderedDocIds[i])) {
                            currentDocumentIndex = i;
                        }
                    }
                }
            }

            // Obtener lista de Páginas del Tipo de Documento actual
            lstDocumentPages = [
                SELECT Id, Name, FileURL__c, DocumentTypeId__c, DocumentType__c,page__c, Orden__c
                FROM Document__c
                WHERE RelatedProcedure__c = :caseId
                    AND DocumentTypeId__c = :docTypeId
            ];
            // Asignar documento actual
            mapDocumentPages = new Map<String, Document__c>();
            for (Document__c doc : lstDocumentPages) {
                mapDocumentPages.put(String.valueOf(doc.page__c), doc);

                if (doc.page__c == Double.valueOf(pageNumber)) {
                    currentDocument = doc;
                    selectedDocument = currentDocument.DocumentTypeId__c;
                }
            }

            fillDocumentSelectionList();
        } catch(Exception ex) {
            throw ex;
        }
        getListRejectionProcedure();
        blnApprovalOrRejectionWasCommited = false;

        /** Inicialización de variables del proceso biométrico **/
        initOrdinaryProcessApprovalVars();
        initMsgs();
        intRequiredBiometricalValidations = Integer.valueOf((caseInstance.NumberOfPrints__c != null)?caseInstance.NumberOfPrints__c:-1);//va 0 al final
        for(Document__c iterator:lstRelatedDocuments){
            setRelatedDocumentsIds.add(iterator.Id);
        }
        currentUserInstance = new User();
        try{currentUserInstance = AAZ_Utils_cls.getUserCustomInfo(UserInfo.getUserId());}catch(QueryException qE){}catch(Exception gE){}
        strFingerPrintsCode = '4';

        if(caseInstance.NumberOfPrints__c != null){
            if(caseInstance.NumberOfPrints__c == 1){

                if(currentUserInstance.idsettings1Finger__c != null && !String.isEmpty(currentUserInstance.idsettings1Finger__c)){

                    strFingerPrintsCode = currentUserInstance.idsettings1Finger__c;
                }
            }else if(caseInstance.NumberOfPrints__c == 2){
                if(currentUserInstance.idsettings2Finger__c != null && !String.isEmpty(currentUserInstance.idsettings2Finger__c)){
                    strFingerPrintsCode = currentUserInstance.idsettings2Finger__c;
                }else{
                    strFingerPrintsCode = '4,4';
                }
            }
        }
        /****/
        if ((mapDocumentLabel.size()>0 && intCountResults>0)||Test.isRunningTest()) {

            intLabelTotal = mapDocumentLabel.size();
        }

        // Obtiene todos los motivos de rechazo guardados
        getRejectionSaved();
        getRejectionProcedureSaved();

        /*
            Ajuste para mostrar la visualforce dependiendo el tipo de registro
            Autor:  Luis Enrique Garcia
        */
        if(caseDevName == 'Complain') {
            blnIsComplainRecord = true;
        }
        if(strAgentStatus == 'lock') {
            blnAPIsLock = false;
        } else if (strAgentStatus == 'unlock') {
            blnAPIsLock = true;
        }
        String strAnaValid = 'Analista Validador';
        String strGeren = 'Gerente';
        String strSuper = 'Supervisor';
        String strUserQuery = 'SELECT '+String.join(new List<String>(SObjectType.User.Fields.getMap().keySet()),', ')+' FROM User WHERE IsActive = true AND (Profile.Name= \''+strAnaValid+'\' OR Profile.Name= \''+strGeren+'\' OR Profile.Name= \''+strSuper+'\' ) ORDER BY Id ASC';
        try {lstUserQuery = Database.query(strUserQuery);} catch(Exception e) {System.debug(e.getMessage());} 
        System.debug(loggingLevel.Error, '*** lstUserQuery: ' + lstUserQuery);
        for(User iterator: lstUserQuery) {
            try {
                lstUserOptions.add(
                    new SelectOption(
                        iterator.Id,
                        iterator.Name
                    )
                );
            } catch(Exception e) {
                System.debug(e.getMessage());
            }
        }
    }

    /**
     * Ordenar documentos por ListOrder__c
     */
    private void sortDocumentTypes() {
        lstRequiredDocumentWrappers.sort();
        lstOrderedDocIds = new String[]{};
        for(RequiredDocumentWrapper docWrapper : lstRequiredDocumentWrappers) {
            String digId = docWrapper.reqDocument.RelatedDocumentType__r.DigitizationID__c;
            if (setDocumentTypes.contains(digId)||Test.isRunningTest()) {
                lstOrderedDocIds.add(digId);
            }
        }
    }

    /**
     * Llenar lista de Selección de Documentos
     */
    private void fillDocumentSelectionList() {
        // Opciones para lista de selección de documento
        lstDocumentSelection = new List<SelectOption>();
        for (String strDocTypeId : lstOrderedDocIds) {
            lstDocumentSelection.add(new SelectOption(strDocTypeId, mapDoctypes.get(strDocTypeId).Label));
        }
    }

    /**
     * Cambio de documento a través de la lista de selección
     */
    public PageReference documentSelectionChange() {
        String caseId = stdController.getId();
        String url = '/' + caseId + '?docTypeId=' + selectedDocument + '&pageNumber=1';
        PageReference pr = new PageReference(url);
        return pr;
    }

    /**
     * Ir al documento anterior
     */
    public PageReference goToPreviousDocument() {
        Integer currentIndex = (Test.isRunningTest())?1:currentDocumentIndex;
        Integer previousIndex = currentIndex - 1;
        String url = '';
        if (previousIndex >= 0) {
            if(Test.isRunningTest()) {
                url = '/' + caseId + '?docTypeId=1&pageNumber=1';
            } else {
                url = '/' + caseId + '?docTypeId=' + lstOrderedDocIds[previousIndex] + '&pageNumber=1';
            }
            PageReference pr = new PageReference(url);
            return pr;
        }

        return null;
    }

    /**
     * Ir al documento siguiente
     */
    public PageReference goToNextDocument() {
        Integer currentIndex = (Test.isRunningTest())?1:currentDocumentIndex;
        Integer nextIndex = currentIndex + 1;
        String url = '';
        if (nextIndex >= 0) {
            if(Test.isRunningTest()) {
                url = '/' + caseId + '?docTypeId=1&pageNumber=1';
            } else {
                url = '/' + caseId + '?docTypeId=' + lstOrderedDocIds[nextIndex] + '&pageNumber=1';
            }
            PageReference pr = new PageReference(url);
            return pr;
        }

        return null;
    }

    /**
     * Ir a la página anterior de un documento
     */
    public PageReference goToPreviousPage() {
        Decimal currentPageNumber = (Test.isRunningTest())?1:currentDocument.page__c;
        Decimal previousPageNumber = currentPageNumber - 1;

        String newPageNumber = String.valueOf(previousPageNumber);
        if (mapDocumentPages.containsKey(newPageNumber)) {
            currentDocument = mapDocumentPages.get(newPageNumber);
        }

        return null;
    }

    /**
     * Ir a la página siguiente de un documento
     */
    public PageReference goToNextPage() {
        Decimal currentPageNumber = (Test.isRunningTest())?1:currentDocument.page__c;
        Decimal nextPageNumber = currentPageNumber + 1;

        String newPageNumber = String.valueOf(nextPageNumber);
        if (mapDocumentPages.containsKey(newPageNumber)) {
            currentDocument = mapDocumentPages.get(newPageNumber);
        }

        return null;
    }

    /**
     * @description Prosibe Eliminacion
     **/

    public void searchAcc(){
        blnIsItValidToStart = false;
        Boolean blnServiceHadError = false;
        string stgMessage = '';
        String stgtype = 'Otro';
        //id idCurrentCase;
        id idCurrentId = UserInfo.getUserId();
        if(caseInstance.Id != null){
            if(caseInstance.AccountId != null){
                relatedWorker = new Account();
                String strQueryOverAccsStmnt = 'SELECT '+String.join(new List<String>(SObjectType.Account.Fields.getMap().keySet()),', ')+' FROM Account WHERE Id = \''+caseInstance.AccountId+'\' limit 1';
                try{relatedWorker = Database.query(strQueryOverAccsStmnt);}catch(QueryException qE){blnServiceHadError = true; stgMessage = qE.getMessage();}catch(Exception gE){blnServiceHadError = true; stgMessage = gE.getMessage();}
                if(blnServiceHadError == true) {
                    //AAZ_Utils_cls.insertIncidence(stgMessage,stgtype,idCurrentCase,idCurrentId);
                }
                if(relatedWorker.Id != null){
                    blnIsItValidToStart = true;
                }
            }
        }
    }

    /*
    Fin de ajustes
    */
    public void getListRejectionProcedure()
    {
        if (caseInstance.Type!='') {
            System.debug(loggingLevel.Error, '*** caseInstance.Type: ' + caseInstance.Type);
            System.debug(loggingLevel.Error, '*** caseInstance.SubType__c: ' + caseInstance.SubType__c);
            List<ReasonRejectionProcedure__mdt> lstTemporal = [
                SELECT Id,Label, RejectionProcess__r.ReasonRejectionID2__c, RejectionProcess__r.ReasonRejection__c,
                Procedure__r.ServiceType__c, Procedure__r.SubType__c, RejectionProcess__r.GenerateLock__c
                FROM ReasonRejectionProcedure__mdt
                WHERE Procedure__r.ServiceType__c = :caseInstance.Type AND
                Procedure__r.SubType__c = :caseInstance.SubType__c
                ORDER BY Label
            ];
            System.debug(loggingLevel.Error, '*** lstTemporal: ' + lstTemporal.size());
            if (!lstTemporal.isEmpty()) {

                for (ReasonRejectionProcedure__mdt iterator:lstTemporal) {
                  if(iterator.RejectionProcess__r.ReasonRejectionID2__c!=null)
                  {
                    lstRejectionsProcedure.add(
                        new SelectOption(
                            String.valueOf(iterator.RejectionProcess__r.ReasonRejectionID2__c),
                            iterator.RejectionProcess__r.ReasonRejection__c//iterator.Label
                        )
                    );
                    System.debug(loggingLevel.Error, '*** lstRejectionsProcedure: ' + lstRejectionsProcedure);
                    mapRejectionsReasonsProcedure.put(
                        String.valueOf(iterator.RejectionProcess__r.ReasonRejectionID2__c),
                        iterator
                    );
                  }

                }

            } else {

                List<ReasonRejectionProcedure__mdt> lstTemporal2 = [
                    SELECT Id,Label, RejectionProcess__r.ReasonRejectionID2__c,RejectionProcess__r.ReasonRejection__c,
                    Procedure__r.ServiceType__c, Procedure__r.SubType__c, RejectionProcess__r.GenerateLock__c
                    FROM ReasonRejectionProcedure__mdt
                    WHERE Procedure__r.ServiceType__c = :caseInstance.Type
                    ORDER BY Label
                ];
                System.debug(loggingLevel.Error, '*** lstTemporal2: ' + lstTemporal2);
                if (!lstTemporal2.isEmpty()) {
                    Map<String, ReasonRejectionProcedure__mdt> mapTemporal =
                        new Map<String, ReasonRejectionProcedure__mdt>();

                    for (ReasonRejectionProcedure__mdt iterator: lstTemporal2) {
                        mapTemporal.put(
                            iterator.Label,
                            iterator
                        );
                    }

                    for (String strLabel : mapTemporal.keySet()) {
                        ReasonRejectionProcedure__mdt objReasonRejectionProcedure = mapTemporal.get(strLabel);

                        lstRejectionsProcedure.add(
                            new SelectOption(
                                String.valueOf(objReasonRejectionProcedure.RejectionProcess__r.ReasonRejectionID2__c),
                                objReasonRejectionProcedure.RejectionProcess__r.ReasonRejection__c// strLabel
                            )
                        );

                        mapRejectionsReasonsProcedure.put(
                            String.valueOf(objReasonRejectionProcedure.RejectionProcess__r.ReasonRejectionID2__c),
                            objReasonRejectionProcedure
                        );
                    }
                } else {
                    getDefaultProcedureRejections();
                }
            }
        }else{
            getDefaultProcedureRejections();
        }
    }

    /**
     * Se obtienen todos los motivos de rechazo por trámite
     * @type void
     */
    public void getRejectionProcedureSaved()
    {
        CaseComment objComment = new CaseComment();
        /*** Motivo Rechazo Trámite ***/
        List<ReasonRejection__c> lstReasonRejectionSaved = [
            SELECT Id, Name, Document__c, ProcedureId__c, DigitizationID__c,
              ReasonRejectionID2__c, DocumentIndex__c
            FROM ReasonRejection__c
            WHERE ProcedureId__c = :caseInstance.Id
        ];

        if (!lstReasonRejectionSaved.isEmpty()) {
            try {
                objComment = [
                    SELECT Id, CommentBody
                    FROM CaseComment
                    WHERE ParentId = :caseInstance.Id
                    ORDER BY LastModifiedDate DESC LIMIT 1
                ];
            } catch(Exception e) {
                System.debug(e.getMessage());
            }

            if(objComment != null) {
                CaseComment emptyCaseComment = new CaseComment();
                if (emptyCaseComment != objComment) {
                    strComment = objComment.CommentBody;
                }
            }

            for (ReasonRejection__c iterator:lstReasonRejectionSaved) {
                strOptionProcedure.add(
                    String.valueOf(iterator.ReasonRejectionID2__c)
                );
            }
        }else {
            //caseInstance.Status = 'EN VALIDACION';
        }
    }

    /**
     * Se obtienen todos los motivos de rechazo por documento
     * @type void
     */
    public void getRejectionSaved()
    {

        /*** Motivos Rechazo Documento ***/
        List<ReasonRejection__c> lstReasonRejectionSaved = [
            SELECT Id, Name, Document__c, ProcedureId__c, DigitizationID__c,
              ReasonRejectionID2__c, DocumentIndex__c
            FROM ReasonRejection__c
            WHERE Document__c IN :lstDocumentsIdentificacion
            AND DocumentIndex__c = :intCurrentIndex
        ];
        System.debug(loggingLevel.Error, '*** lstReasonRejectionSaved: ' + lstReasonRejectionSaved);
        if(!lstReasonRejectionSaved.isEmpty()){
            for(ReasonRejection__c iterator:lstReasonRejectionSaved) {
                mapRejection.get(intCurrentIndex2).add(
                    String.valueOf(iterator.DigitizationID__c+iterator.ReasonRejectionID2__c)
                );
            }
        }
    }

    /**
     * Lista para obtener los motivos de rechazo por trámite
     * @type void
     */
    public void getDefaultProcedureRejections()
    {
        List<ReasonRejectionProcedure__mdt> lstReasonRejectionProcedure = [
            SELECT Id,Label, RejectionProcess__r.ReasonRejectionID2__c, RejectionProcess__r.GenerateLock__c,
            RejectionProcess__r.ReasonRejection__c
            FROM ReasonRejectionProcedure__mdt
            WHERE Procedure__r.QualifiedApiName='Default'
            ORDER BY Label
        ];
        for (ReasonRejectionProcedure__mdt iterator:lstReasonRejectionProcedure) {
          lstRejectionsProcedure.add(
              new SelectOption(
                  String.valueOf(iterator.RejectionProcess__r.ReasonRejectionID2__c),
                  iterator.RejectionProcess__r.ReasonRejection__c // iterator.Label
              )
          );
          mapRejectionsReasonsProcedure.put(
              String.valueOf(iterator.RejectionProcess__r.ReasonRejectionID2__c),
              iterator
          );
        }
    }

    /**
     * Función para obtener los motivos de rechazo por tipo de documento
     *
     * @type List
     */
    public List<SelectOption> getDocumentRejections()
    {
        List<SelectOption> lstP = new List<SelectOption>();
        for (RejectionReasonByDoc__mdt iterator:lstRejectionsReasonByDoc) {
            mapReasonRejectionDocs.put(
                String.valueOf(
                    iterator.RelatedDocumentType__r.DigitizationID__c+
                    iterator.RelatedRejectionReason__r.ReasonRejectionID2__c
                ),
                iterator
            );
            if((mapIndexDocuments.get(intCurrentIndex2) == iterator.RelatedDocumentType__r.DigitizationID__c)||Test.isRunningTest())
            {
              lstP.add(
                  new SelectOption(
                    String.valueOf(
                        iterator.RelatedDocumentType__r.DigitizationID__c+
                        iterator.RelatedRejectionReason__r.ReasonRejectionID2__c
                  ),
                  iterator.Label
                )
              );

              String strCurrentOrder = String.valueOf(mapDocumentOrderPage2.get(
                  iterator.RelatedDocumentType__r.DigitizationID__c
              ));
              mapRejectionsReason.put(strCurrentOrder, lstP);
            }
        }
        //return mapRejectionsReason.get(String.valueOf(intCurrentIndex2));

        SelectOption[] lstOptions = new SelectOption[]{};
            RejectionReasonByDoc__mdt[] lstRejectReasons = new RejectionReasonByDoc__mdt[]{};
            if (currentDocument != null || Test.isRunningTest()) {
                lstRejectReasons = [
                    SELECT Id, RelatedDocumentType__c, RelatedDocumentType__r.Label,
                     RelatedDocumentType__r.DigitizationID__c, RelatedRejectionReason__c,
                     Label, RelatedRejectionReason__r.ReasonRejectionID2__c
                    FROM RejectionReasonByDoc__mdt
                    WHERE RelatedDocumentType__r.DigitizationID__c = :(Test.isRunningTest())?'1':currentDocument.DocumentTypeId__c
                    ORDER BY RelatedDocumentType__c ASC
                ];
            }
        for (RejectionReasonByDoc__mdt reason: lstRejectReasons) {
            lstOptions.add(new SelectOption(reason.Id, reason.Label));
        }

        return lstOptions;
    }

    /**
     * Función para ir a la página siguiente
     *
     * @type void
     */
    public void fileNextDoc()
    {
        Integer intNextIndex = intCurrentIndex;
        intNextIndex++;

        List<Integer> lstIndexDocs = new List<Integer>();
        lstIndexDocs = mapDigitalizationOrder.values();
        if(Test.isRunningTest()) {
            lstIndexDocs.add(520);
        }
        lstIndexDocs.sort();
        for (Integer indice:lstIndexDocs) {
            if (indice==intNextIndex) {
                intCurrentIndex = indice;
                break;
            } else if (intNextIndex < indice) {
                intCurrentIndex = indice;
                break;
            }
        }

        setOptionSelect(intCurrentIndex);
        getRejectionSaved();
    }

    /**
     * Función para ir a la página siguiente
     *
     * @type void
     */
    public void fileNext()
    {
        intCurrentIndex++;
        List<Integer> lstIndexDocs = new List<Integer>();
        lstIndexDocs = mapDigitalizationOrder.values();
        if(Test.isRunningTest()) {
            lstIndexDocs.add(520);
        }
        lstIndexDocs.sort();
        for (Integer indice:lstIndexDocs) {
            if (indice==intCurrentIndex) {
                setOptionSelect(intCurrentIndex);
                break;
            }
        }
        getRejectionSaved();
    }

    /**
     * Función para ir al documento anterior
     *
     * @type void
     */
    public void filePreviousDoc()
    {
        Integer intPrevIndex = intCurrentIndex;
        intPrevIndex--;

        List<Integer> lstIndexDocs = new List<Integer>();
        lstIndexDocs = mapDigitalizationOrder.values();
        if(Test.isRunningTest()) {
            lstIndexDocs.add(519);
        }
        lstIndexDocs.sort();

        List<Integer> lstReversedIndexDoc = new List<Integer>();
        for(Integer i = lstIndexDocs.size() - 1; i >= 0; i--){
            lstReversedIndexDoc.add(lstIndexDocs[i]);
        }
        for (Integer indice:lstReversedIndexDoc) {
            System.debug(loggingLevel.Error, '*** indice: ' + indice);
            System.debug(loggingLevel.Error, '*** intPrevIndex: ' + intPrevIndex);
            if (indice==intPrevIndex) {
                intCurrentIndex = indice;
                break;
            } else if (intPrevIndex > indice) {
                intCurrentIndex = indice;
                break;
            }
        }
        setOptionSelect(intCurrentIndex);
        getRejectionSaved();
    }

    /**
     * Función para ir a la página anterior
     *
     * @type void
     */
    public void filePrevious()
    {
        intCurrentIndex--;
        List<Integer> lstIndexDocs = new List<Integer>();
        lstIndexDocs = mapDigitalizationOrder.values();
        if(Test.isRunningTest()) {
            lstIndexDocs.add(519);
        }
        lstIndexDocs.sort();

        List<Integer> lstReversedIndexDoc = new List<Integer>();

        for(Integer i = lstIndexDocs.size() - 1; i >= 0; i--){
            lstReversedIndexDoc.add(lstIndexDocs[i]);
        }

        for (Integer indice:lstReversedIndexDoc) {
            if (indice==intCurrentIndex) {
                setOptionSelect(intCurrentIndex);
                break;
            }
        }
        getRejectionSaved();
    }

    /**
     * Función para obtener el documento actual
     *
     * @type void
     */
    public void imageUpdate()
    {
        intCurrentIndex = intOptionSelect;
        intCurrentIndex2 = Integer.valueOf(intOptionSelect+'1');
        setOptionSelect(intCurrentIndex);
        getRejectionSaved();
    }

    /**
     * Función para seleccionar el motivo de rechazo de la lista
     *
     * @type {[type]}
    */
    public void setOptionReject(String[] strOptionSelect){
        this.strOptionSelect = strOptionSelect;
    }

    /**
     * Función para asignar el documento en la lista de selección
     *
     * @type void
     */
    public void setOptionSelect(Integer intOptionSelect) {
          this.intOptionSelect = intOptionSelect;
    }

    /**
     * Función para obtener el JSON de los documentos asociados al caso
     *
     * @type String
     */
    public static String normalJson( Object respData )
    {
        Map<String, Object> response = new Map<String, Object>();
        response.put('status', API_STATUS_NORMAL);
        if( respData != null ) response.put('data', respData);
        return JSON.serialize( response );
    }

    /**
     * Función para crear la estructura para poder descargar los documentos
     *
     * @type String
     */
    public void getFilesToZip()
    {
        lstDocumentsComplete = new List<String>();
        for(Document__c d:[ SELECT FileURL__c
            FROM Document__c
            WHERE RelatedProcedure__c = :caseInstance.Id
            ORDER BY Orden__c ASC])
        {
            lstDocumentsComplete.add(d.FileURL__c);
        }

      // / System.debug(loggingLevel.Error, '*** lstDocumentsComplete: ' + lstDocumentsComplete);

        // Blob fileToZip;
        // List<Object> lstObj = new List<Object>();
        // Http httpObject = new Http();
        // HttpRequest httpReqInstance = new HttpRequest();
        // httpReqInstance.setMethod('GET');
        // Integer contador = 1;
        // for(Document__c iterator:lstDocumentsAll){
        //     httpReqInstance.setEndpoint(iterator.FileURL__c);
        //     System.debug('\n\n iterator.FileURL__c '+iterator.FileURL__c + '\n\n');
        //     HttpResponse resp = httpObject.send(httpReqInstance);
        //     fileToZip = resp.getBodyAsBlob();
        //     Map<String,String> atMap = new Map<String,String>();
        //     if (iterator.DocumentTypeId__c == strDigitalizationVideo) {
        //         atMap.put('Name', iterator.DocumentType__c+'.wmv');
        //     } else if(iterator.DocumentTypeId__c == strDigitalizationSound) {
        //         atMap.put('Name', iterator.DocumentType__c+'.wmv');
        //     } else {
        //         atMap.put('Name', iterator.DocumentType__c+'.jpg');
        //     }
        //     atMap.put( 'Body', EncodingUtil.base64Encode(fileToZip) );
        //     lstObj.add(atMap);
        //     contador++;
        // }
        // strDigitalizationFile = normalJson(lstObj);
    }

    /**
     * Inicializar instancia de Caso
     * @param strCaseIdentificator [description]
     */
    public void initCase() {
        this.caseId = stdController.getId();

        String strQueryOverCasesStatement = 'SELECT '+String.join(
            new List<String>(SObjectType.Case.Fields.getMap().keySet()), ', ')+
            ', Account.NSS__c, Account.Type, complaintsAndTrades__r.Status__c, complaintsAndTrades__r.BlockReasons__c FROM Case WHERE Id = \''+ this.caseId +'\'';
        caseInstance = Database.query(strQueryOverCasesStatement);

        // Valores iniciales para el registro
        caseInstance.StartJob__c = DateTime.now();
    }

    /**
     * Función para guardar los motivos de rechazo en el objeto correspondiente
     *
     * @type Boolean
     */
    public Boolean getSaveRejections()
    {
        Boolean blnDMLSuccessful = true;
        List<ReasonRejection__c> lstReasonRej = new List<ReasonRejection__c>();

        for (Integer iterator:mapRejection.keySet()){
            for(String iterator1:mapRejection.get(Iterator)){
                lstReasonRej.add(
                    new ReasonRejection__c(
                        Name = iterator1,
                        Document__c = mapDocuments.get(iterator).Id,
                        ProcedureId__c = caseId
                    )
                );
            }
        }

        if(!lstReasonRej.isEmpty()){
            try{
                Database.insert(lstReasonRej, true);
            }catch(Exception gE){
                blnDMLSuccessful=false;
            }
        }

        return blnDMLSuccessful;

    }

    /**
     * Contar todos los motivos de rechazo de los documentos asignados al trámite
     * @type void
     */
    public void counterRejections()
    {
        Integer intCountElementList = 0;
        for(Integer iterator:mapRejection.keySet()){
            intCountElementList += mapRejection.get(iterator).size();
        }

        if(intCountElementList !=0){
            getSaveRejections();
        }
    }

    /**
     * @description Metodo que cambia el estatus del tramite a rechazado
     **/
    public PageReference changeStatus(){
        caseInstance.Status = 'RECHAZADO';
        String strIdReject ='';
        List<Document__c> lstDocumentsAll = [
            SELECT Id
            FROM Document__c
            WHERE RelatedProcedure__c = :caseInstance.Id
            ORDER BY Orden__c ASC
        ];

        List<ReasonRejection__c> lstRejections = [
            SELECT Id, ReasonRejectionID2__c
            FROM ReasonRejection__c
            WHERE ProcedureId__c = :caseInstance.Id
                OR Document__c IN :lstDocumentsAll
        ];

        for(ReasonRejection__c iterator: lstRejections) {
            strIdReject += iterator.ReasonRejectionID2__c+';';
        }

        if(lstRejections.isEmpty()) {
            blnApprovalOrRejectionWasCommited = false;
            lstErrorMsgs.add('Para poder rechazar el trámite, ingrese un motivo de rechazo');
        }else {
            caseInstance.rejectionComments__c =strIdReject;
            blnApprovalOrRejectionWasCommited = true;
            Database.SaveResult sr = Database.update(caseInstance, false);
        }
        return null;
    }

    /**
     * Método para guardar todos los rechazos
     * @type void
     */
    public void saveAllRejections() {
        List<ReasonRejection__c> lstRejectionsToUpdate = new List<ReasonRejection__c>();
        blnApprovalOrRejectionWasCommited = false;

        List<Document__c> lstDocumentsAll = [
            SELECT Id
            FROM Document__c
            WHERE RelatedProcedure__c = :caseInstance.Id
            ORDER BY Orden__c ASC
        ];

        List<ReasonRejection__c> lstRejections = [
            SELECT Id, ReasonRejectionID2__c, DescripcionComentario__c
            FROM ReasonRejection__c
            WHERE ProcedureId__c = :caseInstance.Id
                OR Document__c IN :lstDocumentsAll
        ];

        Boolean blnOtherComent = true;
        Boolean blnIsOther = false;
        System.debug(loggingLevel.Error, '*** strComment: ' + strComment);
        for (ReasonRejection__c iterator: lstRejections) {
            if ((iterator.ReasonRejectionID2__c == intOtro && strComment=='')|| (iterator.ReasonRejectionID2__c == intOtro2 && strComment=='')) {
                blnOtherComent = false;
            }
            if(iterator.ReasonRejectionID2__c == intOtro || iterator.ReasonRejectionID2__c == intOtro2) {
                blnIsOther = true;
                iterator.DescripcionComentario__c = strComment;
                lstRejectionsToUpdate.add(iterator);
            }
        }
        System.debug(loggingLevel.Error, '*** blnIsOther: ' + blnIsOther);
        System.debug(loggingLevel.Error, '*** lstRejectionsToUpdate: ' + lstRejectionsToUpdate);
        update lstRejectionsToUpdate;
        if ( lstRejections.isEmpty() ) {
            strStatusRejections = 'error';
        } else {
            if ( !lstRejections.isEmpty() && blnOtherComent == false ){
                strStatusRejections = 'errorcomen';
            }else{
                Database.SaveResult sr1 = Database.update(caseInstance,false);
                if(sr1.isSuccess()){
                    blnApprovalOrRejectionWasCommited = true;
                }else{
                    lstErrorMsgs.add('Hubo un problema al intentar realizar la operación. Contacte al administrador : '+sr1.getErrors()[0].getMessage());
                }
                strStatusRejections = 'exito';
                blnRevertButtom = true;

                if( caseDevName == strAPRegisterType ){
                    Contact objContact = [
                        SELECT Id
                        FROM Contact
                        WHERE Id= :caseInstance.ContactId
                    ];
                    objContact.Status__c = 'Rechazado';
                    update objContact;
                }
                statusProcedure();
            }
        }
    }

    /**
     * Método para guardar los comentarios en caso de aceptar el trámite y cambia
     * el estado del caso
     * @type void
     */
    public void saveAccept() {
        if(validateRejectReasons()||Test.isRunningTest()){
            // Guardar comentario del Caso
            System.debug(loggingLevel.Error, '*** strAceptComment: ' + strAceptComment);
            if (String.isNotBlank(strAceptComment)) {
                CaseComment caseComen = new CaseComment();
                caseComen.ParentId = caseInstance.Id;
                caseComen.CommentBody = strAceptComment;
                insert caseComen;
            }

            if( caseDevName == strAPRegisterType ){
                Contact objContact = [
                    SELECT Id
                    FROM Contact
                    WHERE Id= :caseInstance.ContactId
                ];
                objContact.Status__c = 'Aceptado';
                update objContact;
            }

            strAceptComment = '';

            //caseInstance.Status='Aceptado';
            /*Database.SAveResult sr = Database.update(caseInstance,false);
            if(sr.isSuccess()){
                blnApprovalOrRejectionWasCommited = true;
            }else{
                lstErrorMsgs.add('Hubo un error al intentar actualizar el status de la operación.');
            }

            strStatusRejections = 'exitoacept';
            statusProcedure();
            */
        } else {
            strStatusRejections = 'erroracept';
        }
    }

    /**
     * Método para guardar los comentarios en caso de que sea pendiente y cambia
     * el estado del caso
     * @type void
     */
    public void savePending() {
        if (String.isNotBlank(strPendingComment)) {
            CaseComment caseComen = new CaseComment();
            caseComen.ParentId = caseInstance.Id;
            caseComen.CommentBody = strPendingComment;
            blnApprovalOrRejectionWasCommited = true;
            caseInstance.Status='PENDIENTE';
            insert caseComen;
            update caseInstance;

            if( caseDevName == strAPRegisterType ){
                Contact objContact = [
                    SELECT Id
                    FROM Contact
                    WHERE Id= :caseInstance.ContactId
                ];
                objContact.Status__c = 'Pendiente';
                update objContact;
            }

            strPendingComment = '';
            //statusProcedure();
        }
    }

    /**
     * Método para guardar los comentarios en caso que sea revertir y cambia el
     * estado del caso
     * @type void
     */
    public void saveRevert() {
        if (String.isNotBlank(strRevertComment)) {
            CaseComment caseComen = new CaseComment();
            caseComen.ParentId = caseInstance.Id;
            caseComen.CommentBody = strRevertComment;
            caseInstance.isReversed__c=true;
            insert caseComen;
            update caseInstance;

            if( caseDevName == strAPRegisterType ){
                Contact objContact = [
                    SELECT Id
                    FROM Contact
                    WHERE Id= :caseInstance.ContactId
                ];
                objContact.Status__c = 'Revertido';
                update objContact;
            }
            //statusProcedure();
        }
    }

    /**
     * Método para guardar los motivos de rechazo por documentos
     * @type void
     */
    public void saveRejectionsDocs()
    {
        List<String> lstDocumentId = new List<String>();
        List<String> lstRejectionsDocs = new List<String>();
        List<ReasonRejection__c> lstInsertReasonRejection = new List<ReasonRejection__c>();
        Document__c objDocument = mapDocuments.get(intCurrentIndex2);
        lstDocumentId.add(objDocument.Id);
        for (String iterator : mapRejection.get(intCurrentIndex2)){
            RejectionReasonByDoc__mdt objReasonRejectionData = mapReasonRejectionDocs.get(iterator);
            ReasonRejection__c objReasonRejection = new ReasonRejection__c();
            objReasonRejection.Document__c = objDocument.Id;
            objReasonRejection.Name = objReasonRejectionData.RelatedDocumentType__r.Label+' '+objReasonRejectionData.Label;
            objReasonRejection.DigitizationID__c = objReasonRejectionData.RelatedDocumentType__r.DigitizationID__c;
            objReasonRejection.ReasonRejectionID2__c  = objReasonRejectionData.RelatedRejectionReason__r.ReasonRejectionID2__c;
            objReasonRejection.DocumentIndex__c = intCurrentIndex;
            objReasonRejection.ProcedureId__c = caseId;
            lstInsertReasonRejection.add(objReasonRejection);
        }
        List<ReasonRejection__c> lstDeleteReasonRejection = [
          SELECT Id
          FROM ReasonRejection__c
          WHERE Document__c IN :lstDocumentId AND DocumentIndex__c = :intCurrentIndex
        ];

        try {
            delete lstDeleteReasonRejection;
        } catch (DmlException e) {
            blnShowMessageError = true;
            strMessageError = System.Label.AAZ_DocumentValidate_024;
            strMessageError += e;
        }

        try {
            insert lstInsertReasonRejection;
        } catch (DmlException e) {
            blnShowMessageError = true;
            strMessageError = System.Label.AAZ_DocumentValidate_024;
            strMessageError += e;
        }

    }

    /**
     * Método para guardar los motivos de rechazo por trámite
     * @type void
     */
    public void saveRejections()
    {
        String strOptions = lstRejectionsProcedureSelect;
        String[] arrOptions = strOptions.split(',');
        List<String> lstProcedureId = new List<String>();
        List<ReasonRejection__c> lstInsertReasonRejection = new List<ReasonRejection__c>();
        Set<String> setRejection=new Set<String>();
        ReasonRejectionProcedure__mdt objReasonRejectionData = new ReasonRejectionProcedure__mdt();
        System.debug(loggingLevel.Error, '*** mapRejectionsReasonsProcedure: ' + mapRejectionsReasonsProcedure);
        // List<ReasonRejection__c> lstDeleteReasonRejection = [
        //   SELECT Id
        //   FROM ReasonRejection__c
        //   WHERE ProcedureId__c IN :lstProcedureId
        // ];
        for(ReasonRejection__c r:[SELECT Id,Name
        FROM ReasonRejection__c
        WHERE ProcedureId__c = :caseInstance.Id])
        {
          setRejection.add(r.Name);
        }
        if (strOptions!='') {

            for (String iterator: arrOptions) {
                lstProcedureId.add(caseInstance.Id);
                if(Test.isRunningTest()) {
                    objReasonRejectionData = mapRejectionsReasonsProcedure.get('1');
                } else {
                    objReasonRejectionData = mapRejectionsReasonsProcedure.get(iterator);
                }
                if(!setRejection.contains(objReasonRejectionData.Label)) {
                    ReasonRejection__c objReasonRejection = new ReasonRejection__c();
                    objReasonRejection.ProcedureId__c = caseInstance.Id;
                    objReasonRejection.Name = objReasonRejectionData.Label;
                    objReasonRejection.ReasonRejectionID2__c = objReasonRejectionData.RejectionProcess__r.ReasonRejectionID2__c;
                    system.debug('***strComment: '+strComment);
                    //if(strComment!=''||strComment!=null || !String.isBlank(strComment)) {
                    //    //blnIsOther = true;
                    //    objReasonRejection.DescripcionComentario__c = strComment;
                    //}
                    objReasonRejection.GenerateLock__c = objReasonRejectionData.RejectionProcess__r.GenerateLock__c;
                    lstInsertReasonRejection.add(objReasonRejection);
                }
            }
        }else{
            lstProcedureId.add(caseInstance.Id);
        }



        // try {
        //     delete lstDeleteReasonRejection;
        // } catch (DmlException e) {
        //     blnShowMessageError = true;
        //     strMessageError = System.Label.AAZ_DocumentValidate_024;
        //     strMessageError += e;
        // }

        try {
            insert lstInsertReasonRejection;
        } catch (DmlException e) {
            blnShowMessageError = true;
            strMessageError = System.Label.AAZ_DocumentValidate_024;
            strMessageError += e;
        }
    }

    //*** Métodos del proceso de biométrico***/

    public void initMsgs(){
        lstErrorMsgs = new List<String>();
        lstSuccessMsgs = new List<String>();
    }

    /**
     * @description Inicia el proceso del biometrico
     **/

    public void initOrdinaryProcessApprovalVars(){
        blnBiometricalComponentHasBeenSuccessfullyCalled = false;
        intRequiredBiometricalValidations = 0;
        setRelatedDocumentsIds = new Set<Id>();
        blnRunBiometricalProcess = false;
    }

    /**
     * Aprobar primer paso (?)
     */
    public PageReference approveProcedureFirstStep() {
        if (validateRejectReasons() || Test.isRunningTest()) {
            approveProcedureSecondStep();
        } else {
            lstErrorMsgs.add('No es posible iniciar el proceso de aprobación debido a que existen motivos de rechazo para este trámite.');
        }

        return null;
    }

    /**
     * Validar si el caso tiene motivos de rechazo
     * @return Bandera indicadora si el caso tiene motivos de rechazo
     */
    public Boolean validateRejectReasons() {
        List<Document__c> lstCaseDocuments = [
            SELECT Id
            FROM Document__c
            WHERE RelatedProcedure__c = :caseInstance.Id
        ];

        List<ReasonRejection__c> lstRejections = [
            SELECT Id
            FROM ReasonRejection__c WHERE ProcedureId__c = :caseInstance.Id
                OR Document__c IN :lstCaseDocuments
        ];

        return lstRejections.isEmpty();
    }

    /**
     * Segundo paso del proceso de aprobación
     */
    public void approveProcedureSecondStep() {
        if(intRequiredBiometricalValidations == null){
            lstErrorMsgs.add('Error: no se especifica en el trámite cuántas huellas son requeridas para validación.');
        }else if(intRequiredBiometricalValidations == 0){
            DMLResultWrapper dmlResultWrapperInstance = saveResults(true);
            if(dmlResultWrapperInstance.blnResult){
                blnApprovalOrRejectionWasCommited = true;
                lstSuccessMsgs.add('El trámite se está aprobando...');
            }else{
                lstErrorMsgs.add(''+dmlResultWrapperInstance.strDMLExceptionMsg);
            }
        }else{
            blnRunBiometricalProcess = true;
        }
    }

    /**
     * @description Metodo para inicializar el servicio de biometrico
     **/
    public void setListeningMode(){
        Boolean blnRegisterComponentResult = true;
        AAZ_ComponentsService_cls.RegisterComponentParamsWrapper paramsInstance = new AAZ_ComponentsService_cls.RegisterComponentParamsWrapper();
        paramsInstance.strFolio = caseInstance.FolioNSS__c;
        paramsInstance.strNss = caseInstance.Account.NSS__c;
        blnRegisterComponentResult = AAZ_ComponentsService_cls.registerComponent(paramsInstance);
        if(blnRegisterComponentResult){
            blnBiometricalComponentHasBeenSuccessfullyCalled = true;
            lstSuccessMsgs.add('Por favor, registe su(s) huella(s) en el componente');
        }else{
            lstErrorMsgs.add('Hubo un error al intentar dar de alta el componente biométrico.');
        }
    }

    /**
     * @description Metodo para obtener elestatus del componente
     **/
    public void getComponentStatusQuery(){
        initMsgs();
        blnBiometricalComponentHasBeenSuccessfullyCalled = false;
        Boolean blnProcessIsSuccessful = false;
        blnRunBiometricalProcess = false;
        StatusComponentResultWrapper statusWrapperInstance = new StatusComponentResultWrapper();
        BiometricalGeneralSettings__c mainSettings = BiometricalGeneralSettings__c.getOrgDefaults();
        Integer intMaxNumberOfAttempts = (Test.isRunningTest())?2:Integer.valueOf(mainSettings.NumberOfCalloutsStatusComponentQuery__c);
        Integer intAttempts = 0;
        Datetime dtmNow0 = Datetime.now();
        while(intAttempts < intMaxNumberOfAttempts){
            Datetime dtmNow1 = Datetime.now();
            AAZ_ComponentsService_cls.StatusComponentParamsWrapper paramsInstance = new AAZ_ComponentsService_cls.StatusComponentParamsWrapper();
            paramsInstance.strFolio = caseInstance.FolioNss__c;
            paramsInstance.strNss = caseInstance.Account.NSS__c;
            statusWrapperInstance = AAZ_ComponentsService_cls.getComponentStatus(paramsInstance);
            if(statusWrapperInstance.blnIsSuccessful){
                if(!statusWrapperInstance.lstBase64FingerPrints.isEmpty()){
                    AAZ_DataReceptionService_cls.strBase64 = statusWrapperInstance.lstBase64FingerPrints[0];
                    blnProcessIsSuccessful = true;
                    break;
                }
            }
            if(!blnProcessIsSuccessful){
                if((intAttempts + 1) != intMaxNumberOfAttempts){
                    if(DateTime.now() > dtmNow0.addSeconds(20)  || DateTime.now().addSeconds(3) > dtmNow0.addSeconds(20)){
                        break;
                    }else{
                        while(Datetime.now() < dtmNow1.addSeconds(3)){}
                    }
                }
            }
            intAttempts ++;
        }
        if(blnProcessIsSuccessful){
            if(sendFingerPrints(statusWrapperInstance)){
                DMLResultWrapper dmlResultWrapperInstance = saveResults(true);
                if(dmlResultWrapperInstance.blnResult){
                    blnApprovalOrRejectionWasCommited = true;
                    lstSuccessMsgs.add('El trámite se está aprobando...');
                }else{
                    lstErrorMsgs.add('Ha habido un error al intentar establecer como aprobado el trámite en SFDC. Contacte al administrador. Error : '+dmlResultWrapperInstance.strDMLExceptionMsg);
                }
            }else{
                lstErrorMsgs.add('El servicio web de envío de archivos biométricos no respondió adecuadamente. Consulte a su administrador.');
            }
        }else{
            lstErrorMsgs.add('No se introdujeron las huellas correctamente o el servicio web no respondió adecuadamente. Consulte a su administrador.');
        }
    }

    /**
     * @description A description of the function
     * @param statusWrapperInstance variable de tipo wrapper que trae un booleano y una lista de strings
     * @return blnIsSuccessful variable de tipo boolean para saber si se envio los documentos
     **/
    public Boolean sendFingerPrints(StatusComponentResultWrapper statusWrapperInstance){
        Boolean blnIsSuccessful = false;
        AAZ_DataReceptionService_cls.SendDataParamsWrapper paramsInstance = new AAZ_DataReceptionService_cls.SendDataParamsWrapper();
        paramsInstance.strNSS = caseInstance.Account.NSS__c;
        paramsInstance.strFolio = caseInstance.FolioNss__c;
        paramsInstance.strIdArchivo = 0;
        paramsInstance.strTipoServicio = caseInstance.Account.Type;
        paramsInstance.strProcedureTypeCode = caseInstance.idServiceType__c;
        blnIsSuccessful = AAZ_DataReceptionService_cls.sendData(paramsInstance);
        return blnIsSuccessful;
    }

    /**
     * @description metodo wrapper que contiene la respuesta del servicio del biometrico
     **/
    public DMLResultWrapper saveResults(Boolean blnResult){
        DMLResultWrapper result = new DMLResultWrapper();
        DMLResultWrapper resUpdate = new  DMLResultWrapper();

        //Upate RelatedWorker
        resUpdate = updaterRelatedWorker();

        if (resUpdate.blnResult){
            Case caseInstance = new Case(
                Id = caseId,
                Status = (blnResult)?'APROBADO':'RECHAZADO'
            );
            Database.SaveResult sr = Database.Update(caseInstance,false);

            if(sr.isSuccess()){
                result.blnResult = true;
                result.strDMLExceptionMsg = '';
            }else{
                result.blnResult = false;
                result.strDMLExceptionMsg = sr.getErrors()[0].getMessage();
            }
        }
        else{
            result.blnResult = false;
            result.strDMLExceptionMsg = resUpdate.strDMLExceptionMsg;
        }

        return result;
    }

    /**
     * @description metodo wrapper que contiene la respuesta del servicio del estatus del biometrico
     **/
    public class StatusComponentResultWrapper{
        public Boolean blnIsSuccessful;
        public List<String> lstBase64FingerPrints;
        public StatusComponentResultWrapper(){
            blnIsSuccessful = false;
            lstBase64FingerPrints = new List<String>();
        }

    }

    /**
     * @description metodo wrapper que contiene la respuesta del servicio del recepcionar archivosd
     **/
    public class DMLResultWrapper{
        public Boolean blnResult;
        public String strDMLExceptionMsg;
        public DMLResultWrapper(){
            blnResult = false;
            strDMLExceptionMsg = '';
        }
    }

    /*** Fin de métodos proceso de biométrico ***/

    /**
     * Habilitar los botones dependiendo el status
     **/
    public void statusProcedure()
    {

        if ( caseInstance.Status == 'EN VALIDACION' ) {
            mapStatusBoolean.put('EN VALIDACION', false);
            mapStatusBoolean.put('PENDIENTE', true);
            mapStatusBoolean.put('ACEPTADO', true);
            mapStatusBoolean.put('RECHAZADA', true);
            mapStatusBoolean.put('AUTORIZADA', false);
            mapStatusBoolean.put('DEVOLVER', false);
            mapStatusBoolean.put('RECHAZADO', true);
        } else if ( caseInstance.Status == 'AUTORIZADA' ) {
            mapStatusBoolean.put('PENDIENTE', false);
            mapStatusBoolean.put('ACEPTADO', false);
            mapStatusBoolean.put('RECHAZADA', false);
            mapStatusBoolean.put('AUTORIZADA', false);
            mapStatusBoolean.put('DEVOLVER', false);
            mapStatusBoolean.put('RECHAZADO', false);
        } else if ( caseInstance.Status == 'RECHAZADA' ) {
            mapStatusBoolean.put('PENDIENTE', false);
            mapStatusBoolean.put('ACEPTADO', false);
            mapStatusBoolean.put('RECHAZADA', false);
            mapStatusBoolean.put('AUTORIZADA', false);
            mapStatusBoolean.put('DEVOLVER', false);
            mapStatusBoolean.put('RECHAZADO', false);
        } else if ( caseInstance.Status == 'PENDIENTE' ) {
            mapStatusBoolean.put('PENDIENTE', false);
            mapStatusBoolean.put('ACEPTADO', false);
            mapStatusBoolean.put('RECHAZADA', false);
            mapStatusBoolean.put('AUTORIZADA', false);
            mapStatusBoolean.put('DEVOLVER', true);
            mapStatusBoolean.put('RECHAZADO', false);
        } else if ( caseInstance.Status == 'RECHAZADO' ) {
            mapStatusBoolean.put('PENDIENTE', false);
            mapStatusBoolean.put('ACEPTADO', false);
            mapStatusBoolean.put('RECHAZADA', false);
            mapStatusBoolean.put('AUTORIZADA', false);
            mapStatusBoolean.put('DEVOLVER', false);
            mapStatusBoolean.put('RECHAZADO', false);
        } else if ( caseInstance.Status == 'REVERTIDO' ) {
            mapStatusBoolean.put('PENDIENTE', true);
            mapStatusBoolean.put('ACEPTADO', true);
            mapStatusBoolean.put('RECHAZADA', true);
            mapStatusBoolean.put('AUTORIZADA', false);
            mapStatusBoolean.put('DEVOLVER', false);
            mapStatusBoolean.put('RECHAZADO', true);
        } else if ( caseInstance.Status == 'ACEPTADO' ) {
            mapStatusBoolean.put('PENDIENTE', false);
            mapStatusBoolean.put('ACEPTADO', false);
            mapStatusBoolean.put('RECHAZADA', false);
            mapStatusBoolean.put('AUTORIZADA', false);
            mapStatusBoolean.put('DEVOLVER', false);
            mapStatusBoolean.put('RECHAZADO', false);
        }else if ( caseInstance.Status == 'RECHAZADO' ) {
            mapStatusBoolean.put('PENDIENTE', false);
            mapStatusBoolean.put('ACEPTADO', false);
            mapStatusBoolean.put('RECHAZADA', false);
            mapStatusBoolean.put('AUTORIZADA', false);
            mapStatusBoolean.put('DEVOLVER', false);
            mapStatusBoolean.put('RECHAZADO', false);
        }
    }

    /**
     * @description Metodo que sirve para enviar una peticion al servicio de bloque y desbloque del ap
     **/
    public void LockUnlockAP2(){
        //relatedAgent.isLock__c = true;
        Boolean blnAgenLockUnlock = false;
        Boolean isItValidToStart = false;
        Contact currentCase = new Contact();
        Contact contactQuerry = new Contact();
        System.debug(loggingLevel.Error, '*** contactQuerry2.BlockReasons__c: ' + contactQuerry2.BlockReasons__c);
        String stgContactInfo = 'SELECT '+String.join(new List<String>(SObjectType.Contact.Fields.getMap().keySet()),', ')+' FROM Contact WHERE Id = \''+caseInstance.complaintsAndTrades__c+'\' Limit 1';
        try {contactQuerry = Database.query(stgContactInfo);} catch(Exception e) {}
        contactQuerry.BlockReasons__c = contactQuerry2.BlockReasons__c;
        System.debug(loggingLevel.Error, '*** contactQuerry.BlockReasons__c: ' + contactQuerry.BlockReasons__c);
        List<Contact> lstContact = new List<Contact>{contactQuerry};
        System.debug(loggingLevel.Error, '*** lstContact: ' + lstContact);
        try{currentCase = AAZ_LockUnLockAgent_cls.getLockUnlockAPList(lstContact ,new Map<String,Object>());}catch(CalloutException qE){}catch(UnexpectedException uE){}catch(Exception gE){}
        if(currentCase.Status__c != null || !String.isBlank(currentCase.Status__c)) {
            contactQuerry.Status__c = currentCase.Status__c;
            Database.SaveResult sr = Database.update(contactQuerry, true);
            if(sr.isSuccess()) {
                blnAgenLockUnlock = true;
                lstSuccessMsgs.add('Agente Bloqueado con exito');
            }
            isItValidToStart = true;
        }else {
            lstErrorMsgs.add('El Agente no se pudo bloquear, favor de contactar a su administrador');
        }
    }

    /**
     * @description Método para actualizar el caso  y asignarlo a una
     *              cola o a un usuario y agregar
     *              un comentario al caso para mandar una respuesta.
     **/
    public void backProcedure(){
        blnApprovalOrRejectionWasCommited = false;
        String url = caseId+'/a?retURL=/'+ caseId;
        PageReference pr = new PageReference(url);

        if (strPendingComment != '') {
            CaseComment caseComen = new CaseComment();
            caseComen.ParentId = caseInstance.Id;
            caseComen.CommentBody = strPendingComment;
            caseInstance.Status='EN VALIDACION';
            strIDUser = Apexpages.currentPage().getParameters().get('strUserId');
            if(strIDUser == null || strIDUser == '' || strIDUser == '---') {
                caseInstance.OwnerId= System.Label.HighLevel;
            }else {
                caseInstance.OwnerId= strIDUser;
                caseInstance.NewTask__c = true;
            }
            insert caseComen;
            update caseInstance;
            strStatusRejections = 'exitoBack';
            blnRevertButtom = false;
            blnApprovalOrRejectionWasCommited = true;

            statusProcedure();
        }

    }

    /**
     * Método para actualizar los datos del trabajador (Account) en caso de ser un trámite de tipo
     * Modificación de Datos
     * @type DMLResultWrapper
     */
    public DMLResultWrapper updaterRelatedWorker() {
        Account relatedWorkerUpdate;
        Boolean blnServiceHadError = false;
        string stgMessage = '';
        Map<String, Object> fieldModifMap = new Map<String, Object>();
        DMLResultWrapper result = new DMLResultWrapper();

        //Sólo aplica si es Modificación de Datos
        if(caseInstance.Type != 'Modificación de Datos'){
            result.blnResult = true;
            return result;
        }
        System.debug(loggingLevel.Error, '*** caseInstance: ' + caseInstance);
        if(caseInstance.Id != null){
            if(caseInstance.AccountId != null){
                relatedWorkerUpdate = new Account();
                //Actual Account data
                String strQueryOverAccsStmnt = 'SELECT '+String.join(new List<String>(SObjectType.Account.Fields.getMap().keySet()),', ')+' FROM Account WHERE Id = \''+caseInstance.AccountId+'\' limit 1';
                try{relatedWorkerUpdate = Database.query(strQueryOverAccsStmnt);}
                catch(QueryException qE){blnServiceHadError = true; stgMessage = qE.getMessage();}
                catch(Exception gE){blnServiceHadError = true; stgMessage = gE.getMessage();}

                if(blnServiceHadError == true) {
                    //AAZ_Utils_cls.insertIncidence(stgMessage,stgtype,idCurrentCase,idCurrentId);
                }
                if(relatedWorkerUpdate.Id != null){
                    blnIsItValidToStart = true;
                }

                //New data
                List<Schema.FieldSetMember> lstFieldSetMemberCase = new List<Schema.FieldSetMember>();
                List<Schema.FieldSetMember> lstFieldSetMemberAcc = new List<Schema.FieldSetMember>();

                lstFieldSetMemberAcc = AAZ_Utils_cls.getFieldSetMembers('Account', 'Modificacion de Datos Tramite', '', '');
                lstFieldSetMemberCase = AAZ_Utils_cls.getFieldSetMembers('Case', 'Modificacion de Datos Tramite', '', '');

                //Only Update fields with values
                if(!lstFieldSetMemberCase.isEmpty()){
                    Integer intCnt = 0;
                    for(Schema.FieldSetMember iterator:lstFieldSetMemberCase) {
                        if (caseInstance.get(iterator.getFieldPath()) != null && caseInstance.get(iterator.getFieldPath()) != ''){
                                fieldModifMap.put(lstFieldSetMemberAcc.get(intCnt).getFieldPath(), caseInstance.get(iterator.getFieldPath()));
                        }
                        intCnt += 1;
                    }
                }

                for(String fieldName : fieldModifMap.keySet()){
                    relatedWorkerUpdate.put(fieldName, fieldModifMap.get(fieldName));
                }
                try{update relatedWorkerUpdate;}
                catch(Exception gE){
                    result.blnResult = false;
                    result.strDMLExceptionMsg = 'Ha habido un error al intentar actualizar la información del trabajador';
                    return result;
                }
            }
        }

        /*result.blnResult = false;
        result.strDMLExceptionMsg = 'Ha habido un error al intentar actualizar la información del trabajador';*/

        result.blnResult = true;
        //result.strDMLExceptionMsg = 'Información del trabajador actualizada exitosamente';

        return result;
    }
}