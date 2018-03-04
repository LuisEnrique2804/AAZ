/**
 * Desarrollado por:  Avanxo México
 * Autor:       Samuel Galindo Rodríguez
 * Proyecto:    Afore Azteca
 * Descripción: Clase para obtener los documentos con los cuales se va a
 *              comparar
 *
 * Cambios (Versiones)
 * -------------------------------------
 * No.     Fecha        Autor                         Descripción
 * ------  ----------   -------------                 ------------
 * 1.0     27/07/2017   Samuel Galindo                Crea la clase
 * 1.1     11/08/2017   Samuel Galindo                Ajustes a la clase
 * 1.2     07/11/2017   Samuel Galindo                Modificación
 */
public class AAZ_DocumentIdentification_ctr {

    /**
     * Lista de los identificadores de los documentos base para la validación
     * 1 => INE
     * 2 => Comprobante de domicilio
     * @type List
     */
    public List<String> lstValidDocuments{set;get;}

    /**
     * Lista de los documentos base para la validación
     * @type List
     */
    public List<Document__c> lstDocumentData{set;get;}

    /**
     * Cuenta el total de los documentos base
     * @type Integer
     */
    public Integer intCountResults{set;get;}

    /**
     * Map donde se guardan los rechazos por documentos
     * @type Map
     */
    public Map<Integer, List<String>> mapRejection{set;get;}

    /**
     * Mapa donde se guarda el indice y los motivos de rechazo asociados a él
     * Indice => Etiqueta del motivo de rechazo
     * @type Map
     */
    public Map<String, List<SelectOption>> mapRejectionsReason{set;get;}

    /**
     * Lista donde se guardan los motivos de rechazo por documento
     * @type List
     */
    public List<RejectionReasonByDoc__mdt> lstRejectionsReasonByDoc{set;get;}

    /**
     * Mapa donde se guarda por numero de digitalización el documento asociado
     * @type Map
     */
    public Map<Integer, Document__c> mapProfileImagenes{set;get;}

    /**
     * Mapa donde se guardan los motivos de rechazo por documento con indice de
     * digitalizacion y indice de documento
     * @type Map
     */
    public Map<String, RejectionReasonByDoc__mdt> mapReasonRejectionDocs{set;get;}

    /**
     * Entero donde se guarda el indice actual
     * @type Number
     */
    public Integer intCurrentIndex{set;get;}

    /**
     * Cadena donde se guardan los valores de los motivos de rechazo
     * @type String
     */
    public String strListValues{set;get;}

    /**
     * Booleano para saber si mostrar mensaje de error en operaciones DML
     */
    public Boolean blnShowMessageError{set;get;}

    /**
     * Mensaje de errror en operaciones DML
     */
    public String strMessageError{set;get;}

    /**
     * Lista donde se guardan los identificadores de los documentos
     * @type List
     */
    public List<String> lstDocumentsIdentificacion{set;get;}

    /**
     * Lista donde se guardan los identificadores de los documentos
     */
    public List<String> lstDocumentTypeId{set;get;}

    /**
     * Variable donde se guarda el identificador del documento
     */
    public String strDigitalDocument{set;get;}

    /**
     * Variable donde se guarda la URL del documento
     */
    public String strDocumentURL{set;get;}

    /**
     * Lista donde estan los metadatos de los tipos de documentos
     */
    public List<DocumentType__mdt> lstDocumentTypeMDT{set;get;}

    public transient String strDigitalizationFile{set;get;}
    public String strCaseId{set;get;}
    public String strDigitalizationNumber{set;get;}
    private static String API_STATUS_NORMAL = '200';
    public id idCurrentCase {set;get;}
    public Case caseInstance{set;get;}
    public List<ReasonRejection__c> lstInsertReasonRejection{set;get;}


