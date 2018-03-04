/*******************************************************************************
Desarrollado por: Avanxo México
Autor: Luis Enrique
Proyecto: Afore Azteca
Descripción: Clase test para la clase AAZ_Utils_cls
-------------------------------------
No.    Fecha      Autor                          Descripción
------ ---------- -----------------------------  -----------
1.2    09/11/2017 Samuel Galindo                 Modificación
*******************************************************************************/

@isTest private class AAZ_Utils_tst {

	@TestSetup static void setup() {

		List<SObject> lstSObjects = new List<SObject>();

		Account thisAccount = new Account (
			LastName = 'TESTE X',
			NSS__c = '210792591',
			RFC__c = 'testezxd',
			RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cuenta personal').getRecordTypeId()
		);

		lstSObjects.add ( thisAccount );

		Contact thisContact = new Contact(
        	LastName = 'LastName',
        	employeeNumber__c = '1234567'
        );

        lstSObjects.add ( thisContact);

        Case parentCase = new Case (
        	Status = 'Nueva',
            Origin = 'Phone',
            employeeNumber__c = '11234'
        );

        lstSObjects.add ( parentCase );

        insert lstSObjects;

        Case thisCase = new Case(
            Status = 'Nueva',
            Origin = 'Phone',
            employeeNumber__c = '11233',
            ContactId = thisContact.Id,
            ParentId = parentCase.Id,
            NumberOfPrints__c = 2,
            AccountId = thisAccount.Id
        );

        insert thisCase;

        lstSObjects = new List<SObject>();

        Document__c documentOne = new Document__c (
            RelatedProcedure__c = thisCase.Id,
            FileURL__c = 'https://i.stack.imgur.com/6yyQs.png',
        	DocumentTypeId__c = '0'
        );

        lstSObjects.add ( documentOne );

        Document__c documentTwo = new Document__c (
            RelatedProcedure__c = thisCase.Id,
            FileURL__c = 'https://i.stack.imgur.com/6yyQs.png',
        	DocumentTypeId__c = '1003'
        );

        lstSObjects.add ( documentTwo );

        Document__c documentThree = new Document__c (
            RelatedProcedure__c = thisCase.Id,
            FileURL__c = 'https://i.stack.imgur.com/6yyQs.png',
        	DocumentTypeId__c = '26'
        );

        lstSObjects.add ( documentThree );

        insert lstSObjects;

	}

	@isTest static void test_method_getRecordTypes() {
		System.assertEquals( false, AAZ_Utils_cls.getRecordTypes('DeveloperName') == null );
	}

	@isTest static void test_method_generateMapWithCustomKey() {
		List<Case> lstCases = new List<Case>();
		for ( Integer i = 0 ; i < 5 ; i ++ ) {
			lstCases.add ( new Case ( employeeNumber__c = 'TesctEmp' + i , Status = 'Aprobado',FolioNSS__c = '689751' ) );
		}
		System.assertEquals( false, AAZ_Utils_cls.generateMapWithCustomKey( lstCases, 'employeeNumber__c' ) == null );
	}

	@isTest static void test_method_getUserCustomInfo() {

		User user = new User ( firstname = 'userFname',
            lastName = 'userLastname',
            email = 'user@test.org',
            Username = 'user@test.org',
            EmailEncodingKey = 'ISO-8859-1',
            Alias ='user',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            ProfileId = UserInfo.getProfileId()
        );
		insert user;
		System.assertEquals( 'user@test.org', AAZ_Utils_cls.getUserCustomInfo(user.Id).email );
	}

	@isTest static void test_method_getEndpointSetting() {
		EndpointSetting__mdt tstEndpointSetting = new EndpointSetting__mdt();
		tstEndpointSetting = AAZ_Utils_cls.getEndpointSetting('Afore_AddUserRs');
	}

	@isTest static void test_method_insertIncidence() {
		Id idRecordType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Afiliación').getRecordTypeId();
		Case thisCase = new Case (
			Type = 'Afiliación',
			Description = 'Description test',
			RecordTypeId = idRecordType,
			employeeNumber__c = 'TesctEmp01'
		);
		insert thisCase;
		AAZ_Utils_cls.insertIncidence( thisCase.Description, 'Usuario', thisCase.Id, UserInfo.getUserId() );
        AAZ_Utils_cls.assingNumberOfPrints(thisCase);
		System.assertEquals( 1, [SELECT Count() FROM SystemIssue__c ] );
	}

