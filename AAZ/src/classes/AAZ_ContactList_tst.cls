/*******************************************************************************
Desarrollado por: Avanxo México
Autor: Samuel Galindo Rodríguez
Proyecto: Afore Azteca
Descripción: Clase de pruebas de la clase AAZ_ContactList_ctr

-------------------------------------
No.    Fecha      Autor                          Descripción
------ ---------- ----------------------------- -----------
1.0    30-10-2017 Samuel Galindo Rodríguez      Creación
*******************************************************************************/

@isTest
private class AAZ_ContactList_tst {

    /**
     * Prueba donde hay trámite(Casos) asignado al contacto
     * @type void
     */
    @isTest static void testAsignadoTramite() {
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

        Contact contactInstance1 = new Contact(
            FirstName = 'SERVANDO',
            LastName = 'JIMENEZ LOPEZ'
        );

        Contact contactInstance2 = new Contact(
            FirstName = 'ALAN JESUS',
            LastName = 'SANCHEZ PEREZ'
        );

        TriggerManager.inactivate('AAZ_CaseMainTrigger_tgr');
        Database.insert(contactInstance1, true);

        TriggerManager.inactivate('AAZ_CaseMainTrigger_tgr');
        Database.insert(contactInstance2, true);

        Case caseInstance = new Case(
            applicationRegistrationQ__c = false,
            BusinessHoursId = '01mf400000001ytAAA',
            CallMade__c	= false,
            clientAudioQ__c = false,
            completeDocs__c = false,
            ContactId = contactInstance2.Id,
            contractQ__c = false,
            digitalSignatureQ__c = false,
            employeeNumber__c = '171232',
            FolioNSS__c= '201710100000008914',
            fotoQ__c = false,
            hadBeenProcecesd__c = false,
            Historical__c = false,
            idServiceType__c = '47',
            IFEQ__c = false,
            ImpactProcedure__c = false,
            IRNQ__c = false,
            isApproved__c = false,
            IsEscalated = false,
            IsPosibleReverse__c = false,
            isReversed__c = false,
            IsUpdateC__c = false,
            IsUpdate__c = false,
            LockGenerated__c = false,
            NumberOfPrints__c =	1.0,
            Origin =	'M',
            PendingRegister__c	= false,
            PendingTime__c	= 0.0,
            procedureIsBeneficary__c	= false,
            processFingerIssue__c	= false,
            proofAddressQ__c	= false,
            RegionalName__c =	'GUADALUPE ARROYO ORDOÑEZ',
            requestConstancyQ__c =	false,
            Status =	'PENDIENTE POR DOCUMENTO',
            Subject =	'201710100000008914 - -',
            SubType__c =	'MODIFICACION',
            sucursalEconomicNumber__c =	'2024',
            sucursalName__c =	'BA MEGA SAN ANGEL',
            Type =	'MODIFICACION DE DATOS'
        );

        TriggerManager.inactivate('AAZ_CaseMainTrigger_tgr');
        insert userForTesting;

        System.runAs(userForTesting){

            TriggerManager.inactivate('AAZ_CaseMainTrigger_tgr');
            Database.insert(caseInstance, true);

            Test.startTest();
                AAZ_ContactList_ctr controller =
                    new AAZ_ContactList_ctr(
                        new ApexPages.StandardController(contactInstance2)
                );

                System.assertEquals(
                    controller.lstCase.size(),
                    1
                );
            Test.stopTest();
        }
    }

