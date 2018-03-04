/****************************************************************************************
  Desarrollado por:  Avanxo México
  Autor:             Luis Enrique Garcia Sanabria 
  Proyecto:          Mesa de Control Afore
  Descripción:       Clase de prueba para la página de inicio
   
  Cambios (Versiones)     
  -------------------------------------     
    No.      Fecha                  Autor                      Descripción     
  ------  -------------  ------------------------------   ----------------------    
   0.1     04-08-2017    Luis Enrique Garcia Sanabria     Creacion
   0.2     04-08-2017    Luis Enrique Garcia Sanabria     Construcción
   1.0     09-08-2017    Luis Enrique Garcia Sanabria     Finalización y documentación
   1.1     02/10/2017    Flávio da Costa Pinto Junior     Correction
****************************************************************************************/
@isTest
private class AAZ_HomePage_tst {

	@testSetup static void setup() {

		Profile objUserProfile = new Profile(
			Name = 'Analista Validador'
		);

		UserRole objUserRole = new UserRole(
			Name = 'Analista Validador'
		);

		
		String strProfileId = [SELECT Id FROM Profile WHERE Name = 'Analista Validador' LIMIT 1].Id;
		String strProfileId2 = [SELECT Id FROM Profile WHERE Name = 'Administrador del sistema' LIMIT 1].Id;
		String strUserRoleId = [SELECT Id FROM UserRole WHERE Name = 'Analista Validador' LIMIT 1].Id;


		User objUser = new User (FirstName              = 'FirstName',
                              LastName                  = 'LastName',
                              Alias                     = 'testusr',
                              Email                     = 'test@avanxo.com',
                              UserName                  = 'test@avanxo.com',
                              TimeZoneSidKey            = 'America/Mexico_City',
                              LocaleSidKey              = 'es_MX',
                              EmailEncodingKey          = 'ISO-8859-1',
                              ProfileId                 = strProfileId,
                              LanguageLocaleKey         = 'es',
                              ServiceTokenPassword__c   = '123456789',
                              UserRoleId                = strUserRoleId,
                              EmployeeNumber            = '12345');
        insert objUser;
		
		User objUser2 = new User (FirstName              = 'FirstName',
                              LastName                  = 'LastName',
                              Alias                     = 'testusr',
                              Email                     = 'test2@avanxo.com',
                              UserName                  = 'test2Afo@avanxo.com',
                              TimeZoneSidKey            = 'America/Mexico_City',
                              LocaleSidKey              = 'es_MX',
                              EmailEncodingKey          = 'ISO-8859-1',
                              ProfileId                 = strProfileId2,
                              LanguageLocaleKey         = 'es',
                              ServiceTokenPassword__c   = '123456789',
                              UserRoleId                = strUserRoleId,
                              EmployeeNumber            = '12345');
        insert objUser2;

	}
	
	@isTest static void test_method_one() {
		List<Case> lst = new List<Case>();
        
        User objUser = [SELECT Id, UserRoleId FROM User LIMIT 1];

        Account objAccount = new Account (
          LastName = 'TESTE X',
          NSS__c = '210792591',
          RFC__c = 'testezxd',
          RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cuenta personal').getRecordTypeId(),
          CURP__c = '210792591'
        );
        insert objAccount;

        Case objCase = new Case(
            AccountId   = objAccount.id,
            Status      = 'Nuevo',
            Origin      = 'Phone',
            employeeNumber__c = '1234567890'
        );
        lst.add(objCase);
        insert objCase;

        Task objTask = new Task(
            WhatId     = objAccount.Id,
            description = 'test'
        );
        
        insert objTask;

        News__c objNewss = new News__c();
        objNewss.Name           = 'Test News';
        objNewss.active__c      = true;     
        objNewss.status__c      = 'Activo';
        objNewss.enddate__c     = system.today().addDays(7);
        objNewss.stardate__c    = system.today().addDays(-1);
        objNewss.priority__c    = 'Media';
        objNewss.ShareWith__c   = 'Consulta';  
        insert objNewss;
        

        PageReference pageRef = Page.AAZ_HomePage_pag;
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.standardController(objCase);
        AAZ_HomePage_ctr CONTROL = new AAZ_HomePage_ctr(sc);
        
        Test.startTest();        
	        System.runAs(objUser) {
	            List<Task> Ltask = CONTROL.getActivities();
                CONTROL.LstCase=lst;
	            CONTROL.updateCurrentLink();
                CONTROL.getIssue();
                CONTROL.indexateAccs();
                CONTROL.indexateAccsSystems();
                CONTROL.cleanIndexationCollections();
              CONTROL.updateTaskLink();
                CONTROL.intCurrentIndex= 1;
	            CONTROL.nextAccs();
	            System.assertEquals(2,CONTROL.intCurrentIndex);
	            CONTROL.previousAccs();
	            System.assertEquals(1,CONTROL.intCurrentIndex);
	        }
        Test.stopTest();
	}

	@isTest static void test_method_two() {
		User objUser2 = [SELECT Id FROM User Where UserName = 'test2Afo@avanxo.com'];
		System.runAs(objUser2){
			Group objG = new Group(
	        	Name = 'Test',
	        	Type = 'Queue'
	        );
	        insert objG;

	        Group objG2 = new Group(
	        	Name = 'Test',
	        	Type = 'Regular'
	        );
	        insert objG2;

	        GroupMember objGM = new GroupMember(
				GroupId = objG.Id,
				UserOrGroupId = objG2.Id
	        );
        	insert objGM;
		}

		User objUser = [SELECT Id, UserRoleId FROM User LIMIT 1];

        Account objAccount = new Account (
          LastName = 'TESTE X',
          NSS__c = '210792591',
          RFC__c = 'testezxd',
          RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cuenta personal').getRecordTypeId(),
          CURP__c = '210792591'
        );
        insert objAccount;

        Case objCase = new Case(
            AccountId   = objAccount.id,
            Status      = 'Nuevo',
            Origin      = 'Phone',
            employeeNumber__c = '1234567890'
        );
        insert objCase;

        Task objTask = new Task(
            WhatId     = objAccount.Id,
            description = 'test'
        );
        insert objTask;

        News__c objNewss = new News__c();
        objNewss.Name           = 'Test News';
        objNewss.active__c      = true;     
        objNewss.status__c      = 'Activo';
        objNewss.enddate__c     = system.today().addDays(7);
        objNewss.stardate__c    = system.today().addDays(-1);
        objNewss.priority__c    = 'Media';
        objNewss.ShareWith__c   = 'Consulta';  
        insert objNewss;

        PageReference pageRef = Page.AAZ_HomePage_pag;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('caseAcc',objAccount.id);
	       ApexPages.currentPage().getParameters().put('caseId',objCase.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objCase);
        AAZ_HomePage_ctr CONTROL = new AAZ_HomePage_ctr(sc);
        
        Test.startTest();        
	        System.runAs(objUser) {
	            List<Task> Ltask = CONTROL.getActivities();
	            
	        }
        Test.stopTest();
	}
    
}