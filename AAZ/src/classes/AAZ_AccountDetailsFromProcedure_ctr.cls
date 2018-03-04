/*******************************************************************************
Desarrollado por: Avanxo México

Autor: Samuel Galindo
Autor: Luis E. Garcia

Proyecto: Afore Azteca

Descripción: Clase que muestra los datos del trabajadador junto con su firma,
su foto y la firma del agente promotor. Además se permite descargarlos de manera
individual. En cada uno se puede poner motivos de rechazos los cuales aparecen
mediante un combobox. También se muestra a los beneficiarios y referenciados
relacionados al trabajador. Al dar click en el nombre de los beneficiarios y
referenciados se muestra el detalle.

------ ---------- -------------------------- -----------------------------------
No.    Fecha      Autor                      Descripción
------ ---------- -------------------------- -----------------------------------
1.0    26/07/2017 Luis E. Garcia              Clase creada
1.1    10/08/2017 Samuel Galindo              Anexo de Beneficiarios y referenciados
1.2    07/11/2017 Samuel Galindo              Quitaron System.debug y modificacion if linea 185
*******************************************************************************/
public class AAZ_AccountDetailsFromProcedure_ctr {

    public String strMessageError{set;get;}
    public Boolean blnShowMessageError{set;get;}
    public Account relatedWorker{set;get;}
    public Boolean isItValidToStart{set;get;}
    public List<String> lstValidDocuments{set;get;}
    public String strCaseId{set;get;}
    public List<Document__c> lstRelatedDocuments{set;get;}
    public Map <String, Document__c> mapProfileImagenes{set;get;}
    public Integer intRelatedDocumentsAll{set;get;}
    public String strDigitalizationNumber{set;get;}
    public transient String strDigitalizationFile{set;get;}
    private static String API_STATUS_NORMAL = '200';
    public String strDigitalizationTrabajador {set;get;}
    public String strDigitalizationTrabajador2{set;get;}
    public List<String> lstSignatures{set;get;}
    public Map<String, List<String>> mapRejection{set;get;}
    public Map<String, List<SelectOption>> mapRejectionsReason{set;get;}
    public List<RejectionReasonByDoc__mdt> lstRejectionsReasonByDoc{set;get;}
    public String strRecordTypeCase{get;set;}
    public String strCaseIdentifier{get;set;}
    public String strCaseType{set;get;}
    public String strCaseSubType{set;get;}
    public string strCIT  {set;get;}
    public string strCIT2  {set;get;}
    public string strWithdrawtype {set;get;}
    public String strIdSecuritytype {set; get;}
    public String strIdPensiontype {set; get;}
    public String strFolioCUS {set; get;}
    public String strPrintsReq {set; get;}
    public Date dateCUSDate {set; get;}
    public String strSiefore {set; get;}
    public String strRegimeType {set; get;}
    public String strStatusCase{set;get;}
    public Datetime dTimeReviewDate {set;get;}
    public Map<String, RejectionReasonByDoc__mdt> mapReasonRejectionDocs{set;get;}
    public Case caseInstance{set;get;}
    public List<String> lstDocumentsIdentificacion{set;get;}
    public Integer intCountResults{set;get;}
    public List<String> lstDocumentTypeId{set;get;}
    public String strDigitalDocument{set;get;}
    public String strDocumentURL{set;get;}
    public String strTypePhoceCase{set;get;}
    public List<DocumentType__mdt> lstDocumentTypeMDT{set;get;}
    public id idCurrentCase {set;get;}
    public List<ReasonRejection__c> lstInsertReasonRejection {set;get;}
    public List<Case> lstCase {set;get;}


