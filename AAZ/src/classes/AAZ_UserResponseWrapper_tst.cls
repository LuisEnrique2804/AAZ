@isTest
private class AAZ_UserResponseWrapper_tst {
	
	@isTest static void test_method_one() {
		Test.startTest();
			AAZ_UserResponseWrapper_wpr.parse('{ a:b }');
		Test.stopTest();
	}
	
}