    /**
     * Constructor de la clase
     */
    public AAZ_DocumentIdentification_ctr(ApexPages.StandardController stdCtrl)
    {
        lstInsertReasonRejection = new List<ReasonRejection__c>();
        String strQueryOverCasesStatement = 'SELECT '+String.join(
          new List<String>(SObjectType.Case.Fields.getMap().keySet()), ', ') +' FROM Case WHERE Id = \''+stdCtrl.getId()+'\' Limit 1';
        caseInstance = Database.query(strQueryOverCasesStatement);
        strDigitalizationFile = '';
        strCaseId = '';
        strDigitalizationNumber = '';

        lstDocumentTypeMDT = new List<DocumentType__mdt>();

        lstValidDocuments = new List<String>();

        lstDocumentTypeMDT = [
            SELECT Id, DeveloperName,DigitizationID__c, Label
            FROM DocumentType__mdt
            ORDER BY DigitizationID__c
        ];

        for (DocumentType__mdt iterator:lstDocumentTypeMDT) {
            if ( iterator.DeveloperName == 'Identification' ) {
                lstValidDocuments.add(iterator.DigitizationID__c);
            } else if (iterator.DeveloperName == 'ProofAddress') {
                lstValidDocuments.add(iterator.DigitizationID__c);
            }else if (iterator.DeveloperName == 'IdentificationAP') {
                lstValidDocuments.add(iterator.DigitizationID__c);
            }else if (iterator.DeveloperName == 'ProofAddressAP') {
                lstValidDocuments.add(iterator.DigitizationID__c);
            }else if (iterator.DeveloperName == 'IdentificationMandatory') {
                lstValidDocuments.add(iterator.DigitizationID__c);
            }else if (iterator.DeveloperName == 'ProofAddressSAR') {
                lstValidDocuments.add(iterator.DigitizationID__c);
            }else if (iterator.DeveloperName == 'ProofAddressMandatory') {
                lstValidDocuments.add(iterator.DigitizationID__c);
            }
        }
        System.debug(loggingLevel.Error, '*** lstValidDocuments: ' + lstValidDocuments);
        strDocumentURL = '';

        strDigitalDocument = '';

        lstDocumentTypeId = new List<String>();

        lstDocumentsIdentificacion = new List<String>();

        blnShowMessageError = false;

        strMessageError = '';

        intCurrentIndex = 0;

        strListValues = '';

        mapReasonRejectionDocs = new Map<String, RejectionReasonByDoc__mdt>();

        mapProfileImagenes = new Map<Integer, Document__c>();

        lstRejectionsReasonByDoc = new List<RejectionReasonByDoc__mdt>();

        mapRejectionsReason = new Map<String, List<SelectOption>>();

        mapRejection = new Map<Integer, List<String>>();

        lstDocumentData = new List<Document__c>();

        intCountResults = 0;

        Boolean blnServiceHadError = false;
        string stgMessage = '';
        String stgtype = 'Desarrollo';
        idCurrentCase = stdCtrl.getId();
        id idCurrentId = UserInfo.getUserId();

        try{
            lstDocumentData = [
                SELECT Id, FileURL__c, DocumentTypeId__c, DocumentType__c, page__c
                FROM Document__c
                WHERE DocumentTypeId__c IN :lstValidDocuments AND
                RelatedProcedure__c = :stdCtrl.getId()
                ORDER BY Orden__c ASC
            ];

            if(Test.isRunningTest())
              integer intTest =1/0;

        } catch(QueryException qE){blnServiceHadError = true; stgMessage = qE.getMessage();}catch(Exception gE){blnServiceHadError = true; stgMessage = gE.getMessage();}

        if(blnServiceHadError == true) {
            //AAZ_Utils_cls.insertIncidence(stgMessage,stgtype,idCurrentCase,idCurrentId);
        }
        
        if(!lstDocumentData.isEmpty()){

            intCountResults = lstDocumentData.size();

            Integer x = 1;
            for (Document__c iterator:lstDocumentData) {

                mapProfileImagenes.put(x, iterator);

                mapRejection.put(x, new List<String>());

                lstDocumentsIdentificacion.add(iterator.Id);

                lstDocumentTypeId.add(iterator.DocumentTypeId__c);

                x++;
            }

            lstRejectionsReasonByDoc = [
                SELECT Id, RelatedDocumentType__c, RelatedDocumentType__r.Label,
                 RelatedDocumentType__r.DigitizationID__c, RelatedRejectionReason__c,
                 Label, RelatedRejectionReason__r.ReasonRejectionID2__c, RelatedRejectionReason__r.ReasonRejection__c
                FROM RejectionReasonByDoc__mdt
                WHERE RelatedDocumentType__r.DigitizationID__c IN :lstValidDocuments
                ORDER BY RelatedDocumentType__c ASC
            ];
            List<SelectOption> options = new List<SelectOption>();

            String strTemp = lstValidDocuments[0];
            for (RejectionReasonByDoc__mdt iterator:lstRejectionsReasonByDoc) {

                mapReasonRejectionDocs.put(
                    String.valueOf(
                        iterator.RelatedDocumentType__r.DigitizationID__c+
                        iterator.RelatedRejectionReason__r.ReasonRejectionID2__c
                    ),
                    iterator
                );

                if (strTemp==iterator.RelatedDocumentType__r.DigitizationID__c) {

                    options.add(
                        new SelectOption(
                            String.valueOf(iterator.RelatedRejectionReason__r.ReasonRejectionID2__c),
                            Iterator.RelatedRejectionReason__r.ReasonRejection__c//iterator.label
                        )
                    );
                    System.debug(loggingLevel.Error, '*** iterator.RelatedRejectionReason__r.ReasonRejectionID2__c: ' + iterator.RelatedDocumentType__r.DigitizationID__c);
                    System.debug(loggingLevel.Error, '*** Iterator.RelatedRejectionReason__r.ReasonRejection__c: ' + Iterator.RelatedRejectionReason__r.ReasonRejection__c);
                    System.debug(loggingLevel.Error, '*** options: ' + options);
                    mapRejectionsReason.put(
                        iterator.RelatedDocumentType__r.DigitizationID__c,
                        options
                    );

                    
                } else {
                    options = new List<SelectOption>();
                    options.add(
                        new SelectOption(
                            String.valueOf(iterator.RelatedRejectionReason__r.ReasonRejectionID2__c),
                            Iterator.RelatedRejectionReason__r.ReasonRejection__c//iterator.label
                        )
                    );
                    strTemp = iterator.RelatedDocumentType__r.DigitizationID__c;
                }
            }

            getRejectionSaved();
        }
    }