	@isTest static void test_method_strToDatetime() {
		// Envio null só para que o teste cubra o catch no método strToDatetime
		AAZ_Utils_cls.strToDatetime(null);
		System.assertEquals( '2017-02-01',  string.valueOfGmt( AAZ_Utils_cls.strToDatetime('2017-02-01T10:14:58.421-06:00') ).substring(0, 10) );
	}

	@isTest static void test_method_getResponseServ() {
		System.assertEquals( true,  AAZ_Utils_cls.getResponseServ( true, '12345', 'Description test') != null );
	}

	@isTest static void test_method_getFieldSetMembers() {
		AAZ_Utils_cls.getFieldSetMembers ( 'Case', '', '', '' );
		AAZ_Utils_cls.getFieldSetMembers ( 'Account', '', '', '' );
		AAZ_Utils_cls.getFieldSetMembers ( 'Contact', '', '', '' );
		AAZ_Utils_cls.getFieldSetMembers ( '', '', '', '' );
		//System.assertEquals( true,  AAZ_Utils_cls.getFieldSetMembers( ) );
	}

	@isTest static void test_method_documentsRequiredComplete() {
		Id idRecordType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Retiros Totales').getRecordTypeId();
		Case thisCase = new Case (
			Type = 'AgentPromotionVerification',
			Description = 'Description test',
			RecordTypeId = idRecordType,
			employeeNumber__c = 'TesctEmp01',
			IdSecuritytype__c = '123456',
			IdPensiontype__c = '43214',
			idRegimeType__c = '1233333',
			IdWithdrawtype__c = '1111111',
			SubType__c = 'test'
		);
		insert thisCase;
		System.assertEquals( false,  AAZ_Utils_cls.documentsRequiredComplete( thisCase ) );
	}

	@isTest static void test_method_assingRecorType() {
		Id idRecordType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Retiros Totales').getRecordTypeId();

		List<String> lstTypes = new List<String>{
			'Afiliación',
			'Agentes Promotores',
			'Modificación de datos',
			'Recertificación',
			'Retiros Parciales',
			'Retiros Totales',
			'SAR92',
			'Separación de Cuentas',
			'Solicitud de Aportaciones Voluntarias',
			'Unificación de Cuentas',
			'3'
		};

		List<Case> lstCases = new List<Case>();

		for ( integer i = 0 ; i < lstTypes.size() ; i ++ ) {
			Case thisCase = new Case (
				Type = lstTypes.get(i),
				Description = 'Description test',
				RecordTypeId = idRecordType,
				employeeNumber__c = 'TesctEmp01',
				IdSecuritytype__c = '123456',
				IdPensiontype__c = '43214',
				idRegimeType__c = '1233333',
				IdWithdrawtype__c = '1111111',
				SubType__c = 'test'
			);
			lstCases.add(thisCase);
		}
		insert lstCases;

		for (Case thisCase : lstCases ) {
			AAZ_Utils_cls.assingRecorType( thisCase );
		}

	}

	@isTest static void test_method_selectOptionSortByLabel() {

		List<SelectOption> lstDocumentOptions = new List<SelectOption>();
        List<String> lstDigitizationID = new List<String>();
        Integer count = 0;

        for ( Document__c iterator : [ SELECT Id, Name, FileURL__c, DocumentTypeId__c, DocumentType__c
                									FROM Document__c LIMIT 5 ] ) {
        	lstDigitizationID.add(iterator.DocumentTypeId__c);
        }

        List<DocumentType__mdt> lstDocumentType = [ SELECT DigitizationID__c, Label
                									FROM DocumentType__mdt LIMIT 5 ];

        for (DocumentType__mdt iterator:lstDocumentType) {

            lstDocumentOptions.add(
                new SelectOption(
                    String.valueOf(
                        count
                    ),
                    iterator.Label
                )
            );

            count ++;
        }

		AAZ_Utils_cls.selectOptionSortByLabel( lstDocumentOptions );
	}

		/**
		 * Prueba del método documentSortByOrder
		 * @type void
		 */
		@isTest static void testMethodOne() {
				Case caseInstance = new Case(
						Status = 'Nueva',
						Origin = 'Phone',
						Type   = 'AFILIACION',
						SubType__c = 'REGISTRO'
				);
				insert caseInstance;

				Document__c document1 = new Document__c(
						DocumentTypeId__c = '510',
						RelatedProcedure__c = caseInstance.Id,
						FileURL__c = 'https://i.stack.imgur.com/6yyQs.png',
						Orden__c=1,
						page__c=1
				);

				Document__c document2 = new Document__c(
						DocumentTypeId__c = '520',
						RelatedProcedure__c = caseInstance.Id,
						FileURL__c = 'https://i.stack.imgur.com/6yyQsW.png',
						Orden__c=1,
						page__c=1
				);

				List<Document__c> lstTest = new List<Document__c>();
				lstTest.add(document1);
				lstTest.add(document2);

				Test.startTest();
						AAZ_Utils_cls.documentSortByOrder(lstTest);
						System.assertEquals(2, lstTest.size());
				Test.stopTest();
		}

