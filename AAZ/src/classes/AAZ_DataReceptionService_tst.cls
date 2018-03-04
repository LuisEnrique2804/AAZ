@isTest
private class AAZ_DataReceptionService_tst {
	
	@testSetup static void setup() {
        // Crear configuración global de la app
        //AppMainSetting_cs__c mainSettings = AAZ_TestUtils_tst.getMainSettings();
        //insert mainSettings;
    }

	@isTest static void test_method_one() {


		List<SObject> lstSObjects = new List<SObject>();

		Account thisAccount = new Account (
			LastName = 'TESTE X',
			NSS__c = '210792591',
			RFC__c = 'testezxd',
			RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cuenta personal').getRecordTypeId(),
			Type = 'Analyst'
		);
		lstSObjects.add ( thisAccount );

		Contact thisContact = new Contact(
			LastName = 'Contact Lastname',
			PromoterAgentNumber__c = '210792591',
			EmployeeNumber__c = '210792591'
		);

		lstSObjects.add ( thisContact );

		insert lstSObjects;

		Case thisCase = new Case(
            Subject = 'Prueba',
            employeeNumber__c='teste',
            ContactId = thisContact.Id,
            AccountId = thisAccount.Id,
            FolioNss__c = '1234567890'
        );

		insert thisCase;
		

		AAZ_DataReceptionService_cls.SendDataParamsWrapper paramsInstance = new AAZ_DataReceptionService_cls.SendDataParamsWrapper();
        paramsInstance.strNSS = thisCase.Account.NSS__c;
        paramsInstance.strFolio = thisCase.FolioNss__c;
        paramsInstance.strIdArchivo = 0;
        paramsInstance.strTipoServicio = thisCase.Account.Type;

		EndpointSetting__mdt tokenEndpoint = AAZ_Utils_cls.getEndpointSetting('Afore_Authorization');
        String strTokenEndpoint = AAZ_GenericCallout_cls.getEndpoint(tokenEndpoint);

        EndpointSetting__mdt documentsEndpoint = AAZ_Utils_cls.getEndpointSetting('Afore_ReceptionData');
        String strDocumentsEndpoint = AAZ_GenericCallout_cls.getEndpoint(documentsEndpoint);

        // Create response mocks
        SingleRequestMock tokenMock = new SingleRequestMock('{"signToken":{"signedToken":"ZWQzNzUyZTg5MDk4MzE0YTA1OTY4ZGU0YWI4MjljMzFhYmU5MDNkOTA0NzIzYTlhOGNmNGJhNTAwYjE5YzYwNg==","expiration":"2017-04-26 13:24:19"}}');
        SingleRequestMock documentsMock = new SingleRequestMock('"In_RecepcionArchivos":{"xmlns":"http://www.baz.com.mx/corporate/mexico/business/enrrolamiento/1.0","docServiceRq":{"nss":"1234567890","folio":"strFolio","idArchivo":"1q2w3e4r5t6y7u8i9o0p","parte":"1","total":"1","formato":"json","archivoBase64":"R29rdSBvIG1lbGhvciBndWVycmVpcm8gZG8gdW5pdmVyc28h","typo de servicio":"stringServiceType"}}');

        // Save response mocks in a MultiRequestMock instance
        MultiRequestMock multiRequestMock = new MultiRequestMock();
        multiRequestMock.addRequestMock(strTokenEndpoint, tokenMock);
        multiRequestMock.addRequestMock(strDocumentsEndpoint, documentsMock);

        Test.setMock(HttpCalloutMock.class, multiRequestMock);

        Test.startTest();
        	AAZ_DataReceptionService_cls.sendData(paramsInstance);
        Test.stopTest();
	}
	
}