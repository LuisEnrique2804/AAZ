/*******************************************************************************
Desarrollado por: Avanxo México
Autor: Iván Neria
Proyecto: Afore Azteca
Descripción: Clase test para la clase AAZ_AccountComplaints_ctr
-------------------------------------
No.    Fecha      Autor                          Descripción
------ ---------- ----------------------------- -----------
1.0    28-10-2017 Iván Neria 				             Creación
2.0    03-11-2017 Samuel Galindo                 Modificación
*******************************************************************************/
@isTest
private class AAZ_AccountComplaints_tst {

    /**
     * Prueba donde hay una queja asignada a la cuenta
     * @type void
     */
    @isTest static void methodTwo(){

        String  profileName = Label.AAZ_AdministratorProfile; // Colocar en Etiqueta Personalizada
        Profile profileInstance =	[
            SELECT Id
            FROM Profile
            WHERE Name =:profileName limit 1
        ];

        User userForTesting = new User(
            Alias = 'user0t', Email='user0@aforetestemail.com',
            FirstName = 'test0', EmailEncodingKey='UTF-8',
            LastName='Testing0', LanguageLocaleKey='es',
            LocaleSidKey='es_MX', ProfileId = profileInstance.Id,
            TimeZoneSidKey='America/Mexico_City',
            UserName='testuser0@aforeazteca.com',
            EmployeeNumber='654355',
            ServiceTokenPassword__c = 'pzx/yy82c469vRYmXiYtP+NtqCVCSvGm+zQEWpyMO7ONgFMH6Lg0RJfGopcM6PEs'
        );
        TriggerManager.inactivate('AAZ_CaseMainTrigger_tgr');
        insert userForTesting;

        System.runAs(userForTesting){

            Contact contactInstance1 = new Contact(
                FirstName = 'SERVANDO',
                LastName = 'JIMENEZ LOPEZ'
            );
            TriggerManager.inactivate('AAZ_CaseMainTrigger_tgr');
            Database.insert(contactInstance1, true);

            Account account1 = new Account(
                CURP__c = 'DIRA640508HTCZDN00',
                FirstName = 'JOSE ANGEL',
                LastName = 'DIAZ RODRIGUEZ',
                RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cuenta personal').getRecordTypeId(),
                NSS__c = '83856405523'
            );
            TriggerManager.inactivate('AAZ_CaseMainTrigger_tgr');
            Database.insert(account1, true);

            Case parentCase = new Case (
                AccountId = account1.Id,
                FolioNSS__c= '201710100000008914',
                complaintsAndTrades__c = contactInstance1.Id,
                Status = 'Nueva',
                Origin = 'Phone',
                Type =	'MODIFICACION DE DATOS',
                employeeNumber__c = '33234',
                SubType__c = 'Subtype B'
            );
            TriggerManager.inactivate('AAZ_CaseMainTrigger_tgr');
            Database.insert(parentCase, true);

            Test.startTest();
                AAZ_AccountComplaints_ctr controller =
                    new AAZ_AccountComplaints_ctr(
                        new ApexPages.StandardController(account1)
                );

                System.assertEquals(
                    controller.lstCase.size(),
                    1
                );
            Test.stopTest();
        }
    }

