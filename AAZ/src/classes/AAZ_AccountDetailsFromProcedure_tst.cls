/****************************************************************************************************
    Información general
    -------------------
    author: Rodrigo Francis
    company: Avanxo México
    Project: Afore
    Customer: Banco AZTECA

    Description:
    Clase de pruebas de los metodos en la clase
	* AAZ_AccountDetailsFromProcedure_ctr
    Information about changes (versions)
    ================================================================================================
    Number    Dates           Author                       Description
    ------    --------        --------------------------   -----------------------------------------
    1.0     26-Sep-2017       Rodrigo Francis              Creación de la Clase
		1.1		  06-Oct-2017	      Arieli Araujo					       Modificación de  test_method_one();
		1.2		  06-Oct-2017	      Iván Neria					   			 Modificación de  test_method_one(); y creación test_method_two();
		1.3     06-Nov-2017       Samuel Galindo               Modificación
    ================================================================================================
****************************************************************************************************/
@isTest
private class AAZ_AccountDetailsFromProcedure_tst {


	/**
	 * Prueba exception metodo saveRejections()
	 * @type void
	 */
	@isTest static void testMethodNine() {

			Contact contactInstance = new Contact(
					LastName = 'LastName',
					employeeNumber__c = '1234567'
					);
			insert contactInstance;

			Account account = new Account ();
			account.LastName='teste';
			account.RecordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cuenta personal').getRecordTypeId();
			insert account;

			Case caseInstance = new Case(
					Status = 'Nueva',
					Origin = 'Phone',
					employeeNumber__c = '11233',
					ContactId = contactInstance.Id,
					accountId=account.id
			);
			TriggerManager.inactivate('AAZ_CaseMainTrigger_tgr');
			Database.insert(caseInstance, true);

			Document__c document = new Document__c(
					DocumentTypeId__c = '10',
					RelatedProcedure__c = caseInstance.Id,
					FileURL__c = 'https://i.stack.imgur.com/6yyQs.png'
			);
			TriggerManager.inactivate('AAZ_CaseMainTrigger_tgr');
			Database.insert(document, true);

			Test.startTest();
					AAZ_AccountDetailsFromProcedure_ctr controller = new AAZ_AccountDetailsFromProcedure_ctr(new ApexPages.StandardController(caseInstance));
					List<String> lstRejection = new List<String>();
					lstRejection.add('1132');
					controller.mapRejection.put('10', lstRejection);
					ReasonRejection__c objReasonRejection = new ReasonRejection__c();
					objReasonRejection.Name = 'Prueba';
					controller.lstInsertReasonRejection.add(objReasonRejection);
					Case caseTest = new Case();
					controller.lstCase.add(caseTest);
					controller.saveRejections();
					controller.getFieldSetFields();
					System.assertEquals(true, controller.blnShowMessageError);
			Test.stopTest();
		}

		/**
		 * Prueba del metodo getShowFileURL
		 * @type void
		 */
		 @isTest static void testMethodEight() {
				 Contact contactInstance = new Contact(
						 LastName = 'LastName',
						 employeeNumber__c = '1234567'
					);
					insert contactInstance;

					Account account = new Account ();
					account.LastName='teste';
					account.RecordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cuenta personal').getRecordTypeId();
					insert account;

					Case caseInstance = new Case(
							Status = 'Nueva',
							Origin = 'Phone',
							employeeNumber__c = '11233',
							ContactId = contactInstance.Id,
							accountId=account.id
					);
					TriggerManager.inactivate('AAZ_CaseMainTrigger_tgr');
					Database.insert(caseInstance, true);

					Document__c document = new Document__c(
  						 DocumentTypeId__c = '10',
  						 RelatedProcedure__c = caseInstance.Id,
  						 FileURL__c = 'https://i.stack.imgur.com/6yyQs.png'
  				 );
  				 TriggerManager.inactivate('AAZ_CaseMainTrigger_tgr');
  				 Database.insert(document, true);

					Test.startTest();
						 AAZ_AccountDetailsFromProcedure_ctr controller = new AAZ_AccountDetailsFromProcedure_ctr(new ApexPages.StandardController(caseInstance));
						 controller.getShowFileURL();
						 System.assertNotEquals('', controller.strDocumentURL);
					Test.stopTest();
  		}

		/**
		 * Prueba para el metodo downloadFile
		 * @type void
		 */
		 @isTest static void testMethodSeven() {
				 Contact contactInstance = new Contact(
						 LastName = 'LastName',
						 employeeNumber__c = '1234567'
					);
					insert contactInstance;

					Account account = new Account ();
					account.LastName='teste';
					account.RecordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cuenta personal').getRecordTypeId();
					insert account;

					Case caseInstance = new Case(
							Status = 'Nueva',
							Origin = 'Phone',
							employeeNumber__c = '11233',
							ContactId = contactInstance.Id,
							accountId=account.id
					);
					TriggerManager.inactivate('AAZ_CaseMainTrigger_tgr');
					Database.insert(caseInstance, true);

					Test.startTest();
						 AAZ_AccountDetailsFromProcedure_ctr controller = new AAZ_AccountDetailsFromProcedure_ctr(new ApexPages.StandardController(caseInstance));
						 controller.downloadFile();
					Test.stopTest();

  		}