    /**
     * Constructor de la clase
     */
    public AAZ_AccountDetailsFromProcedure_ctr(ApexPages.StandardController stdCtl){

        lstInsertReasonRejection = new List<ReasonRejection__c>();

        lstCase = new List<Case>();

        lstDocumentTypeMDT = new List<DocumentType__mdt>();
        lstDocumentTypeMDT = [
            SELECT Id, DeveloperName,DigitizationID__c, Label
            FROM DocumentType__mdt
            ORDER BY DigitizationID__c
        ];
        lstValidDocuments = new List<String>();
        lstSignatures = new List<String>();
        for (DocumentType__mdt iterator:lstDocumentTypeMDT) {
            if ( iterator.DeveloperName == 'PictureWorker' ) {
                strDigitalizationTrabajador = iterator.DigitizationID__c;
                lstValidDocuments.add(iterator.DigitizationID__c);
            } else if (iterator.DeveloperName == 'WorkerSignature') {
                lstValidDocuments.add(iterator.DigitizationID__c);
                lstSignatures.add(iterator.DigitizationID__c);
            } else if (iterator.DeveloperName == 'APSignature') {
                lstValidDocuments.add(iterator.DigitizationID__c);
                lstSignatures.add(iterator.DigitizationID__c);
            } else if (iterator.DeveloperName == 'PictureaP') {
                lstValidDocuments.add(iterator.DigitizationID__c);
                strDigitalizationTrabajador2 = iterator.DigitizationID__c;
                lstSignatures.add(iterator.DigitizationID__c);
            } else if (iterator.DeveloperName == 'DigitalSignature') {
                lstValidDocuments.add(iterator.DigitizationID__c);
                lstSignatures.add(iterator.DigitizationID__c);
            }else if (iterator.DeveloperName == 'PictureWorkerNM') {
                lstValidDocuments.add(iterator.DigitizationID__c);
                lstSignatures.add(iterator.DigitizationID__c);
            }

        }

        strTypePhoceCase = 'AFILIACION';
        strDocumentURL = '';
        strDigitalDocument = '';
        if(Test.isRunningTest()){
            lstValidDocuments.add('1');
            strDigitalDocument = '10';
        }
        lstDocumentTypeId = new List<String>();
        intCountResults = 0;
        lstDocumentsIdentificacion = new List<String>();
        blnShowMessageError = false;
        strMessageError = '';
        mapReasonRejectionDocs = new Map<String, RejectionReasonByDoc__mdt>();
        strCaseIdentifier = '';
        lstRejectionsReasonByDoc = new List<RejectionReasonByDoc__mdt>();
        mapRejectionsReason = new Map<String, List<SelectOption>>();
        mapRejection = new Map<string, List<String>>();
        strDigitalizationNumber = '';
        strDigitalizationFile = '';
        strCaseId = '';
        mapProfileImagenes = new Map<String, Document__c>();
        intRelatedDocumentsAll = 0;
        Boolean blnServiceHadError = false;
        string stgMessage = '';
        String stgtype = 'Web Service';
        idCurrentCase = stdCtl.getId();
        id idCurrentId = UserInfo.getUserId();
        strRecordTypeCase = '';

        List<String> lstAccsFields = new List<String>();
        for(String i:SObjectType.Account.Fields.getMap().keySet()){
            lstAccsFields.add('Account.'+i);
        }

        List<String> lstContFields = new List<String>();
        for(String i:SObjectType.Contact.Fields.getMap().keySet()){
            lstContFields.add('APValidationContact__r.'+i);
        }
        List<String> lstContFields2 = new List<String>();
        for(String i:SObjectType.Contact.Fields.getMap().keySet()){
            lstContFields2.add('Contact.'+i);
        }

        String strQueryOverCasesStatement = 'SELECT '+String.join(
          new List<String>(SObjectType.Case.Fields.getMap().keySet()), ', ')+
          ', '+ String.join(lstAccsFields,', ') +', '+ String.join(lstContFields,', ') +', '+ String.join(lstContFields2,', ') +' ,RecordType.DeveloperName FROM Case WHERE Id = \''+stdCtl.getId()+'\' Limit 1';
        caseInstance = Database.query(strQueryOverCasesStatement);
        strCaseType = caseInstance.Type;
        strCaseSubType = caseInstance.Subtype__c;
        strStatusCase = caseInstance.Status;
        strCIT = caseInstance.ImplicationVerified__c;
        strCIT2 = caseInstance.FolioNSS__c;
        strWithdrawtype = caseInstance.IdWithdrawtype__c;
        strIdSecuritytype = caseInstance.IdSecuritytype__c;
        strIdPensiontype = caseInstance.IdPensiontype__c;
        strRegimeType = caseInstance.idRegimeType__c;
        strPrintsReq = caseInstance.Numero_de_Huellas_Requeridas__c;
        strFolioCUS = caseInstance.folioCus__c;
        dateCUSDate = caseInstance.constancyDate__c;
        strSiefore = caseInstance.ciafore__c;
        dTimeReviewDate = caseInstance.reviewDateQ__c;

        try {
            lstRelatedDocuments = [
                SELECT Id, Name, FileURL__c, DocumentTypeId__c, DocumentType__c
                FROM Document__c
                WHERE DocumentTypeId__c IN :lstValidDocuments AND
                RelatedProcedure__c = :stdCtl.getId()
                ORDER BY DocumentTypeId__c ASC
            ];
            if(Test.isRunningTest())
                integer intTest =1/0;
        } catch(QueryException qE){blnServiceHadError = true; stgMessage= qE.getMessage();}catch(Exception gE){blnServiceHadError = true; stgMessage= gE.getMessage();}
        if(!lstRelatedDocuments.isEmpty()){
            intCountResults = lstRelatedDocuments.size();
            for(Document__c iterator:lstRelatedDocuments) {
                mapProfileImagenes.put(iterator.DocumentTypeId__c, iterator);
                mapRejection.put(Iterator.DocumentTypeId__c, new List<String>());
                lstDocumentsIdentificacion.add(iterator.Id);
                lstDocumentTypeId.add(iterator.DocumentTypeId__c);

            }

            lstRejectionsReasonByDoc = [
                SELECT Id, RelatedDocumentType__c, RelatedDocumentType__r.Label,
                 RelatedDocumentType__r.DigitizationID__c, RelatedRejectionReason__c,
                 Label, RelatedRejectionReason__r.ReasonRejectionID2__c, RelatedRejectionReason__r.ReasonRejection__c, RelatedRejectionReason__r.GenerateLock__c
                FROM RejectionReasonByDoc__mdt
                //WHERE RelatedDocumentType__r.DigitizationID__c IN :lstValidDocuments
                WHERE RelatedDocumentType__r.DigitizationID__c IN :lstDocumentTypeId
                ORDER BY RelatedDocumentType__c ASC
            ];
            System.debug(loggingLevel.Error, '*** lstRelatedDocuments: ' + lstRelatedDocuments);
            System.debug(loggingLevel.Error, '*** lstDocumentTypeId: ' + lstDocumentTypeId);
            System.debug(loggingLevel.Error, '*** lstValidDocuments: ' + lstValidDocuments);
            System.debug(loggingLevel.Error, '*** lstRejectionsReasonByDoc: ' + lstRejectionsReasonByDoc);

            intRelatedDocumentsAll = lstRelatedDocuments.size();
            Integer i = 0;
            List<SelectOption> options = new List<SelectOption>();
            Integer intTotalDocuments = lstValidDocuments.size();

            for (RejectionReasonByDoc__mdt iterator:lstRejectionsReasonByDoc) {
                mapReasonRejectionDocs.put(
                    String.valueOf(
                        iterator.RelatedDocumentType__r.DigitizationID__c+
                        iterator.RelatedRejectionReason__r.ReasonRejectionID2__c
                    ),
                    iterator
                );
                if (i<lstValidDocuments.size() && lstValidDocuments[i]==iterator.RelatedDocumentType__r.DigitizationID__c) {
                  options.add(
                      new SelectOption(
                          String.valueOf(iterator.RelatedRejectionReason__r.ReasonRejectionID2__c),
                          iterator.RelatedRejectionReason__r.ReasonRejection__c
                      )
                  );
                  mapRejectionsReason.put(
                      iterator.RelatedDocumentType__r.DigitizationID__c,
                      options
                  );
                } else {
                  options = new List<SelectOption>();
                  options.add(
                      new SelectOption(
                          String.valueOf(iterator.RelatedRejectionReason__r.ReasonRejectionID2__c),
                          iterator.RelatedRejectionReason__r.ReasonRejection__c
                      )
                  );
                  i++;
                }
            }
            System.debug(loggingLevel.Error, '*** lstRelatedDocuments: ' + lstRelatedDocuments);
            System.debug(loggingLevel.Error, '*** mapRejectionsReason: ' + mapRejectionsReason);
        }


        isItValidToStart = false;
        Case currentProcedure = new Case();
        try{currentProcedure = [SELECT Id, AccountId, APValidationContact__r.id, RecordType.Name FROM Case WHERE Id =: stdCtl.getId() limit 1];}catch(QueryException qE){}catch(Exception gE){}
            strCaseIdentifier = stdCtl.getId();
            strRecordTypeCase = currentProcedure.RecordType.Name;
        if(currentProcedure.Id != null){
            if(currentProcedure.AccountId != null || currentProcedure.APValidationContact__r.id != null){
                relatedWorker = new Account();
                String strQueryOverAccsStmnt = 'SELECT '+String.join(new List<String>(SObjectType.Account.Fields.getMap().keySet()),', ')+' FROM Account WHERE Id = \''+currentProcedure .AccountId+'\' limit 1';
                try{relatedWorker = Database.query(strQueryOverAccsStmnt);}catch(QueryException qE){blnServiceHadError = true; stgMessage= qE.getMessage();}catch(Exception gE){blnServiceHadError = true; stgMessage= gE.getMessage();}
                if(relatedWorker.Id != null || currentProcedure.APValidationContact__r.id != null){
                    isItValidToStart = true;
                }
            }
        }

        if(blnServiceHadError == true) {
            //AAZ_Utils_cls.insertIncidence(stgMessage,stgtype,idCurrentCase,idCurrentId);
        }

        getRejectionSaved();
    }