    /**
     * Prueba donde hay un Caso pero no es del tipo queja
     * @type void
     */
    @isTest static void methodOne(){

        String  profileName = Label.AAZ_AdministratorProfile; // Colocar en Etiqueta Personalizada
        Profile profileInstance =	[
            SELECT Id
            FROM Profile
            WHERE Name =:profileName limit 1
        ];

        User userForTesting = new User(
            Alias = 'user0t', Email='user0@aforetestemail.com',
            FirstName = 'test0', EmailEncodingKey='UTF-8',
            LastName='Testing0', LanguageLocaleKey='es',
            LocaleSidKey='es_MX', ProfileId = profileInstance.Id,
            TimeZoneSidKey='America/Mexico_City',
            UserName='testuser0@aforeazteca.com',
            EmployeeNumber='654355',
            ServiceTokenPassword__c = 'pzx/yy82c469vRYmXiYtP+NtqCVCSvGm+zQEWpyMO7ONgFMH6Lg0RJfGopcM6PEs'
        );
        TriggerManager.inactivate('AAZ_CaseMainTrigger_tgr');
        insert userForTesting;

        System.runAs(userForTesting){

            Account account1 = new Account(
                CURP__c = 'DIRA640508HTCZDN00',
                FirstName = 'JOSE ANGEL',
                LastName = 'DIAZ RODRIGUEZ',
                RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cuenta personal').getRecordTypeId(),
                NSS__c = '83856405523'
            );
            TriggerManager.inactivate('AAZ_CaseMainTrigger_tgr');
            Database.insert(account1, true);
    
            Case parentCase = new Case (
                AccountId = account1.Id,
                FolioNSS__c= '201710100000008914',
                Status = 'Nueva',
                Origin = 'Phone',
                Type =	'MODIFICACION DE DATOS',
                employeeNumber__c = '33234',
                SubType__c = 'Subtype B'
            );
            TriggerManager.inactivate('AAZ_CaseMainTrigger_tgr');
            Database.insert(parentCase, true);

            Test.startTest();
                AAZ_AccountComplaints_ctr controller =
                    new AAZ_AccountComplaints_ctr(
                        new ApexPages.StandardController(account1)
                );

                System.assertEquals(
                    controller.lstCase.size(),
                    0
                );
            Test.stopTest();
        }
    }

    /**
     * Prueba donde hay una queja pero no asignado a la cuenta
     * @type void
     */
    @isTest static void methodThree(){

        String  profileName = Label.AAZ_AdministratorProfile; // Colocar en Etiqueta Personalizada
        Profile profileInstance =	[
            SELECT Id
            FROM Profile
            WHERE Name =:profileName limit 1
        ];

        User userForTesting = new User(
            Alias = 'user0t', Email='user0@aforetestemail.com',
            FirstName = 'test0', EmailEncodingKey='UTF-8',
            LastName='Testing0', LanguageLocaleKey='es',
            LocaleSidKey='es_MX', ProfileId = profileInstance.Id,
            TimeZoneSidKey='America/Mexico_City',
            UserName='testuser0@aforeazteca.com',
            EmployeeNumber='654355',
            ServiceTokenPassword__c = 'pzx/yy82c469vRYmXiYtP+NtqCVCSvGm+zQEWpyMO7ONgFMH6Lg0RJfGopcM6PEs'
        );
        TriggerManager.inactivate('AAZ_CaseMainTrigger_tgr');
        insert userForTesting;

        System.runAs(userForTesting){

            Contact contactInstance1 = new Contact(
                FirstName = 'SERVANDO',
                LastName = 'JIMENEZ LOPEZ'
            );
            TriggerManager.inactivate('AAZ_CaseMainTrigger_tgr');
            Database.insert(contactInstance1, true);
    
            Account account1 = new Account(
                CURP__c = 'DIRA640508HTCZDN00',
                FirstName = 'JOSE ANGEL',
                LastName = 'DIAZ RODRIGUEZ',
                RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cuenta personal').getRecordTypeId(),
                NSS__c = '83856405523'
            );
            TriggerManager.inactivate('AAZ_CaseMainTrigger_tgr');
            Database.insert(account1, true);
    
            Account account2 = new Account(
                CURP__c = 'EIPP490215HMCLRD08',
                FirstName = 'PEDRO',
                LastName = 'ELIZALDE PEREZ',
                RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cuenta personal').getRecordTypeId(),
                NSS__c = '11684997684'
            );
            TriggerManager.inactivate('AAZ_CaseMainTrigger_tgr');
            Database.insert(account2, true);
    
            Case parentCase = new Case (
                AccountId = account2.Id,
                FolioNSS__c= '201710100000008914',
                complaintsAndTrades__c = contactInstance1.Id,
                Status = 'Nueva',
                Origin = 'Phone',
                Type =	'MODIFICACION DE DATOS',
                employeeNumber__c = '33234',
                SubType__c = 'Subtype B'
            );
			TriggerManager.inactivate('AAZ_CaseMainTrigger_tgr');
            Database.insert(parentCase, true);

            Test.startTest();
                AAZ_AccountComplaints_ctr controller =
                    new AAZ_AccountComplaints_ctr(
                        new ApexPages.StandardController(account1)
                );

                System.assertEquals(
                    controller.lstCase.size(),
                    0
                );
            Test.stopTest();
        }
    }

}