		/**
		 * Prueba para el metodo normalJson
		 * @type void
		 */
		@isTest static void testMethodSix() {
			 	List<Object> lstTest = new List<Object>();
				lstTest.add('Prueba');
				Test.startTest();
						String strTest = AAZ_AccountDetailsFromProcedure_ctr.normalJson(lstTest);
						System.assertNotEquals('', strTest);
				Test.stopTest();
 		}

		/**
		 * Prueba para obtener los rechazos del documento previamente guardados
		 * @type void
		 */
		 @isTest static void testMethodFive() {
 				Contact contactInstance = new Contact(
 						LastName = 'LastName',
 						employeeNumber__c = '1234567'
 				 );
 				 insert contactInstance;

 				 Account account = new Account ();
 				 account.LastName='teste';
 				 account.RecordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cuenta personal').getRecordTypeId();
 				 insert account;

 				 Case caseInstance = new Case(
 						 Status = 'Nueva',
 						 Origin = 'Phone',
 						 employeeNumber__c = '11233',
 						 ContactId = contactInstance.Id,
 						 accountId=account.id
 				 );
 				 TriggerManager.inactivate('AAZ_CaseMainTrigger_tgr');
 				 Database.insert(caseInstance, true);

 				 Document__c document = new Document__c(
 						 DocumentTypeId__c = '10',
 						 RelatedProcedure__c = caseInstance.Id,
 						 FileURL__c = 'https://i.stack.imgur.com/6yyQs.png'
 				 );
 				 TriggerManager.inactivate('AAZ_CaseMainTrigger_tgr');
 				 Database.insert(document, true);

				 ReasonRejection__c rejection= new ReasonRejection__c(
						 Name = 'Foto FOTO DEL TRABAJADOR FUE TOMADA DE LA IDE',
						 ProcedureId__c = caseInstance.Id,
						 Document__c = document.Id,
						 DigitizationID__c = '10',
						 ReasonRejectionID2__c = '999'
 				 );
 				 TriggerManager.inactivate('AAZ_CaseMainTrigger_tgr');
 				 Database.insert(rejection, true);

  			 Test.startTest();
  			 		AAZ_AccountDetailsFromProcedure_ctr controller = new AAZ_AccountDetailsFromProcedure_ctr(new ApexPages.StandardController(caseInstance));
  					System.assertEquals(1, controller.mapRejectionsReason.size());
  			 Test.stopTest();
 		}

		/**
		 * Prueba para crear la lista de rechazos por documento en caso que uno de los documentos no exista
		 * @type void
		 */
		@isTest static void testMethodFour() {
				Contact contactInstance = new Contact(
						LastName = 'LastName',
						employeeNumber__c = '1234567'
				 );
				 insert contactInstance;

				Account account = new Account ();
				account.LastName='teste';
				account.RecordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cuenta personal').getRecordTypeId();
				insert account;

				Case caseInstance = new Case(
					 Status = 'Nueva',
					 Origin = 'Phone',
					 employeeNumber__c = '11233',
					 ContactId = contactInstance.Id,
					 accountId=account.id
				);
				TriggerManager.inactivate('AAZ_CaseMainTrigger_tgr');
				Database.insert(caseInstance, true);

				Document__c document = new Document__c(
					 DocumentTypeId__c = '10',
					 RelatedProcedure__c = caseInstance.Id,
					 FileURL__c = 'https://i.stack.imgur.com/6yyQs.png'
				);
				TriggerManager.inactivate('AAZ_CaseMainTrigger_tgr');
				Database.insert(document, true);

				Test.startTest();
					AAZ_AccountDetailsFromProcedure_ctr controller = new AAZ_AccountDetailsFromProcedure_ctr(new ApexPages.StandardController(caseInstance));
					System.assertNotEquals(0, controller.mapRejectionsReason.size());
				Test.stopTest();
		}