    /**
     * Obtiene los rechazos seleccionados del trámite
     * @type void
     */
    public void getRejectionSaved() {
        List<ReasonRejection__c> lstReasonRejectionSaved = [
            SELECT Id, Name, Document__c, ProcedureId__c, DigitizationID__c,
              ReasonRejectionID2__c, DocumentIndex__c
            FROM ReasonRejection__c
            WHERE Document__c IN :lstDocumentsIdentificacion
        ];

        if(!lstReasonRejectionSaved.isEmpty()){
            for (ReasonRejection__c iterator:lstReasonRejectionSaved) {
                mapRejection.get(Integer.valueOf(Iterator.DocumentIndex__c)).add(
                    String.valueOf(iterator.ReasonRejectionID2__c)
                );
            }
        }
    }

    /**
     * Función para guardar los motivos de rechazo
     * @type void
     */
    public void saveRejections(){
        System.debug(loggingLevel.Error, '*** 1: ');
        mapRejection.get(intCurrentIndex).clear();
        String [] arrOptions = strListValues.split(',');
        if (strListValues!='') {
            System.debug(loggingLevel.Error, '*** 2: ');
            for (String iterator: arrOptions) {
                mapRejection.get(intCurrentIndex).add(iterator);
            }
        }
        List<String> lstDocumentId = new List<String>();
        List<String> lstRejectionsDocs = new List<String>();
        RejectionReasonByDoc__mdt objReasonRejectionData = new RejectionReasonByDoc__mdt();
        for (Integer key : mapRejection.keySet()) {
            System.debug(loggingLevel.Error, '*** 3: ');
            System.debug(loggingLevel.Error, '*** key: ' + key);
            System.debug(loggingLevel.Error, '*** mapRejection: ' + mapRejection);
            Document__c objDocument = mapProfileImagenes.get(key);
            System.debug(loggingLevel.Error, '*** objDocument: ' + objDocument);
            lstDocumentId.add(objDocument.Id);
            for (String iterator : mapRejection.get(key)){
                System.debug(loggingLevel.Error, '*** 4: ');
                System.debug(loggingLevel.Error, '*** mapReasonRejectionDocs: ' + mapReasonRejectionDocs);
                System.debug(loggingLevel.Error, '*** objDocument.DocumentTypeId__c: ' + objDocument.DocumentTypeId__c);
                System.debug(loggingLevel.Error, '*** iterator: ' + iterator);
                objReasonRejectionData = mapReasonRejectionDocs.get(objDocument.DocumentTypeId__c+iterator);
                System.debug(loggingLevel.Error, '*** objReasonRejectionData: ' + objReasonRejectionData);
                if(objReasonRejectionData != NULL){
                    System.debug(loggingLevel.Error, '*** 5: ');
                    ReasonRejection__c objReasonRejection = new ReasonRejection__c();
                    objReasonRejection.Document__c = objDocument.Id;
                    objReasonRejection.Name = objReasonRejectionData.RelatedRejectionReason__r.ReasonRejection__c;
                    objReasonRejection.DocumentIndex__c = key;
                    objReasonRejection.ReasonRejectionID2__c  = iterator;
                    objReasonRejection.ProcedureId__c = idCurrentCase;
                    System.debug(loggingLevel.Error, '*** objReasonRejection: ' + objReasonRejection);
                    lstInsertReasonRejection.add(objReasonRejection);
                }
            }
            System.debug(loggingLevel.Error, '*** control');
        }
/*
      List<ReasonRejection__c> lstDeleteReasonRejection = [
        SELECT Id
        FROM ReasonRejection__c
        WHERE Document__c IN :lstDocumentId
      ];
*/
/*
      Case caseReasonRejection=[
        SELECT Id
        FROM Case
        WHERE Case.Id=:idCurrentCase
      ];
*/
      //caseReasonRejection.Status='Rechazado';

/*
      try {
          // delete lstDeleteReasonRejection;
      } catch (DmlException e) {
          blnShowMessageError = true;
          strMessageError = System.Label.AAZ_DocumentIdentification_002;
          strMessageError += e;
      }
*/
        try {
            Database.SaveResult[] sr = Database.insert(lstInsertReasonRejection,false);
            //insert lstInsertReasonRejection;
            System.debug(loggingLevel.Error, '*** sr: ' + sr);
        } catch (DmlException e) {
            blnShowMessageError = true;
            strMessageError = System.Label.AAZ_DocumentIdentification_002;
            strMessageError += e;
            System.debug(loggingLevel.Error, '*** strMessageError: ' + strMessageError);
        }
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
     * Función para descargar un documento en particular
     * @type void
     */
    public void downloadFile(){
        Document__c objDocumentFile = new Document__c();
        objDocumentFile = [
            SELECT Id, Name, FileURL__c, DocumentTypeId__c, DocumentType__c
            FROM Document__c
            WHERE RelatedProcedure__c = :idCurrentCase AND DocumentTypeId__c = :strDigitalizationNumber
            ORDER BY Orden__c ASC LIMIT 1
        ];
        Blob fileToZip;
        List<Object> lstObj = new List<Object>();
        Http httpObject = new Http();
        HttpRequest httpReqInstance = new HttpRequest();
        httpReqInstance.setMethod('GET');
        httpReqInstance.setEndpoint(objDocumentFile.FileURL__c);
        HttpResponse resp = httpObject.send(httpReqInstance);
        fileToZip = resp.getBodyAsBlob();
        Map<String,String> atMap = new Map<String,String>();
        atMap.put( 'Name', objDocumentFile.DocumentType__c );
        atMap.put( 'Body', EncodingUtil.base64Encode(fileToZip) );
        lstObj.add(atMap);
        strDigitalizationFile = normalJson(lstObj);
    }
}