		/**
		 * Prueba del método documentsRequiredComplete cuando el Caso es del tipo
		 * Retiros Totales
		 * @type void
		 */
		@isTest static void testMethodTwo() {
				Case caseInstance = new Case(
						Status = 'Nueva',
						Origin = 'Phone',
						Type   = 'Retiros Totales',
						IdSecuritytype__c = 'PP',
						IdWithdrawtype__c = 'F',
						IdPensiontype__c = 'OR',
						idRegimeType__c = '73.0'
				);
				insert caseInstance;

				Document__c document1 = new Document__c(
						DocumentTypeId__c = '510',
						RelatedProcedure__c = caseInstance.Id,
						FileURL__c = 'https://i.stack.imgur.com/6yyQs.png',
						Orden__c=1,
						page__c=1
				);

				Document__c document2 = new Document__c(
						DocumentTypeId__c = '520',
						RelatedProcedure__c = caseInstance.Id,
						FileURL__c = 'https://i.stack.imgur.com/6yyQsW.png',
						Orden__c=1,
						page__c=1
				);

				Test.startTest();
						System.assertEquals(false, AAZ_Utils_cls.documentsRequiredComplete(caseInstance));
				Test.stopTest();
		}

		/**
		 * Prueba del método documentsRequiredComplete cuando el Caso no tiene tipo y
		 * @type void
		 */
		@isTest static void testMethodThree() {

				RecordType objTestRecordType = [
					SELECT BusinessProcessId,CreatedById,CreatedDate,Description,DeveloperName,
						Id,IsActive,IsPersonType,LastModifiedById,LastModifiedDate,Name,
						NamespacePrefix,SobjectType,SystemModstamp
					FROM RecordType
					WHERE DeveloperName = 'AgentPromotionVerification'
				];

				Case caseInstance = new Case(
						Status = 'Nueva',
						Origin = 'Phone',
						RecordTypeId = objTestRecordType.Id
				);
				insert caseInstance;

				Test.startTest();
						System.assertEquals(false, AAZ_Utils_cls.documentsRequiredComplete(caseInstance));
				Test.stopTest();
		}

		/**
		 * Prueba del método assingRecorType
		 * @type void
		 */
		@isTest static void testMethodFour() {

				Case caseInstance1 = new Case(
						Status = 'Nueva',
						Origin = 'Phone',
						idServiceType__c = '1'
				);
				insert caseInstance1;

				Case caseInstance2 = new Case(
						Status = 'Nueva',
						Origin = 'Phone',
						idServiceType__c = '4'
				);
				insert caseInstance2;

				Case caseInstance3 = new Case(
						Status = 'Nueva',
						Origin = 'Phone',
						idServiceType__c = '46'
				);
				insert caseInstance3;

				Case caseInstance4 = new Case(
						Status = 'Nueva',
						Origin = 'Phone',
						idServiceType__c = '3'
				);
				insert caseInstance4;

				Case caseInstance5 = new Case(
						Status = 'Nueva',
						Origin = 'Phone',
						idServiceType__c = '401'
				);
				insert caseInstance5;

				Case caseInstance6 = new Case(
						Status = 'Nueva',
						Origin = 'Phone',
						idServiceType__c = '59'
				);
				insert caseInstance6;

				Case caseInstance7 = new Case(
						Status = 'Nueva',
						Origin = 'Phone',
						idServiceType__c = '39'
				);
				insert caseInstance7;

				Test.startTest();
						AAZ_Utils_cls.assingRecorType(caseInstance1);
						AAZ_Utils_cls.assingRecorType(caseInstance2);
						AAZ_Utils_cls.assingRecorType(caseInstance3);
						AAZ_Utils_cls.assingRecorType(caseInstance4);
						AAZ_Utils_cls.assingRecorType(caseInstance5);
						AAZ_Utils_cls.assingRecorType(caseInstance6);
						AAZ_Utils_cls.assingRecorType(caseInstance7);
				Test.stopTest();
		}
}