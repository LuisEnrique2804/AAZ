/*******************************************************************************
Desarrollado por: Avanxo México
Autor: Daniel Peñaloza
Proyecto: Banco Azteca - Afore
Descripción: Clase de prueba para servicio de consulta de Agente Promotor

------ ---------- -------------------------- -----------------------------------
No.    Fecha      Autor                      Descripción
------ ---------- -------------------------- -----------------------------------
1.0    11/08/2017 Daniel Peñaloza            Clase creada
*******************************************************************************/

@isTest
private class AAZ_PromoterAgentServiceTest_tst {

    @testSetup
    static void setup() {
        // Crear configuración global de la app
        //AppMainSetting_cs__c mainSettings = AAZ_TestUtils_tst.getMainSettings();
        //insert mainSettings;
        // Configuración para métodos de prueba
        //User usr = AAZ_TestUtils_tst.createUser();
        
          String  profileName = Label.AAZ_AdministratorProfile; // Colocar en Etiqueta Personalizada 
          String   username = Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '@test.com';
          String   password = Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000);


        Profile p = [ SELECT Id FROM Profile WHERE Name=:profileName ];

        User usr = new User(
            Alias             = username.substringAfterLast('@'),
            Email             = username,
            EmailEncodingKey  = 'UTF-8',
            LastName          = username,
            LanguageLocaleKey = 'es_MX',
            LocaleSidKey      = 'es_MX',
            ProfileId         = p.Id,
            TimeZoneSidKey    = 'America/Mexico_City',
            UserName          = username

        );

        insert usr;
    }
/*
    @isTest
    static void should_get_promoter_agent() {
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
        Contact con = [
            SELECT Id
            FROM Contact
        ];
        cas = [
            SELECT Id, ContactId
            FROM Case
            WHERE ContactId = :con.Id AND Subject = 'Prueba'
        ];
        System.assert(con != null);
        System.assert(cas != null);
        System.assertEquals(cas.ContactId, con.Id);
    }
*/
}