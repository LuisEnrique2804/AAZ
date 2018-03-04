/*******************************************************************************
Desarrollado por: Avanxo México
Autor: Samuel Galindo Rodríguez
Proyecto: Afore Azteca
Descripción: Clase de pruebas de la clase AAZ_DocumentIdentification_ctr

-------------------------------------
No.    Fecha      Autor                          Descripción
------ ---------- -----------------------------  -----------
1.2    30-10-2017 Samuel Galindo Rodríguez       Modificación
*******************************************************************************/

@isTest
private class AAZ_DocumentIdentification_tst {

    /**
     * Prueba para la descarga de los archivos
     * @type void
     */
     @isTest static void testDownloadFile() {
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
             Case caseInstance = new Case(
                 Status = 'Nueva',
                 Origin = 'Phone'
             );
             TriggerManager.inactivate('AAZ_CaseMainTrigger_tgr');
             Database.insert(caseInstance, true);

             Document__c document = new Document__c(
                 DocumentTypeId__c = '1',
                 RelatedProcedure__c = caseInstance.Id,
                 FileURL__c = 'https://i.stack.imgur.com/6yyQs.png'
             );
             TriggerManager.inactivate('AAZ_CaseMainTrigger_tgr');
             Database.insert(document, true);

             Test.startTest();
                 Test.setMock(HttpCalloutMock.class, new SingleRequestMock( 'StringToBlob', false, 200, 'Ok'));

                 AAZ_DocumentIdentification_ctr controller =
                     new AAZ_DocumentIdentification_ctr(
                     new ApexPages.StandardController(caseInstance)
                 );
                 controller.strDigitalizationNumber='1';
                 controller.downloadFile();
                 System.assertNotEquals( '', controller.strDigitalizationFile);
             Test.stopTest();
         }
     }

    /**
     * Prueba para la excepcion al guardar los motivos de rechazo
     * @type void
     */
     @isTest static void testExceptionRejection() {
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
             Case caseInstance = new Case(
                 Status = 'Nueva',
                 Origin = 'Phone'
             );
             TriggerManager.inactivate('AAZ_CaseMainTrigger_tgr');
             Database.insert(caseInstance, true);

             Document__c document = new Document__c(
                 DocumentTypeId__c = '1',
                 RelatedProcedure__c = caseInstance.Id,
                 FileURL__c = 'https://i.stack.imgur.com/6yyQs.png'
             );
             TriggerManager.inactivate('AAZ_CaseMainTrigger_tgr');
             Database.insert(document, true);

             Test.startTest();

                 AAZ_DocumentIdentification_ctr controller =
                     new AAZ_DocumentIdentification_ctr(
                     new ApexPages.StandardController(caseInstance)
                 );

                 controller.strListValues = '1,5,2';
                 controller.intCurrentIndex = 1;
                 ReasonRejection__c objTest = new ReasonRejection__c();
                 controller.lstInsertReasonRejection.add(objTest);
                 controller.saveRejections();
                 System.assertEquals(false, controller.blnShowMessageError);
             Test.stopTest();
         }
     }

    /**
     * Prueba para guardar los motivos de rechazo por documento
     * @type void
     */
    @isTest static void testRejectionDocSaved() {
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
            Case caseInstance = new Case(
                Status = 'Nueva',
                Origin = 'Phone'
            );
            TriggerManager.inactivate('AAZ_CaseMainTrigger_tgr');
            Database.insert(caseInstance, true);

            Document__c document = new Document__c(
                DocumentTypeId__c = '1',
                RelatedProcedure__c = caseInstance.Id,
                FileURL__c = 'https://i.stack.imgur.com/6yyQs.png'
            );
            TriggerManager.inactivate('AAZ_CaseMainTrigger_tgr');
            Database.insert(document, true);

            Test.startTest();

                AAZ_DocumentIdentification_ctr controller =
                    new AAZ_DocumentIdentification_ctr(
                    new ApexPages.StandardController(caseInstance)
                );

                controller.strListValues = '1,5,2';
                controller.intCurrentIndex = 1;
                controller.saveRejections();

                List<ReasonRejection__c> lstRejections = [
                    SELECT Id
                    FROM ReasonRejection__c
                ];
                System.assertEquals(1, lstRejections.size());
            Test.stopTest();
        }
    }

    /**
     * Prueba en caso que existan motivos de rechazo por documento
     * @type void
     */
    @isTest static void testRejectionReasonProcedure() {
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
            Case caseInstance = new Case(
                Status = 'Nueva',
                Origin = 'Phone',
                employeeNumber__c= '1234'
            );
            TriggerManager.inactivate('AAZ_CaseMainTrigger_tgr');
            Database.insert(caseInstance, true);

            Document__c document = new Document__c(
                DocumentTypeId__c = '1',
                RelatedProcedure__c = caseInstance.Id,
                FileURL__c = 'https://i.stack.imgur.com/6yyQs.png'
            );
            TriggerManager.inactivate('AAZ_CaseMainTrigger_tgr');
            Database.insert(document, true);

            ReasonRejection__c rejectionprocedure = new ReasonRejection__c(
                DocumentIndex__c = 1,
                ReasonRejectionID2__c = '5',
                Name = 'Identificación No Corresponde',
                Document__c = document.Id,
                ProcedureId__c = caseInstance.Id
            );

            TriggerManager.inactivate('AAZ_CaseMainTrigger_tgr');
            Database.insert(rejectionprocedure, true);

            Integer intCurrentIndex = 1;

            List<ReasonRejection__c> lstReasonRejection = [
                SELECT Id
                FROM ReasonRejection__c
                WHERE Document__c = :document.Id
            ];

            PageReference pageRef = Page.AAZ_DocumentIdentification_pag;
            Test.setCurrentPage(pageRef);

            Test.startTest();
            ApexPages.currentPage().getParameters().put('strListValues',rejectionprocedure.Name);
                AAZ_DocumentIdentification_ctr controller =
                    new AAZ_DocumentIdentification_ctr(
                    new ApexPages.StandardController(caseInstance)
                );
                System.assertEquals(
                    lstReasonRejection.size(),
                    controller.mapRejection.get(intCurrentIndex).size()
                );
            Test.stopTest();
        }
    }

    /**
     * Prueba en caso que no existan motivos de rechazo por documento
     * @type void
     */
    @isTest static void testNoRejectionReasonProcedure() {
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
            Case caseInstance = new Case(
                Status = 'Nueva',
                Origin = 'Phone'
            );
            TriggerManager.inactivate('AAZ_CaseMainTrigger_tgr');
            Database.insert(caseInstance,true);

            Document__c document = new Document__c(
                DocumentTypeId__c = '1',
                RelatedProcedure__c = caseInstance.Id,
                FileURL__c = 'https://i.stack.imgur.com/6yyQs.png'
            );
            TriggerManager.inactivate('AAZ_CaseMainTrigger_tgr');
            Database.insert(document,true);

            List<ReasonRejection__c> lstReasonRejection = [
                SELECT Id
                FROM ReasonRejection__c
                WHERE ProcedureId__c = :caseInstance.Id
            ];

            Test.startTest();
                AAZ_DocumentIdentification_ctr controller =
                    new AAZ_DocumentIdentification_ctr(
                    new ApexPages.StandardController(caseInstance)
                );
                System.assertEquals(0, lstReasonRejection.size());
            Test.stopTest();
    		}
    }

    /**
     * Prueba en caso existan documentos
     * @type void
     */
    @isTest static void testDocuments() {
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
            Case caseInstance = new Case(
                Status = 'Nueva',
                Origin = 'Phone',
                employeeNumber__c = '12345'
            );
            TriggerManager.inactivate('AAZ_CaseMainTrigger_tgr');
            Database.insert(caseInstance,true);

            Document__c document = new Document__c(
                DocumentTypeId__c = '1',
                RelatedProcedure__c = caseInstance.Id,
                FileURL__c = 'https://i.stack.imgur.com/6yyQs.png'
            );
            TriggerManager.inactivate('AAZ_CaseMainTrigger_tgr');
            Database.insert(document,true);

            Test.startTest();
                AAZ_DocumentIdentification_ctr controller =
                    new AAZ_DocumentIdentification_ctr(
                        new ApexPages.StandardController(caseInstance)
                    );
                System.assertEquals(1, controller.lstDocumentData.size());
      			Test.stopTest();
    		}
    }

    /**
     * Prueba en caso que no existan documentos
     * @type void
     */
    @isTest static void testNoDocuments() {
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
            Case caseInstance = new Case(
                Status = 'Nueva',
                Origin = 'Phone'
            );
            TriggerManager.inactivate('AAZ_CaseMainTrigger_tgr');
            Database.insert(caseInstance,true);

            Test.startTest();
                AAZ_DocumentIdentification_ctr controller =
                    new AAZ_DocumentIdentification_ctr(
                        new ApexPages.StandardController(caseInstance)
                    );
                System.assertEquals(0, controller.lstDocumentData.size());
      			Test.stopTest();
    		}
    }
}