@isTest
private class AAZ_CallOut_tst {
	
	@TestSetup static void setup() {

        AppMainSetting_cs__c mainSettings = AAZ_TestUtils_tst.getMainSettings();
        insert mainSettings;

		List<SObject> lstSObjects = new List<SObject>();

		Account thisAccount = new Account (
			LastName = 'TESTE X',
			NSS__c = '210792591',
			RFC__c = 'testezxd',
			RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cuenta personal').getRecordTypeId()
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
            AccountId = thisAccount.Id            
        );

		insert thisCase;

	}

	@isTest static void test_method() {

		Set<Id> setIds = new Set<Id>();

		Case thisCase = [ SELECT Id FROM Case LIMIT 1 ];

		setIds.add ( thisCase.Id ); 

		Test.startTest();
			AAZ_CallOut_que callOutProcedure = new AAZ_CallOut_que();
			callOutProcedure.setIdProcedure = setIds;
			String jobId = System.enqueueJob(callOutProcedure);
        Test.stopTest();
		
	}
	
}