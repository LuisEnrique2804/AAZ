@isTest
private class AAZ_LockUnLockAgent_tst {
	
	@isTest static void test_method_getLockUnlockAPList() {
		List<Contact> lstContacts = new List<Contact>();
		for ( Integer i = 0 ; i < 5 ; i ++ ) {
			Contact thisContact = new Contact(
				LastName = String.valueOf( i )
			);
			lstContacts.add(thisContact);
		}
		insert lstContacts;
		Test.startTest();
			AAZ_LockUnLockAgent_cls.getLockUnlockAPList ( lstContacts, new Map<String,Object>() );
		Test.stopTest();
	}
	
}