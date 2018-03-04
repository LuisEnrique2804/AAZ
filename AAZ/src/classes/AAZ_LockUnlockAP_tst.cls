@isTest
private class AAZ_LockUnlockAP_tst {
	
	static testMethod void test_method_one() {
		
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


		Test.startTest();
			ApexPages.StandardController stdController;
			AAZ_LockUnlockAP_ctr controller = new AAZ_LockUnlockAP_ctr(stdController);
			controller.stgFolio = 'Stage Folio';
			controller.stgCurp = 'Stage Curp';
			controller.stgName = 'Stage Name';
			controller.stgNss = '10002';
			controller.strInsertSelected  = 'strInsertSelected ';
			controller.strAPLock = 'strAPLock';
			controller.stgNssWorker = '210792591';
			controller.relatedWorker = thisAccount;
			controller.relatedAgent = thisContact;
			controller.caseInstance = thisCase;
			controller.lastInteractionCreated = thisCase.Id;
			controller.blnAgenLockUnlock = true;
			controller.isItValidToStart = true;
			controller.getFieldSetFieldsCase();
			controller.getFieldSetFieldsAcc();
			controller.searchCaseContAcc();
			controller.getFieldSetFieldsCont();
			controller.validateInputs();
			controller.LockUnlock();
		Test.stopTest();

	}
		
		static testMethod void test_method_two() {
		
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

		Case thisCase = new Case(
            Subject = 'Prueba',
            employeeNumber__c='teste'
        );

		lstSObjects.add ( thisCase );

		insert lstSObjects;

		Test.startTest();
			ApexPages.StandardController stdController;
			AAZ_LockUnlockAP_ctr controller = new AAZ_LockUnlockAP_ctr(stdController);
			controller.stgFolio = 'Stage Folio';
			controller.stgCurp = 'Stage Curp';
			controller.stgName = 'Stage Name';
			controller.stgNss = '10002';
			controller.strInsertSelected  = 'strInsertSelected ';
			controller.strAPLock = 'strAPLock';
			controller.stgNumAp = '210792591';
			controller.relatedWorker = thisAccount;
			controller.relatedAgent = thisContact;
			controller.caseInstance = thisCase;
			controller.lastInteractionCreated = thisCase.Id;
			controller.blnAgenLockUnlock = true;
			controller.isItValidToStart = true;
			controller.searchCaseContAcc();
		Test.stopTest();
	}

	static testMethod void test_method_three() {
		
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

		Case thisCase = new Case(
            Subject = 'Prueba',
            employeeNumber__c='teste'
        );

		lstSObjects.add ( thisCase );

		insert lstSObjects;

		Test.startTest();
			ApexPages.StandardController stdController;
			AAZ_LockUnlockAP_ctr controller = new AAZ_LockUnlockAP_ctr(stdController);
			controller.stgFolio = 'Stage Folio';
			controller.stgCurp = 'Stage Curp';
			controller.stgName = 'Stage Name';
			controller.stgNss = '10002';
			controller.strInsertSelected  = 'strInsertSelected ';
			controller.strAPLock = 'strAPLock';
			controller.stgNumEmpAp = '210792591';
			controller.relatedWorker = thisAccount;
			controller.relatedAgent = thisContact;
			controller.caseInstance = thisCase;
			controller.lastInteractionCreated = thisCase.Id;
			controller.blnAgenLockUnlock = true;
			controller.isItValidToStart = true;
			controller.searchCaseContAcc();
		Test.stopTest();
	}



}