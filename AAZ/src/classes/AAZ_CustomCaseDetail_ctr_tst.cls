/****************************************************************************************************
    Información general
    -------------------
    author: Iván Neria
    email: ineria@avanxo.com
    company: Avanxo México
    Project: Afore
    Customer: Banco AZTECA
    
    Description:
    Clase de pruebas de los metodos en la clases 
	* AAZ_CustomCaseDetail_ctr
	* AAZ_DataModify_ctr
    Information about changes (versions)
    ================================================================================================
    Number    Dates           Author                       Description
    ------    --------        --------------------------   -----------------------------------------
    1.0       25-Sep-2017     Iván Neria                  Creación de la Clase
	1.1		  09-Oct-2017	  Iván Neria				  Actualización de nuevos metodos agregados 
														  a la clase principal.
    ================================================================================================
****************************************************************************************************/
@isTest 
private class AAZ_CustomCaseDetail_ctr_tst {
 
		@isTest static void getFieldSetFieldsTst(){
     Case Cs = new Case();
            Cs.employeeNumber__c = 'TestEmployee';
            Cs.Type = 'Question';
            
            insert Cs;
            test.StartTest();
            	AAZ_CustomCaseDetail_ctr Run = new AAZ_CustomCaseDetail_ctr(new ApexPages.StandardController(Cs));
        		List<Schema.FieldSetMember> LstFs = Run.getFieldSetFields();
            	AAZ_DataModify_ctr DataRun = new AAZ_DataModify_ctr(new ApexPages.StandardController(Cs));
            	List<Schema.FieldSetMember> LtFs = DataRun.getFieldSetFieldsAcc();
            List<Schema.FieldSetMember> LtFts = DataRun.getFieldSetFieldsCase();
            
    		test.StopTest();
        
    }
}