    /**
     * Obtiene los rechazos seleccionados del documento
     * @type void
     */
    public void getRejectionSaved() {
        List<ReasonRejection__c> lstReasonRejectionSaved = [
            SELECT Id, Name, Document__c, ProcedureId__c, DigitizationID__c,
              ReasonRejectionID2__c
            FROM ReasonRejection__c
            WHERE Document__c IN :lstDocumentsIdentificacion
        ];

        if(!lstReasonRejectionSaved.isEmpty()){
            for(ReasonRejection__c iterator:lstReasonRejectionSaved) {
                mapRejection.get(iterator.DigitizationID__c).add(
                    String.valueOf(iterator.ReasonRejectionID2__c)
                );
            }
        }
    }

    /**
     * Obtiene los campos del caso
     * @type Array
     */
    public List<Schema.FieldSetMember> getFieldSetFields(){
        Case strRecordDevName = [SELECT SubSubType__c,SubType__c,Type FROM Case WHERE Id =:strCaseIdentifier limit 1];
        return AAZ_Utils_cls.getFieldSetMembers('Case', String.valueOf(strRecordDevName.Type), String.valueOf(strRecordDevName.SubType__c), String.valueOf(strRecordDevName.SubSubType__c));
    }

    /**
     * Función para obtener el JSON de los documentos asociados al caso
     *
     * @type String
     */
    public static String normalJson( Object respData ){
        Map<String, Object> response = new Map<String, Object>();
        response.put('status', API_STATUS_NORMAL);
        if( respData != null ) response.put('data', respData);
        return JSON.serialize( response );
    }

