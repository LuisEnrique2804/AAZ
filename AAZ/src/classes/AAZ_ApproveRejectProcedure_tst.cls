/*******************************************************************************
Desarrollado por: Avanxo México
Autor: Rodrigo Francis da Silva
Proyecto:  Afore
Descripción: Clase de prueba para AAZ_ApproveRejectProcedure_cls

------ ---------- -------------------------- -----------------------------------
No.    Fecha      Autor                      Descripción
------ ---------- -------------------------- -----------------------------------
1.0    20/09/2017 Rodrigo Francis          Clase creada
*******************************************************************************/

@isTest
private class AAZ_ApproveRejectProcedure_tst {

    @isTest
    static void getAproveRejectCase() {
    
    test.StartTest();
        List<Id> idsCaso = new List<Id>();
        for(Integer i = 0; i < 5; i++){
            Case a = new Case(employeeNumber__c = 'TestEmployee' + i,Status = 'Aprobado');
            insert a;
            idsCaso.add(a.Id);
        }
        System.debug('idsCaso' +idsCaso);
        AAZ_ApproveRejectProcedure_cls.getAproveRejectProcedureAsync(idsCaso);
    test.StopTest(); 
     
    }  

}