		/**
		 * Prueba donde exista un documento con motivos de rechazo y se quiera agregar
		 * uno ya existente
		 * @type void
		 */
		 @isTest static void testMethodThree() {

 				Contact contactInstance = new Contact(
         		LastName = 'LastName',
         		employeeNumber__c = '1234567'
         );
         insert contactInstance;

         Account account = new Account ();
         account.LastName='teste';
         account.RecordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cuenta personal').getRecordTypeId();
         insert account;

         Case caseInstance = new Case(
             Status = 'Nueva',
             Origin = 'Phone',
             employeeNumber__c = '11233',
             ContactId = contactInstance.Id,
             accountId=account.id
         );
         TriggerManager.inactivate('AAZ_CaseMainTrigger_tgr');
         Database.insert(caseInstance, true);

         Document__c document = new Document__c(
             DocumentTypeId__c = '10',
             RelatedProcedure__c = caseInstance.Id,
             FileURL__c = 'https://i.stack.imgur.com/6yyQs.png'
         );
         TriggerManager.inactivate('AAZ_CaseMainTrigger_tgr');
         Database.insert(document, true);

				 ReasonRejection__c rejection= new ReasonRejection__c(
				 		Name = 'Foto FOTO DEL TRABAJADOR FUE TOMADA DE LA IDE',
						ProcedureId__c = caseInstance.Id
				 );
				 TriggerManager.inactivate('AAZ_CaseMainTrigger_tgr');
         Database.insert(rejection, true);

 				Test.startTest();
 					AAZ_AccountDetailsFromProcedure_ctr controller = new AAZ_AccountDetailsFromProcedure_ctr(new ApexPages.StandardController(caseInstance));
 							List<String> lstRejection = new List<String>();
 							lstRejection.add('1132');
 							controller.mapRejection.put('10', lstRejection);
 							controller.saveRejections();
 							controller.getFieldSetFields();
 							List<ReasonRejection__c> documentrejected = [
 									SELECT Id
 									FROM ReasonRejection__c ];
 							System.assertEquals(1, documentrejected.size());
 				Test.stopTest();
 		}

		/**
		 * Prueba donde exista documento con motivos de rechazo
		 * @type void
		 */
		@isTest static void testMethodOne() {

				Contact contactInstance = new Contact(
        		LastName = 'LastName',
        		employeeNumber__c = '1234567'
        );
        insert contactInstance;

        Account account = new Account ();
        account.LastName='teste';
        account.RecordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cuenta personal').getRecordTypeId();
        insert account;

        Case caseInstance = new Case(
            Status = 'Nueva',
            Origin = 'Phone',
            employeeNumber__c = '11233',
            ContactId = contactInstance.Id,
            accountId=account.id
        );
        TriggerManager.inactivate('AAZ_CaseMainTrigger_tgr');
        Database.insert(caseInstance, true);

        Document__c document = new Document__c(
            DocumentTypeId__c = '10',
            RelatedProcedure__c = caseInstance.Id,
            FileURL__c = 'https://i.stack.imgur.com/6yyQs.png'
        );
        TriggerManager.inactivate('AAZ_CaseMainTrigger_tgr');
        Database.insert(document, true);

				Test.startTest();
					AAZ_AccountDetailsFromProcedure_ctr controller = new AAZ_AccountDetailsFromProcedure_ctr(new ApexPages.StandardController(caseInstance));
							List<String> lstRejection = new List<String>();
							lstRejection.add('1132');
							controller.mapRejection.put('10', lstRejection);
							controller.saveRejections();
							controller.getFieldSetFields();
							List<ReasonRejection__c> documentrejected = [
									SELECT Id
									FROM ReasonRejection__c ];
							System.assertEquals(1, documentrejected.size());
				Test.stopTest();
	}

		/**
		 * Prueba donde exista documento sin motivos de rechazo
		 * @type void
		 */
		@isTest static void testMethodTwo() {

				Contact contactInstance = new Contact(
			    	LastName = 'LastName',
			    	employeeNumber__c = '1234567'
		    );
		    insert contactInstance;

		    Account account = new Account ();
		    account.LastName='teste';
		    account.RecordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cuenta personal').getRecordTypeId();
		    insert account;

		    Case caseInstance = new Case(
		        Status = 'Nueva',
		        Origin = 'Phone',
		        employeeNumber__c = '11233',
		        ContactId = contactInstance.Id,
		        accountId=account.id
		    );
		    TriggerManager.inactivate('AAZ_CaseMainTrigger_tgr');
		    Database.insert(caseInstance, true);

		    Document__c document = new Document__c(
		        DocumentTypeId__c = '10',
		        RelatedProcedure__c = caseInstance.Id,
		        FileURL__c = 'https://i.stack.imgur.com/6yyQs.png'
		    );
		    TriggerManager.inactivate('AAZ_CaseMainTrigger_tgr');
		    Database.insert(document, true);

				Test.startTest();
					AAZ_AccountDetailsFromProcedure_ctr controller = new AAZ_AccountDetailsFromProcedure_ctr(new ApexPages.StandardController(caseInstance));
		        controller.saveRejections();
		        controller.getFieldSetFields();
						List<ReasonRejection__c> documentrejected = [
								SELECT Id
								FROM ReasonRejection__c ];
						System.assertEquals(0, documentrejected.size());
				Test.stopTest();
		}
}