/*******************************************************************************
Desarrollado por: Avanxo México
Autor: Daniel Peñaloza
Proyecto: Banco Azteca - Afore
Descripción: Clase con métodos a consumir referentes a servicio de Agente Promotor

------ ---------- -------------------------- -----------------------------------
No.    Fecha      Autor                      Descripción
------ ---------- -------------------------- -----------------------------------
1.0    03/08/2017 Daniel Peñaloza            Clase creada
*******************************************************************************/

public with sharing class AAZ_PromoterAgentClient_cls {
    
    // Cargar los mainsettings para las clases de prueba
    public static AppMainSetting_cs__c mainSettings = Test.isRunningTest()?
        AAZ_TestUtils_tst.getMainSettings() : AppMainSetting_cs__c.getOrgDefaults();

    /**
     * Método para obtener de forma asíncrona la información de agente promotor.
     * @param lstCaseIds Lista de Ids de Caso
     */
    @InvocableMethod(label='Get Promoter Agent Async' description='Get Promoter Agent information and relate it to Case.')
    public static void getPromoterAgentAsync(List<Id> lstCaseIds) {
        List<Case> lstCases = [
            SELECT
                Id, CaseNumber, FolioNSS__c,    // Case
                Account.NSS__c, Account.RFC__c, // Account
                Contact.EmployeeNumber__c, Contact.ShopNumber__c,        // Contact
                idServiceType__c, employeeNumber__c
            FROM Case
            WHERE Id IN :lstCaseIds
        ];
System.debug('Primer query *** lstCases '+ lstCases);
        for (Case objCase: lstCases) {
            // Invocar consulta de Agente Promotor para cada Caso
            GetPromoterAgentAsync promoterAgentAsync = new GetPromoterAgentAsync();
            promoterAgentAsync.objCase = objCase;
            Id promoterJobId = System.enqueueJob(promoterAgentAsync);
        }
    }

    /**
     * Clase para ejecutar llamado al servicio de consulta de Agente Promotor de manera asíncrona.
     */
    public class GetPromoterAgentAsync implements Queueable, Database.AllowsCallouts {
        public Case objCase { get; set; }

        // Ejecutar llamado a servicio de consulta de Agente Promotor
        public void execute(QueueableContext context) {
            List<SObject> lstRequestObjects = new SObject[]{ objCase, objCase.Account, objCase.Contact };
            Map<String, Object> mapExtraAttrs = new Map<String, Object>();
System.debug('Segundo query *** lstRequestObjects '+ lstRequestObjects);
            try {
                Contact objAgent = AAZ_AgentQuery_cls.getLockUnlockAPList(lstRequestObjects, mapExtraAttrs);
System.debug('Tercer query *** objAgent '+ objAgent + 'Y el segundo valor es '+ Contact.EmployeeNumber__c);
                // Hacer upsert usando número de empleado
                Database.UpsertResult ur = Database.upsert(objAgent, Contact.EmployeeNumber__c);

                System.debug(loggingLevel.Error, '*** ur: ' + ur);

                if (ur.isSuccess()) {
                    objCase.ContactId = ur.getId();
                    update objCase;
                } else {
                    throw new AAZ_WebServiceException(ur.getErrors()[0].getMessage());
                }
            } catch (Exception ex) {
                AAZ_Utils_cls.insertIncidence(ex.getMessage(), 'Web Service', objCase.Id, UserInfo.getUserId());
            }
        }
    }
}