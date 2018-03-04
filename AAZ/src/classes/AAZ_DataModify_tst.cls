/*******************************************************************************
Desarrollado por: Avanxo México
Autor: Iván Neria
Proyecto: Afore Azteca
Descripción: Clase test para el controlador AAZ_DataModify_ctr

-------------------------------------
No.    Fecha      Autor                          Descripción
------ ---------- ----------------------------- -----------
1.0    09-11-2017 Iván Neria					 Creacion
*******************************************************************************/
@isTest public class AAZ_DataModify_tst {
    @isTest static void setup(){
	Case caseInstance = new Case(
					Status = 'Nueva',
					Origin = 'Phone',
					employeeNumber__c = '11233'
			);
			insert caseInstance; 
        Account accountInstance = new Account (
        LastName ='TestName',
		RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cuenta personal').getRecordTypeId(),
		Type = 'Analyst'
        );
        insert accountInstance;
        
        test.startTest();
        AAZ_DataModify_ctr controller = new AAZ_DataModify_ctr(new ApexPages.StandardController(caseInstance));
        controller.getFieldSetFieldsAcc();
        controller.getFieldSetFieldsCase();
        controller.accountInstance=accountInstance;
        test.stopTest();
    }

}