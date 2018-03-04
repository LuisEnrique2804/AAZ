@isTest
private class AAZ_PromoterDocumentsService_tst {
	
	 @testSetup static void setup() {
        // Crear configuración global de la app
        //AppMainSetting_cs__c mainSettings = Test.isRunningTest()?
        //AAZ_TestUtils_tst.getMainSettings() : AppMainSetting_cs__c.getOrgDefaults();
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
    }

	@isTest static void test_method_one() {
		
		Case cas = new Case(
            Subject = 'Prueba',
            employeeNumber__c='1234567'
        );
        
        insert cas;

        List<User> lstUsrs = [SELECT Alias, 
                                    Email, 
                                    LastName, 
                                    LocaleSidKey, 
                                    ProfileId, 
                                    Name FROM User LIMIT 1];




        Document__c document = new Document__c(
            DocumentTypeId__c = '1',
            RelatedProcedure__c = cas.Id,
            FileURL__c = 'https://i.stack.imgur.com/6yyQs.png'
        );

        insert document;

        Map<String,Object> mapExtraAttrs =  new Map<String,Object>{
            'documents' => new Map<String,Object>{
                'file' => 'S2FrYXJvdG8gw6kgdm9jw6osIGtha2Fyb3RvPw=='
            },
            'type' => 'test',
            'name' => 'test',
            'mode' => 'REEMPLAZO',
            'folio' => 'test',
            'docFolio' => 'Baja'
        };

        // Get endpoints for services
        EndpointSetting__mdt tokenEndpoint = AAZ_Utils_cls.getEndpointSetting('Afore_Authorization');
        String strTokenEndpoint = AAZ_GenericCallout_cls.getEndpoint(tokenEndpoint);

        EndpointSetting__mdt documentsEndpoint = AAZ_Utils_cls.getEndpointSetting('Afore_DocAP');
        String strDocumentsEndpoint = AAZ_GenericCallout_cls.getEndpoint(documentsEndpoint);

        // Create response mocks
        SingleRequestMock tokenMock = new SingleRequestMock('{"signToken":{"signedToken":"ZWQzNzUyZTg5MDk4MzE0YTA1OTY4ZGU0YWI4MjljMzFhYmU5MDNkOTA0NzIzYTlhOGNmNGJhNTAwYjE5YzYwNg==","expiration":"2017-04-26 13:24:19"}}');
        SingleRequestMock documentsMock = new SingleRequestMock('{"Out_DocumentosPromotor":{"approveServiceRs":{"strDocURL":"true","isSucessful":"true","comments":"true"}}}');

        // Save response mocks in a MultiRequestMock instance
        MultiRequestMock multiRequestMock = new MultiRequestMock();
        multiRequestMock.addRequestMock(strTokenEndpoint, tokenMock);
        multiRequestMock.addRequestMock(strDocumentsEndpoint, documentsMock);

        Test.setMock(HttpCalloutMock.class, multiRequestMock);


		Test.startTest();
			AAZ_PromoterDocumentsService_cls.sendFormats( lstUsrs, mapExtraAttrs );
		Test.stopTest();
	}
	
}