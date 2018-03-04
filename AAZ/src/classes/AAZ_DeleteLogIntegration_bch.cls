/*******************************************************************************
Desarrollado por: Avanxo México
Autor: Luis E. Garcia
Proyecto: Afore Azteca
Descripción: Clase batch para el borrado de insidencias en el sistema 
------ ---------- -------------------------- -----------------------------------
No.    Fecha      Autor                      Descripción
------ ---------- -------------------------- -----------------------------------
1.0    01/08/2017 Luis E. Garcia           Clase creada
*******************************************************************************/
global class AAZ_DeleteLogIntegration_bch implements Database.Batchable<sObject> {
	
	String query;
	
	global AAZ_DeleteLogIntegration_bch(String qParam) {

		query = qParam;
		
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<sObject> scope) {

   		AAZ_DeleteLogIntegration_cls.DeleteLogIntegration(scope);

	}
	
	global void finish(Database.BatchableContext BC) {
		
	}
	
}