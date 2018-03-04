/**
 * Desarrollado por:  Avanxo México
 * Autor:       Samuel Galindo Rodríguez
 * Proyecto:    Afore Azteca
 * Descripción: Clase para obtener los documentos con los cuales se va a validar
 * el trámite. Al dar click en el nombre del documento se muestra en la visualforce
 * principal. Tambien se pueden descargar los documentos.
 *
 * Cambios (Versiones)
 * ---------------------------------------------------------------
 * No.     Fecha        Autor                         Descripción
 * ---------------------------------------------------------------
 * 1.0     27/07/2017   Samuel Galindo Rodríguez      Crea la clase
 * 1.1     10/08/2017   Samuel Galindo                Ajustes
 * 2.0     15/10/2017   Daniel Peñaloza               Refactorización y ajustes para visualización de documentos
 *
 */
public class AAZ_DocumentList_ctr
{
    public String strCaseId { set; get; }
    public Case caseInstance { set; get; }
    private static String API_STATUS_NORMAL = '200';
    public String strDigitalizationFile { get; set; }
    public List<Document__c> lstRelatedDocuments { set; get; }
    public List<String> lstValidDocuments { set; get; }
    public RequiredDocument__mdt[] lstRequiredDocuments { get; private set; }
    public map<String, DocumentType__mdt> mapDoctypes { get; set; }
    public map<String, Document__c[]> mapDocuments {get; set;}

    /**
     * Constructor
     * @param  stdCtrl Controlador estándar de caso
     */
    public AAZ_DocumentList_ctr(ApexPages.StandardController stdCtrl)
    {
        strCaseId = stdCtrl.getId();
        initCaseInstance(strCaseId);
        lstValidDocuments = new String[]{};
        mapDocuments = new Map<String, Document__c[]>();

        lstRequiredDocuments = [
            SELECT Id, DeveloperName,
            	// Tipos de Documento
            	RelatedDocumentType__r.Id, RelatedDocumentType__r.DeveloperName, RelatedDocumentType__r.DigitizationID__c, RelatedDocumentType__r.Label
            FROM RequiredDocument__mdt
            WHERE RelatedProcedure__r.ServiceType__c = :caseInstance.Type
            	AND RelatedProcedure__r.SubType__c = :caseInstance.SubType__c
            //ORDER BY RelatedDocumentType__r.ListOrder__c
        ];

        Set<String> setValidDocuments = new Set<String> {
            'Identification',
            'ProofAddress',
            'PictureWorker',
            'WorkerSignature',
            'APSignature'
        };

        for (RequiredDocument__mdt docType: lstRequiredDocuments) {
            if (setValidDocuments.contains(docType.RelatedDocumentType__r.DeveloperName)) {
                lstValidDocuments.add(docType.RelatedDocumentType__r.DigitizationID__c);
            }
        }

        // Mapa de tipos de documento para obtener descripciones
        mapDoctypes = new Map<String, DocumentType__mdt>();
        for (RequiredDocument__mdt docType : lstRequiredDocuments) {
            mapDoctypes.put(docType.RelatedDocumentType__r.DigitizationID__c, docType.RelatedDocumentType__r);
        }

        // Lista de documentos relacionados al Caso
        lstRelatedDocuments = [
            SELECT Id, Name, FileURL__c, DocumentTypeId__c, DocumentType__c, DocName__c, page__c, Orden__c
            FROM Document__c
            WHERE RelatedProcedure__c = :strCaseId
                AND DocumentTypeId__c IN :mapDocTypes.keySet()
            	//AND DocumentTypeId__c NOT IN :lstValidDocuments
            ORDER BY DocumentTypeId__c, page__c
        ];
        System.debug(loggingLevel.Error, '*** lstRelatedDocuments: ' + lstRelatedDocuments);
        // Llenar mapa de documentos relacionados agrupados por páginas
        for (Document__c doc: lstRelatedDocuments) {
            String docTypeId = doc.DocumentTypeId__c;

            if (!mapDocuments.containsKey(docTypeId)) {
                mapDocuments.put(docTypeId, new List<Document__c>());
            }
            mapDocuments.get(docTypeId).add(doc);
        }
    }

    /**
     * Inicializar Caso
     * @param caseId Id del Caso
     */
    public void initCaseInstance(String caseId)
    {
        String strCaseQuery = 'SELECT '+String.join(
          new List<String>(SObjectType.Case.Fields.getMap().keySet()), ', ') +
          ' FROM Case WHERE Id = \'' + caseId + '\'';
        caseInstance = Database.query(strCaseQuery);
    }

    /**
     * Descargar un Documento
     */
    public void downloadFile()
    {
        String strDocTypeId = ApexPages.currentPage().getParameters().get('strDocTypeId');
        String strPageNumber = ApexPages.currentPage().getParameters().get('strPageNumber');

        Document__c objDocumentFile = new Document__c();
        objDocumentFile = [
            SELECT Id, Name, FileURL__c, DocumentTypeId__c
            FROM Document__c
            WHERE RelatedProcedure__c = :strCaseId
                AND DocumentTypeId__c = :strDocTypeId
                AND page__c = :Decimal.valueOf(strPageNumber)
            LIMIT 1
        ];

        // Descarga de documento usando una petición HTTP
        Http httoClient = new Http();
        HttpRequest httpReqInstance = new HttpRequest();
        httpReqInstance.setMethod('GET');
        httpReqInstance.setEndpoint(objDocumentFile.FileURL__c);

        Blob fileToZip;
        HttpResponse resp = httoClient.send(httpReqInstance);
        fileToZip = resp.getBodyAsBlob();

        Map<String,String> mapResponse = new Map<String,String>();
        mapResponse.put('Name', mapDoctypes.get(objDocumentFile.DocumentTypeId__c) + ' - ' + strPageNumber);
        mapResponse.put('Body', EncodingUtil.base64Encode(fileToZip));

        List<Object> lstObjects = new List<Object>();
        lstObjects.add(mapResponse);
        strDigitalizationFile = normalJson(lstObjects);
    }

    /**
     * Convertir objeto a JSON (Se utiliza en la descarga de documentos)
     * @param  respData Objeto a serializar
     * @return          Respuesta serializada en JSON
     */
    public static String normalJson(Object respData)
    {
        Map<String, Object> response = new Map<String, Object>();
        response.put('status', API_STATUS_NORMAL);
        if(respData != null) {
            response.put('data', respData);
        }

        return JSON.serialize(response);
    }
}