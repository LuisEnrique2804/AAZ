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
	* AAZ_DocumentList_ctr
    Information about changes (versions)
    ================================================================================================
    Number    Dates           Author                       Description
    ------    --------        --------------------------   -----------------------------------------
    1.0       26-Sep-2017     Iván Neria                  Creación de la Clase
    2.0       03-Nov-2017     Samuel Galindo              Modificación
    ================================================================================================
****************************************************************************************************/
@isTest	private class AAZ_DocumentList_tst {
    /**
     * Prueba para descargar documento
     * @type void
     */
     @isTest static void testDownloadFile() {
         Profile profileInstance =	[
             SELECT Id
             FROM Profile
             WHERE Name =:'Administrador del sistema' limit 1
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
                 Type   = 'AFILIACION',
                 SubType__c = 'REGISTRO'
             );

             TriggerManager.inactivate('AAZ_CaseMainTrigger_tgr');
             Database.insert(caseInstance,true);

             Document__c document = new Document__c(
                 DocumentTypeId__c = '520',
                 RelatedProcedure__c = caseInstance.Id,
                 FileURL__c = 'https://i.stack.imgur.com/6yyQs.png',
                 Orden__c=1,
                 page__c=1
             );

             TriggerManager.inactivate('AAZ_CaseMainTrigger_tgr');
             Database.insert(document,true);

             Test.startTest();
                Test.setMock(HttpCalloutMock.class, new SingleRequestMock( 'StringToBlob', false, 200, 'Ok'));

                AAZ_DocumentList_ctr Run =
                    new AAZ_DocumentList_ctr(
                        new ApexPages.StandardController(caseInstance)
                    );

                PageReference pageRef = Page.AAZ_DocumentList_pag; // Add your VF page Name here
                pageRef.getParameters().put('strDocTypeId', String.valueOf(520));
                pageRef.getParameters().put('strPageNumber', String.valueOf(1));
                Test.setCurrentPage(pageRef);
                Run.downloadFile();
                System.assertNotEquals( '', Run.strDigitalizationFile);
       			 Test.stopTest();
     		}

     }

    /**
     * Prueba en caso existan documentos
     * @type void
     */
    @isTest static void testDocuments() {
        Profile profileInstance =	[
            SELECT Id
            FROM Profile
            WHERE Name =:'Administrador del sistema' limit 1
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
                Type   = 'AFILIACION',
                SubType__c = 'REGISTRO'
            );

            TriggerManager.inactivate('AAZ_CaseMainTrigger_tgr');
            Database.insert(caseInstance,true);

            Document__c document = new Document__c(
                DocumentTypeId__c = '520',
                RelatedProcedure__c = caseInstance.Id,
                FileURL__c = 'https://i.stack.imgur.com/6yyQs.png',
                Orden__c=1,
                page__c=1
            );

            TriggerManager.inactivate('AAZ_CaseMainTrigger_tgr');
            Database.insert(document,true);

            Test.startTest();
                AAZ_DocumentList_ctr Run =
                    new AAZ_DocumentList_ctr(
                        new ApexPages.StandardController(caseInstance)
                    );
                    System.assertEquals(
                        Run.lstRelatedDocuments.size(),
                        1
                    );
      			Test.stopTest();
    		}
    }

    /**
     * Prueba en caso que no existan documentos
     * @type void
     */
    @isTest static void testNoDocuments() {

        Profile profileInstance =	[
            SELECT Id
            FROM Profile
            WHERE Name =:'Administrador del sistema' limit 1
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

            Test.startTest();
                AAZ_DocumentList_ctr Run =
                    new AAZ_DocumentList_ctr(
                        new ApexPages.StandardController(caseInstance)
                    );
                    System.assertEquals(
                        Run.lstRelatedDocuments.size(),
                        0
                    );
      			Test.stopTest();
    		}
    }
}