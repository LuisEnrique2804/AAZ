/****************************************************************************************************
    Información general
    -------------------
    author: Samuel Galindo
    email: sgalindo@avanxo.com
    company: Avanxo México
    Project: Afore
    Customer: Banco AZTECA

    Description:
    Clase de pruebas de los metodos en la clases
	* AAZ_AgentDetailsFromProcedure_ctr
    Information about changes (versions)
    ================================================================================================
    Number    Dates           Author                       Description
    ------    --------        --------------------------   -----------------------------------------
    1.2       08-Nov-2017     Samuel Galindo               Modificación
    ================================================================================================
****************************************************************************************************/

@isTest private class AAZ_AgentDetailsFromProcedure_tst {

		/**
		 * Prueba para bloquear al agente
		 * @type void
		 */
		 @isTest static void testMethodThree() {
 				Contact contactInstance = new Contact(
 					LastName = 'LastName',
 					employeeNumber__c = '1234567'
 				);
 				insert contactInstance;

 				Case caseInstance = new Case(
 						Status = 'Nueva',
 						Origin = 'Phone',
 						employeeNumber__c = '11233',
 						ContactId = contactInstance.Id
 				);
 				TriggerManager.inactivate('AAZ_CaseMainTrigger_tgr');
 				Database.insert(caseInstance, true);

 				Document__c document = new Document__c(
 						DocumentTypeId__c = '1',
 						RelatedProcedure__c = caseInstance.Id,
 						FileURL__c = 'https://i.stack.imgur.com/6yyQs.png'
 				);
 				TriggerManager.inactivate('AAZ_CaseMainTrigger_tgr');
 				Database.insert(document, true);

 				Test.startTest();
 						AAZ_AgentDetailsFromProcedure_ctr controller = new AAZ_AgentDetailsFromProcedure_ctr(new ApexPages.StandardController(caseInstance));
							controller.getFieldSetFields();
  						controller.LockUnlockAP2();
							System.assertEquals(true, controller.blnAgenLockUnlock);
 				Test.stopTest();
 		}

		/**
		 * Prueba para saber si es un AP(Agente Promotor)
		 * @type void
		 */
		 @isTest static void testMethodTwo() {

 				Contact contactInstance = new Contact(
 					LastName = 'LastName',
 					employeeNumber__c = '1234567'
 				);
 				insert contactInstance;

 				Case caseInstance = new Case(
 						Status = 'Nueva',
 						Origin = 'Phone',
 						employeeNumber__c = '11233',
						AP__c = contactInstance.Id
 				);
 				TriggerManager.inactivate('AAZ_CaseMainTrigger_tgr');
 				Database.insert(caseInstance, true);

 				Document__c document = new Document__c(
 						DocumentTypeId__c = '1',
 						RelatedProcedure__c = caseInstance.Id,
 						FileURL__c = 'https://i.stack.imgur.com/6yyQs.png'
 				);
 				TriggerManager.inactivate('AAZ_CaseMainTrigger_tgr');
 				Database.insert(document, true);

 				Test.startTest();
 						AAZ_AgentDetailsFromProcedure_ctr controller = new AAZ_AgentDetailsFromProcedure_ctr(new ApexPages.StandardController(caseInstance));
						System.assertEquals(true, controller.isItValidToStart);
 				Test.stopTest();
 		}

		/**
			* Prueba para los métodos de la clase
			* @type void
			*/
		@isTest static void testMethodOne() {
				Contact contactInstance = new Contact(
					LastName = 'LastName',
					employeeNumber__c = '1234567'
				);
				insert contactInstance;

				Case thisCase = new Case (
						Status = 'Nueva',
						Origin = 'Phone',
						employeeNumber__c = '11234'
				);
				insert thisCase;

				Case caseInstance = new Case(
						Status = 'Nueva',
						Origin = 'Phone',
						employeeNumber__c = '11233',
						ContactId = contactInstance.Id,
						ParentId = thisCase.Id
				);
				TriggerManager.inactivate('AAZ_CaseMainTrigger_tgr');
				Database.insert(caseInstance, true);

				Document__c document = new Document__c(
						DocumentTypeId__c = '1',
						RelatedProcedure__c = caseInstance.Id,
						FileURL__c = 'https://i.stack.imgur.com/6yyQs.png'
				);
				TriggerManager.inactivate('AAZ_CaseMainTrigger_tgr');
				Database.insert(document, true);

				Test.startTest();
						AAZ_AgentDetailsFromProcedure_ctr controller = new AAZ_AgentDetailsFromProcedure_ctr(new ApexPages.StandardController(caseInstance));
						controller.getFieldSetFields();
						controller.LockUnlockAP2();
				Test.stopTest();
		}
}