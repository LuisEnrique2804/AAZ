/*******************************************************************************
Desarrollado por: Avanxo México
Autor: Rodrigo Francis da Silva
Proyecto:  Afore
Descripción: Clase de prueba para AAZ_ApproveRejectProcedure_cls

------ ---------- -------------------------- -----------------------------------
No.    Fecha      Autor                      Descripción
------ ---------- -------------------------- -----------------------------------
1.0    21/09/2017 Rodrigo Francis          Clase creada
*******************************************************************************/
@isTest
private class AAZ_BeneficiariesClient_tst{

   @isTest
    static void mytest() {
     //AppMainSetting_cs__c mainSettings = AAZ_TestUtils_tst.getMainSettings();
     //insert mainSettings;      
    
     User usr = AAZ_TestUtils_tst.createUser('Administrador del sistema','txddd@xxxc.com',null);
     insert usr;
         
     //String STR_CONFNAME = 'Afore_QueryBeneficiary';  
     //AAZ_GenericCallout_cls.intTestMode = 7 ;
    // AAZ_GenericCallout_cls.strTestConfigName = STR_CONFNAME;
     //EndpointSetting__mdt objEndpointSetting = AAZ_Utils_cls.getEndpointSetting(STR_CONFNAME);
     
     System.runAs(usr){  
    	 /*Map<String,Object> mapExtraAtts = new Map<String,Object>{
                'system'=>'SFDC',
                'operation'=>'Mesa_Control'
            };*/
         //Map<String, Object> mapExtraAtts = new Map<String, Object>();   
    	 //Map<String,String> mapExtraHeaders = new Map<String,String>();
    	 /*Map<String,String> mapExtraHeaders = new Map<String,String>{
                'Content-Type' => 'text/plain',
                'Cache-Control' => 'no-caché'
            };*/

     	 List<Id> idsCaso = new List<Id>();

    	 Account ac = new Account();
       		ac.LastName = 'TESTE X';
        	ac.NSS__c = '210792591';
        	ac.RFC__c = 'testezxd';
        	ac.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cuenta personal').getRecordTypeId();
        	insert ac;
     
     	Contact ca = new Contact();
        	ca.FirstName = 'Contact1';
        	ca.LastName = 'Brasil';
        	//ca.AccountId = ac.Id;
        	ca.EmployeeNumber__c = 'testexxd';
        	insert ca;

    	 Case a = new Case(ContactId = ca.Id, AccountId = ac.Id, employeeNumber__c = 'TesctEmplZX',Status = 'Aprobado',FolioNSS__c = '689751',idServiceType__c='3');
      		insert a;
  
     	idsCaso.add(a.Id);    

        test.startTest();
        //Map<String, Object> requestMap = AAZ_GenericCallout_cls.generateRequestMap(STR_CONFNAME, new List<SObject>{a}, mapExtraAtts);
        //String strResponse = AAZ_GenericCallout_cls.fn_runCallout(JSON.serializePretty(requestMap), STR_CONFNAME, mapExtraHeaders);
        //Map<String,Object> mapResponse = AAZ_GenericCallout_cls.processServiceResponse(strResponse,STR_CONFNAME);
        AAZ_BeneficiariesClient_cls.getBeneficiariesAsync(idsCaso);
        
        test.StopTest(); 
	  } 
      
    }
}