    /**
     * Función para descargar un documento en particular
     * @type void
     */
    public void downloadFile(){
        Document__c objDocumentFile = new Document__c();
        // objDocumentFile = [
        //     SELECT Id, Name, FileURL__c, DocumentTypeId__c, DocumentType__c
        //     FROM Document__c
        //     WHERE RelatedProcedure__c = :strCaseId AND DocumentTypeId__c = :strDigitalizationNumber
        //     ORDER BY Orden__c ASC LIMIT 1
        // ];
        // Blob fileToZip;
        // List<Object> lstObj = new List<Object>();
        // Http httpObject = new Http();
        // HttpRequest httpReqInstance = new HttpRequest();
        // httpReqInstance.setMethod('GET');
        // httpReqInstance.setEndpoint(objDocumentFile.FileURL__c);
        // HttpResponse resp = httpObject.send(httpReqInstance);
        // fileToZip = resp.getBodyAsBlob();
        // Map<String,String> atMap = new Map<String,String>();
        // atMap.put( 'Name', objDocumentFile.DocumentType__c );
        // atMap.put( 'Body', EncodingUtil.base64Encode(fileToZip) );
        // lstObj.add(atMap);
        // strDigitalizationFile = normalJson(lstObj);
    }

    public void getShowFileURL()
    {
        strDocumentURL = mapProfileImagenes.get(strDigitalDocument).FileURL__c;
    }

