/****************************************************************************************************
Información general
-------------------
author: Samuel Galindo
email: sgalindo@avanxo.com
company: Avanxo México
Project: Afore
Customer: Banco AZTECA

Description:
Clase de pruebas de los metodos en la clases AAZ_Afore_QueryReference_cls
Information about changes (versions)
================================================================================================
Number    Dates           Author                       Description
------    --------        --------------------------   -----------------------------------------
1.2       08-Nov-2017     Samuel Galindo              Modificación
****************************************************************************************************/

@isTest private class AAZ_Afore_QueryReference_tst {
    @testSetup
    static void setup() {
        // Crear configuración global de la app
        //AppMainSetting_cs__c mainSettings = Test.isRunningTest()?
        //AAZ_TestUtils_tst.getMainSettings() : AppMainSetting_cs__c.getOrgDefaults();
        // Configuración para métodos de prueba

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

        Case cas = new Case(
            Subject = 'Prueba',
            employeeNumber__c='teste'
        );
        insert cas;
    }

    @isTest static void testShouldGetCaseDocuments() {

        User usr = [SELECT Id FROM User LIMIT 1];
        Case caso = [SELECT Id, employeeNumber__c, idServiceType__c, caseNumber, Account.NSS__c, FolioNSS__c FROM Case LIMIT 1];

        // Get endpoints for services
        EndpointSetting__mdt tokenEndpoint = AAZ_Utils_cls.getEndpointSetting('Afore_Authorization');
        String strTokenEndpoint = AAZ_GenericCallout_cls.getEndpoint(tokenEndpoint);

        EndpointSetting__mdt referencesEndpoint = AAZ_Utils_cls.getEndpointSetting('Afore_QueryReference');
        String strReferencesEndpoint = AAZ_GenericCallout_cls.getEndpoint(referencesEndpoint);

        // Create response mocks
        SingleRequestMock tokenMock = new SingleRequestMock('{"signToken":{"signedToken":"ZWQzNzUyZTg5MDk4MzE0YTA1OTY4ZGU0YWI4MjljMzFhYmU5MDNkOTA0NzIzYTlhOGNmNGJhNTAwYjE5YzYwNg==","expiration":"2017-04-26 13:24:19"}}');
        SingleRequestMock referencesMock = new SingleRequestMock('{"Out_ConsultaReferencias":{"employedServiceRs":{"isSucessful":"true","references":{"reference":[{"nameReferences":"test","fatherLastNameReference":"test","motherLastNameReference":"test","curpReference":"test","stateBirthReference":"test","birthDateReference":"2017-09-22-05:00","genderReference":"test","phoneRefernce":1111111111,"typePhoneReference":"test"}]}}}}');

        // Save response mocks in a MultiRequestMock instance
        MultiRequestMock multiRequestMock = new MultiRequestMock();
        multiRequestMock.addRequestMock(strTokenEndpoint, tokenMock);
        multiRequestMock.addRequestMock(strReferencesEndpoint, referencesMock);

        Test.setMock(HttpCalloutMock.class, multiRequestMock);

        Test.startTest();
            AAZ_Afore_QueryReference_cls.getReferenceList(new SObject[]{ caso }, null);
        Test.stopTest();

        // Documentos del Caso
        People__c[] lstCaseDocuments = new List< People__c>([ SELECT  isUpdateData__c,  Name__c  ,  FatherLastName__c ,  MaternalLastName__c,  CURP__c,
        BirthState__c, BirthDate__c , Gender__c ,Phone__c , PhoneType__c
        FROM People__c ]);
    }
}