    /**
     * Prueba donde hay trámite(Casos) pero es del tipo queja asignado al contacto
     * @type void
     */
    @isTest static void testAsignadoQueja() {
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

        Contact contactInstance1 = new Contact(
            FirstName = 'SERVANDO',
            LastName = 'JIMENEZ LOPEZ'
        );

        Contact contactInstance2 = new Contact(
            FirstName = 'ALAN JESUS',
            LastName = 'SANCHEZ PEREZ'
        );

        TriggerManager.inactivate('AAZ_CaseMainTrigger_tgr');
        Database.insert(contactInstance1, true);

        TriggerManager.inactivate('AAZ_CaseMainTrigger_tgr');
        Database.insert(contactInstance2, true);

        Case caseInstance = new Case(
            applicationRegistrationQ__c = false,
            BusinessHoursId = '01mf400000001ytAAA',
            CallMade__c	= false,
            clientAudioQ__c = false,
            complaintsAndTrades__c = contactInstance1.Id,
            completeDocs__c = false,
            ContactId = contactInstance2.Id,
            contractQ__c = false,
            digitalSignatureQ__c = false,
            employeeNumber__c = '171232',
            FolioNSS__c= '201710100000008914',
            fotoQ__c = false,
            hadBeenProcecesd__c = false,
            Historical__c = false,
            idServiceType__c = '47',
            IFEQ__c = false,
            ImpactProcedure__c = false,
            IRNQ__c = false,
            isApproved__c = false,
            IsEscalated = false,
            IsPosibleReverse__c = false,
            isReversed__c = false,
            IsUpdateC__c = false,
            IsUpdate__c = false,
            LockGenerated__c = false,
            NumberOfPrints__c =	1.0,
            Origin =	'M',
            PendingRegister__c	= false,
            PendingTime__c	= 0.0,
            procedureIsBeneficary__c	= false,
            processFingerIssue__c	= false,
            proofAddressQ__c	= false,
            RegionalName__c =	'GUADALUPE ARROYO ORDOÑEZ',
            requestConstancyQ__c =	false,
            Status =	'PENDIENTE POR DOCUMENTO',
            Subject =	'201710100000008914 - -',
            SubType__c =	'MODIFICACION',
            sucursalEconomicNumber__c =	'2024',
            sucursalName__c =	'BA MEGA SAN ANGEL',
            Type =	'MODIFICACION DE DATOS'
        );

        TriggerManager.inactivate('AAZ_CaseMainTrigger_tgr');
        insert userForTesting;

        System.runAs(userForTesting){

            TriggerManager.inactivate('AAZ_CaseMainTrigger_tgr');
            Database.insert(caseInstance, true);

            Test.startTest();
                AAZ_ContactList_ctr controller =
                    new AAZ_ContactList_ctr(
                        new ApexPages.StandardController(contactInstance2)
                );

                System.assertNotEquals(
                    controller.lstCase.size(),
                    1
                );
            Test.stopTest();
        }
    }

    /**
     * Prueba donde hay trámite(Casos) pero no asignado al contacto
     * @type void
     */
    @isTest static void testNoAsignado() {
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

        Contact contactInstance1 = new Contact(
            FirstName = 'SERVANDO',
            LastName = 'JIMENEZ LOPEZ'
        );

        Contact contactInstance2 = new Contact(
            FirstName = 'ALAN JESUS',
            LastName = 'SANCHEZ PEREZ'
        );

        TriggerManager.inactivate('AAZ_CaseMainTrigger_tgr');
        Database.insert(contactInstance1, true);

        TriggerManager.inactivate('AAZ_CaseMainTrigger_tgr');
        Database.insert(contactInstance2, true);

        Case caseInstance = new Case(
            applicationRegistrationQ__c = false,
            BusinessHoursId = '01mf400000001ytAAA',
            CallMade__c	= false,
            clientAudioQ__c = false,
            completeDocs__c = false,
            ContactId = contactInstance1.Id,
            contractQ__c = false,
            digitalSignatureQ__c = false,
            employeeNumber__c = '171232',
            FolioNSS__c= '201710100000008914',
            fotoQ__c = false,
            hadBeenProcecesd__c = false,
            Historical__c = false,
            idServiceType__c = '47',
            IFEQ__c = false,
            ImpactProcedure__c = false,
            IRNQ__c = false,
            isApproved__c = false,
            IsEscalated = false,
            IsPosibleReverse__c = false,
            isReversed__c = false,
            IsUpdateC__c = false,
            IsUpdate__c = false,
            LockGenerated__c = false,
            NumberOfPrints__c =	1.0,
            Origin =	'M',
            PendingRegister__c	= false,
            PendingTime__c	= 0.0,
            procedureIsBeneficary__c	= false,
            processFingerIssue__c	= false,
            proofAddressQ__c	= false,
            RegionalName__c =	'GUADALUPE ARROYO ORDOÑEZ',
            requestConstancyQ__c =	false,
            Status =	'PENDIENTE POR DOCUMENTO',
            Subject =	'201710100000008914 - -',
            SubType__c =	'MODIFICACION',
            sucursalEconomicNumber__c =	'2024',
            sucursalName__c =	'BA MEGA SAN ANGEL',
            Type =	'MODIFICACION DE DATOS'
        );

        TriggerManager.inactivate('AAZ_CaseMainTrigger_tgr');
        insert userForTesting;

        System.runAs(userForTesting){

            TriggerManager.inactivate('AAZ_CaseMainTrigger_tgr');
            Database.insert(caseInstance, true);

            Test.startTest();
                AAZ_ContactList_ctr controller =
                    new AAZ_ContactList_ctr(
                        new ApexPages.StandardController(contactInstance2)
                );

                System.assertEquals(
                    controller.lstCase.size(),
                    0
                );
            Test.stopTest();
        }
    }
}