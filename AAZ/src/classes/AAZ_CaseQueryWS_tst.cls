@isTest
private class AAZ_CaseQueryWS_tst {

    @testSetup static void setup() {
        // Crear configuración global de la app
        //AppMainSetting_cs__c mainSettings = Test.isRunningTest()?
        //AAZ_TestUtils_tst.getMainSettings() : AppMainSetting_cs__c.getOrgDefaults();
    }

	@isTest static void test_method_one() {

		// Get endpoints for services
        EndpointSetting__mdt tokenEndpoint = AAZ_Utils_cls.getEndpointSetting('Afore_Authorization');
        String strTokenEndpoint = AAZ_GenericCallout_cls.getEndpoint(tokenEndpoint);

        EndpointSetting__mdt documentsEndpoint = AAZ_Utils_cls.getEndpointSetting('Afore_QueryProcess');
        String strDocumentsEndpoint = AAZ_GenericCallout_cls.getEndpoint(documentsEndpoint);

        // Create response mocks
        SingleRequestMock tokenMock = new SingleRequestMock('{"signToken":{"signedToken":"ZWQzNzUyZTg5MDk4MzE0YTA1OTY4ZGU0YWI4MjljMzFhYmU5MDNkOTA0NzIzYTlhOGNmNGJhNTAwYjE5YzYwNg==","expiration":"2017-04-26 13:24:19"}}');
        SingleRequestMock documentsMock = new SingleRequestMock('{"Out_ConsultaTramites":{"newServiceRequest":{"isSuccessful":"true","searchResult":{"folio":"12345","employeeNumber":"123456","procedureData":{"CertificateDateG":"2015-11-22","DaysToPermanceG":"650","numberAgreement":"4275749"},"workerData":{"country":"MEX","curp":"MOCJ800821MMCNSQ09","delegation":"JIQUIPILCO","externalNumber":"NULL","fatherLastName":"DEL MONTE","internalNumber":"SN","motherLastName":"CASTILLO","name":"JAQUELINE","nss":"16028012298","phoneNumber":"7122078862","postalCode":"50800","state":"MEXICO","street":"LOMA DEL ASTILLERO","suburb":"JIQUIPILCO"}}}}}');

        // Save response mocks in a MultiRequestMock instance
        MultiRequestMock multiRequestMock = new MultiRequestMock();
        multiRequestMock.addRequestMock(strTokenEndpoint, tokenMock);
        multiRequestMock.addRequestMock(strDocumentsEndpoint, documentsMock);

        Test.setMock(HttpCalloutMock.class, multiRequestMock);

		Test.startTest();
			AAZ_CaseQueryWS_cls.getCaseDetails('96028215331', '122343', 'Test', 'LastName', 'Mname');
		Test.stopTest();
	}

}