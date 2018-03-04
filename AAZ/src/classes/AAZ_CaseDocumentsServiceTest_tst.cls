/*******************************************************************************
Desarrollado por: Avanxo México
Autor: Daniel Peñaloza
Proyecto: Banco Azteca - Afore
Descripción: Clase de prueba para servicio de consulta de documentos

------ ---------- -------------------------- -----------------------------------
No.    Fecha      Autor                      Descripción
------ ---------- -------------------------- -----------------------------------
1.0    02/08/2017 Daniel Peñaloza            Clase creada
*******************************************************************************/

@isTest
private class AAZ_CaseDocumentsServiceTest_tst {
    /*

    @testSetup
    static void setup() {
        // Crear configuración global de la app
        AppMainSetting_cs__c mainSettings = AAZ_TestUtils_tst.getMainSettings();
        insert mainSettings;
        // Configuración para métodos de prueba
        User usr = AAZ_TestUtils_tst.createUser();
        insert usr;
    }

    @isTest
    static void should_get_case_documents() {
        User usr = [SELECT Id FROM User LIMIT 1];
        Case cas = new Case(
            Subject = 'Prueba'
        );

        Test.startTest();
            // TODO: Asignar TestMock

            System.runAs(usr) {
                insert cas;
            }
        Test.stopTest();

        // Documentos del Caso
        Document__c[] lstCaseDocuments = new List<Document__c>([
            SELECT Id, Orden__c, FileURL__c, page__c, DocumentTypeId__c
            FROM Document__c
        ]);
        System.assert(!lstCaseDocuments.isEmpty());
        System.assertEquals(7, lstCaseDocuments[0].Orden__c);
        System.assertEquals('http://www.segurosazteca.com.mx/segurosAzteca/imagenes/estructura/logo.gif', lstCaseDocuments[0].FileURL__c);
        System.assertEquals(7, lstCaseDocuments[0].page__c);
        System.assertEquals('001', lstCaseDocuments[0].DocumentTypeId__c);
    }

    @isTest
    static void should_insert_incidence() {
        User usr = [SELECT Id FROM User LIMIT 1];
        Case cas = new Case(
            Subject = 'Prueba'
        );
        insert cas;

        AAZ_CaseDocumentsClient_cls.GetCaseDocumentsAsync caseDocumentsAsync = new AAZ_CaseDocumentsClient_cls.GetCaseDocumentsAsync();
        caseDocumentsAsync.objCase = cas;

        Test.startTest();
            // TODO: Asignar TestMock

            System.runAs(usr) {
                caseDocumentsAsync.registerIncidence(new AAZ_WebServiceException('Error de Prueba'));
            }
        Test.stopTest();
    }
*/
}