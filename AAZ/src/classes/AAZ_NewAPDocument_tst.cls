@isTest
private class AAZ_NewAPDocument_tst {
	
	@TestSetup static void setup() {

        //AppMainSetting_cs__c mainSettings = Test.isRunningTest()?
        //AAZ_TestUtils_tst.getMainSettings() : AppMainSetting_cs__c.getOrgDefaults();

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
	
	@isTest static void test_method_one() {
		Test.startTest();
			AAZ_NewAPDocument_ctr controller = new AAZ_NewAPDocument_ctr();
			controller.strMode = 'Reemplazo';
			controller.determinateWhatAppliesBasedOnMode();
			controller.getDocumentTypeOptions();
		Test.stopTest();
	}

	@isTest static void test_method_two() {

		Case thisCase = [ SELECT Id FROM Case LIMIT 1 ];

		Test.startTest();
			ApexPages.currentPage().getParameters().put('caseId', thisCase.Id);
			AAZ_NewAPDocument_ctr controller = new AAZ_NewAPDocument_ctr();
			controller.strMode = 'Baja';
			controller.determinateWhatAppliesBasedOnMode();
		Test.stopTest();
	}
	
}