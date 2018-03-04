/*******************************************************************************
Desarrollado por: Avanxo México
Autor: Luis E. Garcia
Proyecto: Afore Azteca
Descripción: Clase schedule para el borrado de insidencias en el sistema cada 15 dias
------ ---------- -------------------------- -----------------------------------
No.    Fecha      Autor                      Descripción
------ ---------- -------------------------- -----------------------------------
1.0    01/08/2017 Luis E. Garcia           Clase creada
*******************************************************************************/
global class AAZ_DeleteLogIntegration_sch implements Schedulable {
	global void execute(SchedulableContext sc) {
        Datetime dtmFilterdays = system.now().addDays(-7);
		String strQueryOverLogs = Test.isRunningTest() ? 'SELECT Id FROM SystemIssue__c': 'SELECT Id FROM SystemIssue__c where CreatedDate  <='+String.valueOf(dtmFilterdays);
        System.debug(loggingLevel.Error, '*** strQueryOverLogs: ' + strQueryOverLogs);
        AAZ_DeleteLogIntegration_bch bInstance = new AAZ_DeleteLogIntegration_bch(strQueryOverLogs);
        Database.executeBatch(bInstance,200);
	}
}