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
	* AAZ_SubsidiaryClient_cls
    Information about changes (versions)
    ================================================================================================
    Number    Dates           Author                       Description
    ------    --------        --------------------------   -----------------------------------------
    1.0       08-Nov-2017     Samuel Galindo               Creación de la Clase
    ================================================================================================
****************************************************************************************************/
@isTest private class AAZ_SubsidiaryClient_tst {

	/**
	 * Prueba del método getSubsidiaryAsync
	 */
	@isTest static void testMethodOne() {
			Contact contactInstance = new Contact(
					FirstName = 'SERVANDO',
					LastName = 'JIMENEZ LOPEZ',
					EmployeeNumber__c = '1234',
					SucursalNumber__c = 54
			);
			Database.insert(contactInstance, true);

			Account account = new Account(
					CURP__c = 'DIRA640508HTCZDN00',
					FirstName = 'JOSE ANGEL',
					LastName = 'DIAZ RODRIGUEZ',
					NSS__c = '83856405523',
					RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cuenta personal').getRecordTypeId()
			);
			Database.insert(account, true);

			Case caseInstance = new Case(
					Status = 'Nueva',
					Origin = 'Phone',
					Type   = 'AFILIACION',
					SubType__c = 'REGISTRO',
					ContactId = contactInstance.Id,
					FolioNSS__c = 'GARR486756'
			);
			TriggerManager.inactivate('AAZ_CaseMainTrigger_tgr');
			Database.insert(caseInstance,true);

			List<Case> lstCaseInstance = [
					SELECT Id
					FROM Case
			];

			Test.startTest();
					List<Id> lstCaseIds = new List<Id>();

					for (Case iterator : lstCaseInstance) {
							lstCaseIds.add(iterator.Id);
					}
					AAZ_SubsidiaryClient_cls.getSubsidiaryAsync(lstCaseIds);
			Test.stopTest();
	}
}