/*******************************************************************************
Desarrollado por: Avanxo México
Autor: William Dorado

-------------------------------------
No.    Fecha      Autor                          Descripción
------ ---------- ----------------------------- -----------
1.0    28-10-2017 william dorado               Creación
*******************************************************************************/
@isTest private class Delete_Historial_ctr_tst {
    @TestSetup static void setup() {

    List<SObject> lstSObjects = new List<SObject>();
    
        
        Case parentCase = new Case (
          Status = 'Nueva',
            Origin = 'Phone',
            employeeNumber__c = '33234',
            SubType__c = 'Subtype B'
        );

        lstSObjects.add ( parentCase );

        insert lstSObjects;

        lstSObjects = new List<SObject>();

        Case caseOne = new Case(
            Status = 'Nueva',
            Origin = 'Phone',
            employeeNumber__c = '11233',
            ParentId = parentCase.Id,
            NumberOfPrints__c = 1,
            Type =  'Afiliación',
            SubType__c = 'Traspaso'   
        );
        
        lstSObjects.add ( caseOne );

        Case caseTwo = new Case(
            Status = 'Nueva',
            Origin = 'Phone',
            employeeNumber__c = '11233',
            ParentId = parentCase.Id,
            NumberOfPrints__c = 2,
            Type =  'Retiros Parciales',
            SubType__c = 'Retiros Parciales'  
        );
        
        lstSObjects.add ( caseTwo );

        insert lstSObjects;
        
        SearchHistoricalProcess_cnf__c objConfig=new SearchHistoricalProcess_cnf__c();
        objConfig.Name='Historial';
        objConfig.SolicitudId__c='';
        objConfig.Min_Date__c=Date.Today().addDays(1);
        insert objConfig;

  }
    @isTest static void methodOne(){
                
        Test.startTest();
        
        Delete_Historial_ctr  obj=new Delete_Historial_ctr ();
        obj.Guardar();      
        

        Test.stopTest();
    }

}