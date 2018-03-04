/*******************************************************************************
Desarrollado por: Avanxo México
Autor: Iván Neria
Proyecto: Afore Azteca
Descripción: Clase de prueba para el servicio web AAZ_DocumentQueryWS_cls (WS007)

------ ---------- -------------------------- -----------------------------------
No.    Fecha      Autor                      Descripción
------ ---------- -------------------------- -----------------------------------
1.0    29/09/2017 Iván Neria           Clase creada
1.1	   2/10/2017  Iván Neria		   Clase finalizada cobertura 100%
*******************************************************************************/
@isTest public class AAZ_DocumentQueryWS_tst  {
    @testSetup static void AAZ_DocumentQueryWS(){

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
        Contact contactInstance = new Contact(
					LastName = 'LastName',
					employeeNumber__c = '1234567',
            		NSS__c = '83856405523'
					);
			insert contactInstance;

        Account account1 = new Account(
            CURP__c = 'DIRA640508HTCZDN00',
            FirstName = 'JOSE ANGEL',
            LastName = 'DIAZ RODRIGUEZ',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cuenta personal').getRecordTypeId(),
            NSS__c = '83856405523'
        );
        insert account1;

        Case cas = new Case(
            Subject = 'Prueba',
            employeeNumber__c='teste',
            AccountId = account1.Id,
            ContactId = contactInstance.Id,
            APValidationContact__c= contactInstance.Id
        );
        insert cas;
    }
        @isTest
    static void should_get_case_documents() {

        User usr = [SELECT Id FROM User LIMIT 1];
        Case caso = [SELECT Id, employeeNumber__c, idServiceType__c, caseNumber, APValidationContact__c, Contact.NSS__c, Contact.Id, Account.NSS__c, FolioNSS__c FROM Case LIMIT 1];

        // Get endpoints for services
        EndpointSetting__mdt tokenEndpoint = AAZ_Utils_cls.getEndpointSetting('Afore_Authorization');
        String strTokenEndpoint = AAZ_GenericCallout_cls.getEndpoint(tokenEndpoint);
         EndpointSetting__mdt referencesEndpoint = AAZ_Utils_cls.getEndpointSetting('Afore_QueryDocument');
        String strReferencesEndpoint = AAZ_GenericCallout_cls.getEndpoint(referencesEndpoint);

        // Create response mocks
        SingleRequestMock tokenMock = new SingleRequestMock('{"signToken":{"signedToken":"ZWQzNzUyZTg5MDk4MzE0YTA1OTY4ZGU0YWI4MjljMzFhYmU5MDNkOTA0NzIzYTlhOGNmNGJhNTAwYjE5YzYwNg==","expiration":"2017-04-26 13:24:19"}}');
        SingleRequestMock referencesMock = new SingleRequestMock('{"Out_ConsultaDocumentos":{"docServiceRs":{"docsDigitalizados":[{"orden":"1","ruta":"https://0.0.0.0/something","digitalNumber":"digitalNumber","idDoctoTienda":"678","page":"1"}]}}}');

        // Save response mocks in a MultiRequestMock instance
        MultiRequestMock multiRequestMock = new MultiRequestMock();
        multiRequestMock.addRequestMock(strTokenEndpoint, tokenMock);
        multiRequestMock.addRequestMock(strReferencesEndpoint, referencesMock);

        Test.setMock(HttpCalloutMock.class, multiRequestMock);

        Test.startTest();
        	AAZ_DocumentQueryWS_cls.getDocList(new SObject[]{ caso }, new Map<String, Object>());
        Test.stopTest();
       }
}