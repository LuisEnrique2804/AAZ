/*******************************************************************************
Desarrollado por: Avanxo México
Autor: Daniel Peñaloza
Proyecto: Banco Azteca - Afore
Descripción: Clase con métodos a consumir Web Service de Consulta de Beneficiarios

------ ---------- -------------------------- -----------------------------------
No.    Fecha      Autor                      Descripción
------ ---------- -------------------------- -----------------------------------
1.0    14/08/2017 Daniel Peñaloza            Clase creada
*******************************************************************************/

public with sharing class AAZ_BeneficiariesClient_cls {
    
    // Cargar los mainsettings para las clases de prueba
    public static AppMainSetting_cs__c mainSettings = Test.isRunningTest()?
        AAZ_TestUtils_tst.getMainSettings() : AppMainSetting_cs__c.getOrgDefaults();

    /**
     * Método para obtener de forma asíncrona los documentos relacionados a un Caso.
     * @param lstCaseIds Lista de Ids de Caso
     */
    @InvocableMethod(label='Get Beneficiaries Async' description='Get Case related beneficiaries from webservice and insert them into Salesforce.')
    public static void getBeneficiariesAsync(List<Id> lstCaseIds) {
        List<Case> lstCases = [
            SELECT
                Id, CaseNumber, FolioNSS__c,idServiceType__c ,   // Case
                Account.NSS__c, Account.RFC__c, // Account
                Contact.EmployeeNumber__c       // Contact
            FROM Case
            WHERE Id IN :lstCaseIds
        ];

        for (Case objCase: lstCases) {
            // Invocar consulta de documentos para cada Caso
            GetBeneficiariesAsync getBeneficiariesAsync = new GetBeneficiariesAsync();
            getBeneficiariesAsync.objCase = objCase;
            Id jobId = System.enqueueJob(getBeneficiariesAsync);
        }
    }

    /**
     * Clase para ejecutar llamado al servicio de consulta de Documentos del Caso manera asíncrona.
     */
    public class GetBeneficiariesAsync implements Queueable, Database.AllowsCallouts {
        public Case objCase { get; set; }

        // Ejecutar llamado a servicio de consulta de Documentos para el Caso
        public void execute(QueueableContext context) {
            List<SObject> lstRequestObjects = new SObject[]{ objCase, objCase.Account, objCase.Contact };
            Map<String, Object> mapExtraAttrs = new Map<String, Object>();

            try {
                List<People__c> lstBeneficiaries = AAZ_BeneficiaryQuery_cls.getBeneficiaryList(lstRequestObjects, mapExtraAttrs);

                for (People__c doc: lstBeneficiaries) {
                    doc.ParentIdBeneficiary__c = objCase.Id;
                }

                insert lstBeneficiaries;
            } catch (Exception ex) {
                // Registrar incidencia
                AAZ_Utils_cls.insertIncidence(ex.getMessage(), 'Web Service', objCase.Id, UserInfo.getUserId());
            }
        }
    }

}