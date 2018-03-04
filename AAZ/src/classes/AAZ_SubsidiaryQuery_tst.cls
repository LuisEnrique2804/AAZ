@isTest
private class AAZ_SubsidiaryQuery_tst {
	
	@testSetup static void setup() {
        // Crear configuración global de la app
        //AppMainSetting_cs__c mainSettings = Test.isRunningTest()?
        //AAZ_TestUtils_tst.getMainSettings() : AppMainSetting_cs__c.getOrgDefaults();
    }

	@isTest static void test_method_one() {
		
		EndpointSetting__mdt tokenEndpoint = AAZ_Utils_cls.getEndpointSetting('Afore_Authorization');
        String strTokenEndpoint = AAZ_GenericCallout_cls.getEndpoint(tokenEndpoint);

        EndpointSetting__mdt documentsEndpoint = AAZ_Utils_cls.getEndpointSetting('Afore_QuerySubsidiary');
        String strDocumentsEndpoint = AAZ_GenericCallout_cls.getEndpoint(documentsEndpoint);

        // Create response mocks
        SingleRequestMock tokenMock = new SingleRequestMock('{"signToken":{"signedToken":"ZWQzNzUyZTg5MDk4MzE0YTA1OTY4ZGU0YWI4MjljMzFhYmU5MDNkOTA0NzIzYTlhOGNmNGJhNTAwYjE5YzYwNg==","expiration":"2017-04-26 13:24:19"}}');
        SingleRequestMock documentsMock = new SingleRequestMock('{"Out_ConsultaSucursales":{"employedServiceRs":{"isSucessful":"true","sucursalName":"nameSucursal","sucursalEconomicNumber":"123","phoneSucursal":"1234567890","regionalName":"nameRegional","regionalPhone":"11111111111","IdCC":"1q2w3e4r5","idEntity":"t6y7u8i9o0p","chanel":"7","ccRegional":"sul","ccZone":"safe","zoneSF":"SOAM","ccTerritorial":"SOAM","territorialSF":"LATAM","ccImplement":"ccImplem","Implement":"Implem","employeImplement":"Goku","ImplementName":"ImplemName","phoneImplement":"222222222","implementEmail":"email@email.co","ccDivisional":"ccDivision","employeDivisional":"employeDiv","divisionalName":"Joy Division","divisionalPhone":"24446666688888888","divisionalEmail":"test@test.com"}}}');

        // Save response mocks in a MultiRequestMock instance
        MultiRequestMock multiRequestMock = new MultiRequestMock();
        multiRequestMock.addRequestMock(strTokenEndpoint, tokenMock);
        multiRequestMock.addRequestMock(strDocumentsEndpoint, documentsMock);

        

		Map<String, Object> mapExtraAttrs = new Map<String, Object>();

		Contact contactInstance = new Contact(
        	LastName = 'LastName',
        	employeeNumber__c = '1234567'
        ); 
		
		Insert contactInstance;

		Case caseInstance = new Case(
            Status = 'Nueva',
            Origin = 'Phone',
            employeeNumber__c = '123456',
            ContactId = contactInstance.Id
        );

		Insert caseInstance;

		Test.setMock(HttpCalloutMock.class, multiRequestMock);

		Test.startTest();
			AAZ_SubsidiaryQuery_cls.getSubsidiaryList( caseInstance.Id, mapExtraAttrs );
		Test.stopTest();
	}

}