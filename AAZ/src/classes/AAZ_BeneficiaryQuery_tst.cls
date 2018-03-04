/*******************************************************************************
Desarrollado por: Avanxo México
Autor: Rodrigo Francis da Silva
Proyecto:  Afore
Descripción: Clase de prueba para AAZ_ApproveRejectProcedure_cls

------ ---------- -------------------------- -----------------------------------
No.    Fecha      Autor                      Descripción
------ ---------- -------------------------- -----------------------------------
1.0    26/09/2017 Rodrigo Francis          Clase creada Coverage= 58%
2.0	   05/10/2017 Ivan Neria				Finalización y documentación.
*******************************************************************************/
@isTest
private class AAZ_BeneficiaryQuery_tst{

   
   @testSetup static  void mytest() {
     // Crear configuración global de la app
        //AppMainSetting_cs__c mainSettings = AAZ_TestUtils_tst.getMainSettings();
        //insert mainSettings;
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
        @isTest
    static void should_get_case_documents() {

        User usr = [SELECT Id FROM User LIMIT 1];
        Case caso = [SELECT Id, employeeNumber__c, idServiceType__c, caseNumber, Account.NSS__c, FolioNSS__c FROM Case LIMIT 1];

        // Get endpoints for services
        EndpointSetting__mdt tokenEndpoint = AAZ_Utils_cls.getEndpointSetting('Afore_Authorization');
        String strTokenEndpoint = AAZ_GenericCallout_cls.getEndpoint(tokenEndpoint);
         EndpointSetting__mdt referencesEndpoint = AAZ_Utils_cls.getEndpointSetting('Afore_QueryBeneficiary');
        String strReferencesEndpoint = AAZ_GenericCallout_cls.getEndpoint(referencesEndpoint);

        // Create response mocks
        SingleRequestMock tokenMock = new SingleRequestMock('{"signToken":{"signedToken":"ZWQzNzUyZTg5MDk4MzE0YTA1OTY4ZGU0YWI4MjljMzFhYmU5MDNkOTA0NzIzYTlhOGNmNGJhNTAwYjE5YzYwNg==","expiration":"2017-04-26 13:24:19"}}');
        SingleRequestMock referencesMock = new SingleRequestMock('{"Out_ConsultaBeneficiarios":{"employedServiceRs":{"isSucessful":"true","beneficiaries":{"beneficiary":[{"name":"KCCUU","paternalLastName":"PName","maternalLastName":"maternalLastName","birthDate":" ","birthState":" ","curp":"XXHK761107HDFXLC09","phone":"5523027660","phoneType":"M","percentage":"100","bank":"bank","account":"acccounts","clabeAccount":"bankcblabe"}]}}}}');

        // Save response mocks in a MultiRequestMock instance
        MultiRequestMock multiRequestMock = new MultiRequestMock();
        multiRequestMock.addRequestMock(strTokenEndpoint, tokenMock);
        multiRequestMock.addRequestMock(strReferencesEndpoint, referencesMock);
		Test.setMock(HttpCalloutMock.class, multiRequestMock);
        

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, multiRequestMock);
        	AAZ_BeneficiaryQuery_cls.getBeneficiaryList(new SObject[]{ caso }, null);
        Test.stopTest();
       }
}