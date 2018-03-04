/****************************************************************************************************
    Información general
    -------------------
    author: Iván Neria
    email: ineria@avanxo.com
    company: Avanxo México
    Project: Afore
    Customer: Banco AZTECA

    Description:
    Clase de pruebas de los metodos en la clases
	* AAZ_CustomCaseDetail_ctr
	* AAZ_DataModify_ctr
    Information about changes (versions)
    ================================================================================================
    Number    Dates           Author                       Description
    ------    --------        --------------------------   -----------------------------------------
    1.0       02-Oct-2017     Flavio                   	  Creación de la Clase
	1.1		  13-Oct-2017	  Iván Neria				  Actualización de nuevos metodos agregados
														  a la clase principal.
    ================================================================================================
****************************************************************************************************/
@isTest
private class AAZ_InsertComplaint_tst {

	@TestSetup static void setup() {

		List<SObject> lstSObjects = new List<SObject>();

		Account thisAccount = new Account (
			FirstName = 'TESTE X',
			LastName =  'stgFatherLastName',
			PaternalLastName__c = 'stgFatherLastName', 
			NSS__c = '210792591',
			RFC__c = 'testezxd',
			RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cuenta personal').getRecordTypeId(),
			CURP__c = '210792591'
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

		Document__c thisDocument = new Document__c(
            DocumentTypeId__c = '1',
            RelatedProcedure__c = thisCase.Id,
            FileURL__c = 'https://i.stack.imgur.com/6yyQs.png'
        );

        insert thisDocument;
	}



	@isTest static void test_method_one() {

		Account thisAccount = [ SELECT Name, NSS__c, RFC__c, RecordTypeId
								FROM Account LIMIT 1 ];

		Case thisCase = [ SELECT Subject, employeeNumber__c, ContactId, AccountId, CaseNumber
							FROM Case LIMIT 1 ];

		Contact thisContact = [ SELECT LastName, PromoterAgentNumber__c, EmployeeNumber__c
								FROM Contact LIMIT 1 ];

		List<Document__c> lstDocuments = [ SELECT DocumentTypeId__c, RelatedProcedure__c, FileURL__c
											FROM Document__c ];
		List<Case> CatchCas = [ SELECT Account.Id, Contact.id, id
								FROM Case ];

		Test.startTest();
			ApexPages.StandardController stdCtl;
			AAZ_InsertComplaint_ctr controller = new AAZ_InsertComplaint_ctr(stdCtl);

		// Insert values into variables
			controller.stgFolio = 'stgFolio';
			controller.stgFatherLastName = 'stgFatherLastName';
			controller.stgMathernalName = 'stgMathernalName';

			controller.stgOrigin = 'stgOrigin';
			controller.dateComplain = Date.newInstance(2016, 12, 9);
			controller.dateCaptureComplain = Date.newInstance(2016, 12, 9);
			controller.stgPhoneWorker = 'stgPhoneWorker';
			controller.stgEmail = 'stgEmail@stgEmail.co';
			controller.stgStreet = 'stgStreet';

			controller.stgInternalNumber = '1234';
			controller.stgExternalNumber = '4321';
			controller.stgDelegation = 'stgDelegation';
			controller.stgState = 'stgState';
			controller.stgCountry = 'stgCountry';
			controller.stgAforeNumber = 782373;
			controller.stgAforeToPass = 'stgAforeToPass';

			controller.strCaseNumber = thiscase.CaseNumber;
			controller.lastInteractionCreated  = thiscase.Id;
			controller.lstcurrentDocs  = lstDocuments;
			controller.relatedWorker = thisAccount;
			controller.relatedAgent = thisContact;
			controller.caseInstance = thisCase;
			controller.blnIsInteractionCreated = true;
			controller.stgNss = '210792591';
			controller.caseToCatchQuery=CatchCas;

		// Call methods
			controller.searchCaseContAcc();
			controller.getFieldSetFieldsCase();
			controller.getFieldSetFieldsAcc();
			controller.getFieldSetFieldsCont();

			controller.stgComplain = 'stgComplain'; 			// I redefine value because next method need,
			controller.strInsertSelected = 'Traspaso Indebido'; // for more coverage
			controller.stgComplain = 'stgComplain'; // I redefine value because next method need, for more coverage
			controller.procedurePending();
			controller.getInsertOptions();
			controller.LockUnlockAP2();
		//

		Test.stopTest();
	}

	@isTest static void test_method_two() {

		Account thisAccount = [ SELECT Name, CURP__c, RFC__c, RecordTypeId
								FROM Account LIMIT 1 ];

		Case thisCase = [ SELECT Subject, employeeNumber__c, ContactId, AccountId, CaseNumber
							FROM Case LIMIT 1 ];

		Contact thisContact = [ SELECT LastName, PromoterAgentNumber__c, EmployeeNumber__c
								FROM Contact LIMIT 1 ];

		List<Document__c> lstDocuments = [ SELECT DocumentTypeId__c, RelatedProcedure__c, FileURL__c
											FROM Document__c ];

		Test.startTest();
			ApexPages.StandardController stdCtl;
			AAZ_InsertComplaint_ctr controller = new AAZ_InsertComplaint_ctr(stdCtl);

		// Insert values into variables
			controller.stgFolio = 'stgFolio';
			controller.stgFatherLastName = 'stgFatherLastName';
			controller.stgMathernalName = 'stgMathernalName';
			controller.strCaseNumber = thiscase.CaseNumber;
			controller.lastInteractionCreated  = thiscase.Id;
			controller.lstcurrentDocs  = lstDocuments;
			controller.relatedWorker = thisAccount;
			controller.relatedAgent = thisContact;
			controller.caseInstance = thisCase;
			controller.blnIsInteractionCreated = true;
			controller.stgCurp = '210792591';
		//

			controller.searchCaseContAcc();

		Test.stopTest();

	}

	@isTest static void test_method_three() {

		Account thisAccount = [ SELECT Name, RFC__c, RecordTypeId
								FROM Account LIMIT 1 ];

		Case thisCase = [ SELECT Subject, employeeNumber__c, ContactId, AccountId, CaseNumber
							FROM Case LIMIT 1 ];

		Contact thisContact = [ SELECT LastName, PromoterAgentNumber__c, EmployeeNumber__c
								FROM Contact LIMIT 1 ];

		List<Document__c> lstDocuments = [ SELECT DocumentTypeId__c, RelatedProcedure__c, FileURL__c
											FROM Document__c ];

		Test.startTest();
			ApexPages.StandardController stdCtl;
			AAZ_InsertComplaint_ctr controller = new AAZ_InsertComplaint_ctr(stdCtl);

		// Insert values into variables
			controller.stgFolio = 'stgFolio';
			controller.stgFatherLastName = 'stgFatherLastName';
			controller.stgMathernalName = 'stgMathernalName';
			controller.strCaseNumber = thiscase.CaseNumber;
			controller.lastInteractionCreated  = thiscase.Id;
			controller.lstcurrentDocs  = lstDocuments;
			controller.relatedWorker = thisAccount;
			controller.relatedAgent = thisContact;
			controller.caseInstance = thisCase;
			controller.blnIsInteractionCreated = true;
			controller.stgName = thisAccount.Name;
		//

			controller.searchCaseContAcc();

		Test.stopTest();

	}

	@isTest static void test_method_four() {

		Account thisAccount = [ SELECT Name, RFC__c, RecordTypeId
								FROM Account LIMIT 1 ];

		Case thisCase = [ SELECT Subject, employeeNumber__c, ContactId, AccountId, CaseNumber
							FROM Case LIMIT 1 ];

		Contact thisContact = [ SELECT LastName, PromoterAgentNumber__c, EmployeeNumber__c
								FROM Contact LIMIT 1 ];

		List<Document__c> lstDocuments = [ SELECT DocumentTypeId__c, RelatedProcedure__c, FileURL__c
											FROM Document__c ];

        List<Case> CatchCas = [ SELECT Account.Id, Contact.id, id
											FROM Case ];


		Test.startTest();
			ApexPages.StandardController stdCtl;
			AAZ_InsertComplaint_ctr controller = new AAZ_InsertComplaint_ctr(stdCtl);

		// Insert values into variables
			controller.stgFolio = 'stgFolio';
			controller.stgFatherLastName = 'stgFatherLastName';
			controller.stgMathernalName = 'stgMathernalName';
			controller.strCaseNumber = thiscase.CaseNumber;
			controller.lastInteractionCreated  = thiscase.Id;
			controller.lstcurrentDocs  = lstDocuments;
			controller.relatedWorker = thisAccount;
			controller.relatedAgent = thisContact;
			controller.caseInstance = thisCase;
			controller.blnIsInteractionCreated = true;
	        controller.caseToCatchQuery=CatchCas;
	        controller.newCase();
	        controller.caseToCatchQuery=CatchCas;
			controller.searchCaseContAcc();

		Test.stopTest();

	}

    //Test cuando el case es 'Traspaso Indebido' y repetidas llamadas a métodos para ampliar su cobertura
    @isTest static void test_method_five() {

		Account thisAccount = [ SELECT Name, RFC__c, RecordTypeId
								FROM Account LIMIT 1 ];

		Case thisCase = [ SELECT Subject, employeeNumber__c, ContactId, AccountId, CaseNumber
							FROM Case LIMIT 1 ];

		Contact thisContact = [ SELECT LastName, PromoterAgentNumber__c, EmployeeNumber__c
								FROM Contact LIMIT 1 ];

		List<Document__c> lstDocuments = [ SELECT DocumentTypeId__c, RelatedProcedure__c, FileURL__c
											FROM Document__c ];

        List<Case> CatchCas = [ SELECT Account.Id, Contact.id, id
											FROM Case ];


		Test.startTest();
			ApexPages.StandardController stdCtl;
			AAZ_InsertComplaint_ctr controller = new AAZ_InsertComplaint_ctr(stdCtl);

		// Insert values into variables
			controller.stgFolio = 'stgFolio';
			controller.stgFatherLastName = 'stgFatherLastName';
			controller.stgMathernalName = 'stgMathernalName';
			controller.strInsertSelected='Traspaso Indebido';
        controller.caseToCatchQuery=CatchCas;
        controller.newCase();
        controller.blnSearchWasNotOK=false;
        //controller.procedurePending();
		controller.searchCase();
		controller.caseToCatchQuery=CatchCas;
		controller.searchCaseContAcc();

		Test.stopTest();

	}
}