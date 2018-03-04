/*******************************************************************************
Desarrollado por: Avanxo México
Autor: Luis E. Garcia
Proyecto: Afore Azteca
Descripción: Clase para el borrado de insidencias en el sistema 
------ ---------- -------------------------- -----------------------------------
No.    Fecha      Autor                      Descripción
------ ---------- -------------------------- -----------------------------------
1.0    01/08/2017 Luis E. Garcia           Clase creada
*******************************************************************************/
public with sharing class AAZ_DeleteLogIntegration_cls {
	
	public static void DeleteLogIntegration(List<SystemIssue__c> lstDeleteLogs) {
		List<Database.DeleteResult> lstDR = Database.delete(lstDeleteLogs,false);
        
		if(Test.isRunningTest()){
            Integer intDeletedRows = 0;
            for(Database.DeleteResult iterator:lstDR){
                System.assert(iterator.isSuccess());
                if(iterator.isSuccess()){
                    intDeletedRows++; 
                }
            }
            System.assertEquals(intDeletedRows,2);
        }
	}
}