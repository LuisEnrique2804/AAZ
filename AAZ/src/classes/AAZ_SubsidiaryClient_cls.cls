/*******************************************************************************
Desarrollado por: Avanxo México
Autor: Daniel Peñaloza
Proyecto: Banco Azteca - Afore
Descripción: Clase con métodos a consumir Web Service de Consulta de Sucursal

------ ---------- -------------------------- -----------------------------------
No.    Fecha      Autor                      Descripción
------ ---------- -------------------------- -----------------------------------
1.0    14/08/2017 Daniel Peñaloza            Clase creada
1.2    08/11/2017 Samuel Galindo             Se comenta ya que hay un process builder
*******************************************************************************/

public with sharing class AAZ_SubsidiaryClient_cls {

    /**
     * Método para llamar de forma asíncrona el servicio de consulta de Sucursal.
     * @param lstCaseIds Lista de Ids de Caso
     */
    @InvocableMethod(label='Get Subsidiary Async' description='Get Case Subsidiary from webservice and update Case.')
    public static void getSubsidiaryAsync(List<Id> lstCaseIds) {
/*
        List<Case> lstCases = [
            SELECT
                Id, CaseNumber, FolioNSS__c,    // Case
                Account.NSS__c, Account.RFC__c, // Account
                Contact.EmployeeNumber__c, Contact.SucursalNumber__c       // Contact
            FROM Case
            WHERE Id IN :lstCaseIds
        ];

        for (Case objCase: lstCases) {
            // Invocar consulta de documentos para cada Caso
            GetSubsidiaryAsync getSubsidiaryAsync = new GetSubsidiaryAsync();
            getSubsidiaryAsync.objCase = objCase;
            Id jobId = System.enqueueJob(getSubsidiaryAsync);
        }
*/
    }

    /**
     * Clase para ejecutar llamado al servicio de consulta de Documentos del Caso manera asíncrona.
     */
/*
    public class GetSubsidiaryAsync implements Queueable, Database.AllowsCallouts {
        public Case objCase { get; set; }

        // Ejecutar llamado a servicio de consulta de Documentos para el Caso
        public void execute(QueueableContext context) {
            List<SObject> lstRequestObjects = new SObject[]{ objCase, objCase.Account, objCase.Contact };
            Map<String, Object> mapExtraAttrs = new Map<String, Object>();

            try {
                Case caseResult = AAZ_SubsidiaryQuery_cls.getSubsidiaryList(lstRequestObjects, mapExtraAttrs);

                caseResult.Id = objCase.Id;

                //update caseResult;
            } catch (Exception ex) {
                // Registrar incidencia
                AAZ_Utils_cls.insertIncidence(ex.getMessage(), 'Web Service', objCase.Id, UserInfo.getUserId());
            }
        }
    }
*/
}