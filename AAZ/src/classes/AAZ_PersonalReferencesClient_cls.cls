/*******************************************************************************
Desarrollado por: Avanxo México
Autor: Daniel Peñaloza
Proyecto: Banco Azteca - Afore
Descripción: Clase con métodos a consumir Web Service de Consulta de Referencias Personales

------ ---------- -------------------------- -----------------------------------
No.    Fecha      Autor                      Descripción
------ ---------- -------------------------- -----------------------------------
1.0    14/08/2017 Daniel Peñaloza            Clase creada
*******************************************************************************/

public with sharing class AAZ_PersonalReferencesClient_cls {

    /**
     * Método para obtener de forma asíncrona los documentos relacionados a un Caso.
     * @param lstCaseIds Lista de Ids de Caso
     */
    @InvocableMethod(label='Get Personal References Async' description='Get Case related Personal References from webservice and insert them into Salesforce.')
    public static void getPersonalReferencesAsync(List<Id> lstCaseIds) {
        List<Case> lstCases = [
            SELECT
                Id, CaseNumber, FolioNSS__c,    // Case
                Account.NSS__c, Account.RFC__c, // Account
                Contact.EmployeeNumber__c       // Contact
            FROM Case
            WHERE Id IN :lstCaseIds
        ];

        for (Case objCase: lstCases) {
            // Invocar consulta de documentos para cada Caso
            GetPersonalReferencesAsync getPersonalReferencesAsync = new GetPersonalReferencesAsync();
            getPersonalReferencesAsync.objCase = objCase;
            Id jobId = System.enqueueJob(getPersonalReferencesAsync);
        }
    }

    /**
     * Clase para ejecutar llamado al servicio de consulta de Documentos del Caso manera asíncrona.
     */
    public class GetPersonalReferencesAsync implements Queueable, Database.AllowsCallouts {
        public Case objCase { get; set; }

        // Ejecutar llamado a servicio de consulta de Documentos para el Caso
        public void execute(QueueableContext context) {
            List<SObject> lstRequestObjects = new SObject[]{ objCase, objCase.Account, objCase.Contact };
            Map<String, Object> mapExtraAttrs = new Map<String, Object>();

            try {
                List<People__c> lstPersonalReferences = AAZ_Afore_QueryReference_cls.getReferenceList(lstRequestObjects, mapExtraAttrs);

                for (People__c doc: lstPersonalReferences) {
                    doc.ParentIdReference__c = objCase.Id;
                }

                insert lstPersonalReferences;
            } catch (Exception ex) {
                // Registrar incidencia
                AAZ_Utils_cls.insertIncidence(ex.getMessage(), 'Web Service', objCase.Id, UserInfo.getUserId());
            }
        }
    }

}