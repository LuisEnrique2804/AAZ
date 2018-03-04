@isTest
private class AAZ_WebServiceException_tst {
	
	@isTest static void test_method_one() {
		
		EndpointSetting__mdt endPoint = [ SELECT Id FROM EndpointSetting__mdt LIMIT 1 ];

		Test.startTest();
			new AAZ_WebServiceException( endPoint, 'test message', 'test request', 'test response');
		Test.stopTest();
	}
		
}