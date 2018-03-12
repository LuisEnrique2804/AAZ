@isTest 
private class AAZ_CallOutFuture_tst {
	
	@TestSetup static void setup() {

		// Crear configuración global de la app
        //AppMainSetting_cs__c mainSettings = Test.isRunningTest()?
        //AAZ_TestUtils_tst.getMainSettings() : AppMainSetting_cs__c.getOrgDefaults();
        // Configuración para métodos de prueba

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
            employeeNumber__c='210792591',
            ContactId = thisContact.Id,
            AccountId = thisAccount.Id            
        );

		insert thisCase;

	}
	
	@isTest static void test_method() {
		
		Set<Id> setIds = new Set<Id>();

		List<Case> lstCases =  [ SELECT Subject, employeeNumber__c, ContactId, AccountId 
							FROM Case LIMIT 1 ];

		for ( Case thisCase : lstCases ) {
			setIds.add(thisCase.Id);
		}
		System.debug(loggingLevel.Error, '*** lstCases: ' + lstCases);
		System.debug(loggingLevel.Error, '*** lstCases.get(0).Id: ' + lstCases.get(0).Id);
		Test.startTest();
			AAZ_CallOutFuture_cls.callOuts ( setIds );			
			AAZ_CallOutFuture_cls.processCase  ( lstCases.get(0).Id, true );
			AAZ_CallOutFuture_cls.updateSubsidary ( lstCases.get(0).Id );		
		Test.stopTest();

	}
	
}