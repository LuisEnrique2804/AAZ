@isTest
private class AAZ_RiskLevel_tst {
	
	@isTest static void test_method_one() {
		
		List<SObject> objectsInstance = new List<SObject>();

		Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cuenta personal').getRecordTypeId();
		Account accountInstance = new Account (
			LastName = 'Account Name',
			NSS__c = '210792591',
			RFC__c = 'testezxd',
			RecordTypeId = devRecordTypeId
		);

		Contact contactInstance = new Contact(
        	LastName = 'LastName',
        	employeeNumber__c = '1234567'
        ); 
		objectsInstance.add(contactInstance);
		objectsInstance.add(accountInstance);
		Insert objectsInstance;

		Case caseInstance = new Case(
            Status = 'Nueva',
            Origin = 'Phone',
            employeeNumber__c = '123456',
            AccountId = accountInstance.Id,
            ContactId = contactInstance.Id
        );
				

        TriggerManager.inactivate('AAZ_CaseMainTrigger_tgr');
		Insert caseInstance;
		List<Case> lstCases = new List<Case>();
		lstCases.add(caseInstance);
		Test.startTest();
	        AAZ_RiskLevel_ctr AAz = new AAZ_RiskLevel_ctr(new ApexPages.StandardController(caseInstance));
	    Test.stopTest();
	}
		
}