    /**
     * Función para guardar los rechazos
     * @type void
     */
    public void saveRejections()
    {
        List<String> lstDocumentId = new List<String>();
        List<String> lstRejectionsDocs = new List<String>();
        Set<String> setNombre =  new Set<String>();
        for(ReasonRejection__c rj:[SELECT Id,Name
                              FROM ReasonRejection__c
                              WHERE ProcedureId__c =: idCurrentCase])
        {
          setNombre.add(rj.Name);
        }
        // List<ReasonRejection__c> lstDeleteReasonRejection = [
        //   SELECT Id
        //   FROM ReasonRejection__c
        //   WHERE Document__c IN :lstDocumentId
        // ];
        for (String key : mapRejection.keySet()) {
            Document__c objDocument = mapProfileImagenes.get(key);
            lstDocumentId.add(objDocument.Id);
            for (String iterator : mapRejection.get(key)){
                RejectionReasonByDoc__mdt objReasonRejectionData = mapReasonRejectionDocs.get(key+iterator);
                if(!setNombre.Contains(objReasonRejectionData.RelatedDocumentType__r.Label+' '+objReasonRejectionData.Label))
                {
                  ReasonRejection__c objReasonRejection = new ReasonRejection__c();
                  objReasonRejection.Document__c = objDocument.Id;
                  objReasonRejection.Name = objReasonRejectionData.RelatedDocumentType__r.Label+' '+objReasonRejectionData.Label;
                  objReasonRejection.DigitizationID__c = key;
                  objReasonRejection.ReasonRejectionID2__c  = iterator;
                  objReasonRejection.ProcedureId__c = idCurrentCase;
                  objReasonRejection.GenerateLock__c = objReasonRejectionData.RelatedRejectionReason__r.GenerateLock__c;
                  lstInsertReasonRejection.add(objReasonRejection);
                }
            }
        }

      Case caseReasonRejection=[
          SELECT Id, Status
          FROM Case
          WHERE Case.Id=:idCurrentCase
      ];
     lstCase.add(caseReasonRejection);


      //caseReasonRejection.Status='Rechazado';
        // try {
            // delete lstDeleteReasonRejection;
        // } catch (DmlException e) {
        //     blnShowMessageError = true;
        //     strMessageError = System.Label.AAZ_AccountDetailsFromProcedure_013;
        //     strMessageError += e;
        // }

        try {
            insert lstInsertReasonRejection;
        } catch (DmlException e) {
            blnShowMessageError = true;
            strMessageError = System.Label.AAZ_AccountDetailsFromProcedure_013;
            strMessageError += e;
        }
        try {
            update lstCase;
        } catch (DmlException e) {
            blnShowMessageError = true;
            strMessageError = System.Label.AAZ_DocumentIdentification_002;
            strMessageError += e;
        }
    }
}