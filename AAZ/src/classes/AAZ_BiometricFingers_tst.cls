@isTest
private class AAZ_BiometricFingers_tst {
	
	@isTest static void test_method_one() {
		Test.startTest();
		AAZ_BiometricFingers_ctr controller = new AAZ_BiometricFingers_ctr();
			controller.biometricFingersSave();
		Test.stopTest();
	}
	
}