/*******************************************************************************
Desarrollado por: Avanxo México
Autor: Luis E. Garcia
Proyecto: Afore Azteca
Descripción: Clase de prueba para el borrado de insidencias en el sistema 
------ ---------- -------------------------- -----------------------------------
No.    Fecha      Autor                      Descripción
------ ---------- -------------------------- -----------------------------------
1.0    01/08/2017 Luis E. Garcia           Clase creada
*******************************************************************************/
@isTest
private class AAZ_DeleteLogIntegration_tst {
	
	@testSetup static void init(){

		List<SystemIssue__c> lstIssues = new List<SystemIssue__c>{
			new SystemIssue__c(
				Type__c = 'Otro',
				Message__c = 'Invalid type'
			),
			new SystemIssue__c(
				Type__c = 'Otro',
				Message__c = 'invalid type'
			)
		};
		Database.insert(lstIssues,true);
	}

	@isTest static void shouldSchedule(){
		Test.startTest();
			AAZ_DeleteLogIntegration_sch scheduleInstance = new AAZ_DeleteLogIntegration_sch();
			String strChronExpresion = '0 0 0 15 * ? ';
			System.schedule('DeleteCustomAlertTestSchedule',strChronExpresion,scheduleInstance);
		Test.stopTest();
	}
	
}