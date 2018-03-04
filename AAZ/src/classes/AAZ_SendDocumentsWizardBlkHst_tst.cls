/*******************************************************************************
Desarrollado por: Avanxo México
Autor: Samuel Galindo
Proyecto: Afore Azteca
Descripción: Clase test para la clase AAZ_SendDocumentsWizardBlkHst_ctr
-------------------------------------
No.    Fecha      Autor                          Descripción
------ ---------- -----------------------------  -----------
1.0    08-11-2017 Samuel Galindo 				         Creación
*******************************************************************************/
@isTest private class AAZ_SendDocumentsWizardBlkHst_tst {

    /**
     * Prueba del método executeOperation en caso que sea Baja sin que exista un
     * documento de Agente Promotor
     * @type void
     */
     @isTest static void testMethodSeven() {
         Contact contactInstance = new Contact(
             FirstName = 'SERVANDO',
             LastName = 'JIMENEZ LOPEZ',
             Status__c = 'Desbloqueado',
             EmployeeNumber__c = '123456789012345'
         );
         Database.insert(contactInstance, true);

         Case caseInstance = new Case(
             Status = 'Nueva',
             Origin = 'Phone',
             Type   = 'AFILIACION',
             SubType__c = 'REGISTRO',
             FolioNSS__c = '485746363'
         );
         Database.insert(caseInstance, true);

         Documentos_AP__c objDocAPInstance = new Documentos_AP__c(
             DocName__c	= 'Prueba Documento AP'
         );
         Database.insert(objDocAPInstance, true);
          objDocAPInstance = [
              SELECT Id, Name, DocName__c
              FROM Documentos_AP__c
              WHERE Id = :objDocAPInstance.Id
          ];

         List<string> lstPrueba = new List<string>{'a','b'};
         String strBody = '';
         for(String s:lstPrueba){
            strBody = strBody+''+s;
         }
         Blob b = Blob.valueOf(strBody);
         Attachment attachmentInstace = new Attachment(
             ParentId = caseInstance.Id,
             Name = 'Test Attachment',
             Body = b
         );
         Database.insert(attachmentInstace, true);

         BlockHistory__c blockhistoryInstance = new BlockHistory__c(
             PromotorAgentName__c = contactInstance.Id,
             Tramite__c = caseInstance.Id
         );
         Database.insert(blockhistoryInstance, true);
         blockhistoryInstance.ChoosenAPDocument__c = objDocAPInstance.Id;

         Test.startTest();
             AAZ_SendDocumentsWizardBlkHst_ctr controller =
                 new AAZ_SendDocumentsWizardBlkHst_ctr(
                     new ApexPages.StandardController(blockhistoryInstance)
                 );
                 controller.attchmntInstance = attachmentInstace;
                 controller.strMode = 'Baja';
                 controller.docAPInstance.DocName__c = 'NOMBRE PRUEBA';
                 controller.bHistoryInstance = blockhistoryInstance;
                 controller.executeOperation();
                 System.assertEquals(false, controller.blnSuccessfulProcedure);
         Test.stopTest();
     }

    /**
     * Prueba del método executeOperation en caso que sea Reemplazo sin que exista un
     * documento de Agente Promotor
     * @type void
     */
     @isTest static void testMethodSix() {
         Contact contactInstance = new Contact(
             FirstName = 'SERVANDO',
             LastName = 'JIMENEZ LOPEZ',
             Status__c = 'Desbloqueado',
             EmployeeNumber__c = '123456789012345'
         );
         Database.insert(contactInstance, true);

         Case caseInstance = new Case(
             Status = 'Nueva',
             Origin = 'Phone',
             Type   = 'AFILIACION',
             SubType__c = 'REGISTRO',
             FolioNSS__c = '485746363'
         );
         Database.insert(caseInstance, true);

         Documentos_AP__c objDocAPInstance = new Documentos_AP__c(
             DocName__c	= 'Prueba Documento AP'
         );
         Database.insert(objDocAPInstance, true);
          objDocAPInstance = [
              SELECT Id, Name, DocName__c
              FROM Documentos_AP__c
              WHERE Id = :objDocAPInstance.Id
          ];

         List<string> lstPrueba = new List<string>{'a','b'};
         String strBody = '';
         for(String s:lstPrueba){
            strBody = strBody+''+s;
         }
         Blob b = Blob.valueOf(strBody);
         Attachment attachmentInstace = new Attachment(
             ParentId = caseInstance.Id,
             Name = 'Test Attachment',
             Body = b
         );
         Database.insert(attachmentInstace, true);

         BlockHistory__c blockhistoryInstance = new BlockHistory__c(
             PromotorAgentName__c = contactInstance.Id,
             Tramite__c = caseInstance.Id
         );
         Database.insert(blockhistoryInstance, true);
         blockhistoryInstance.ChoosenAPDocument__c = objDocAPInstance.Id;

         Test.startTest();
             AAZ_SendDocumentsWizardBlkHst_ctr controller =
                 new AAZ_SendDocumentsWizardBlkHst_ctr(
                     new ApexPages.StandardController(blockhistoryInstance)
                 );
                 controller.attchmntInstance = attachmentInstace;
                 controller.strMode = 'Reemplazo';
                 controller.docAPInstance.DocName__c = 'NOMBRE PRUEBA';
                 controller.bHistoryInstance = blockhistoryInstance;
                 controller.executeOperation();
                 System.assertEquals(false, controller.blnSuccessfulProcedure);
         Test.stopTest();
     }

    /**
     * Prueba del método executeOperation en caso que sea Alta sin que exista un
     * documento de Agente Promotor
     * @type void
     */
     @isTest static void testMethodFive() {
         Contact contactInstance = new Contact(
             FirstName = 'SERVANDO',
             LastName = 'JIMENEZ LOPEZ',
             Status__c = 'Desbloqueado',
             EmployeeNumber__c = '123456789012345'
         );
         Database.insert(contactInstance, true);

         Case caseInstance = new Case(
             Status = 'Nueva',
             Origin = 'Phone',
             Type   = 'AFILIACION',
             SubType__c = 'REGISTRO',
             FolioNSS__c = '485746363'
         );
         Database.insert(caseInstance, true);

         Documentos_AP__c objDocAPInstance = new Documentos_AP__c(
             DocName__c	= 'Prueba Documento AP'
         );
         Database.insert(objDocAPInstance, true);

         List<string> lstPrueba = new List<string>{'a','b'};
         String strBody = '';
         for(String s:lstPrueba){
            strBody = strBody+''+s;
         }
         Blob b = Blob.valueOf(strBody);
         Attachment attachmentInstace = new Attachment(
             ParentId = caseInstance.Id,
             Name = 'Test Attachment',
             Body = b
         );
         Database.insert(attachmentInstace, true);

         BlockHistory__c blockhistoryInstance = new BlockHistory__c(
             PromotorAgentName__c = contactInstance.Id,
             Tramite__c = caseInstance.Id,
             ChoosenAPDocument__c = objDocAPInstance.Name
         );
         Database.insert(blockhistoryInstance, true);

         Test.startTest();
             AAZ_SendDocumentsWizardBlkHst_ctr controller =
                 new AAZ_SendDocumentsWizardBlkHst_ctr(
                     new ApexPages.StandardController(blockhistoryInstance)
                 );
                 controller.attchmntInstance = attachmentInstace;
                 controller.strMode = 'Alta';
                 controller.docAPInstance.DocName__c = 'NOMBRE PRUEBA';
                 controller.bHistoryInstance = blockhistoryInstance;
                 controller.executeOperation();
                 System.assertEquals(false, controller.blnSuccessfulProcedure);
         Test.stopTest();
     }

    /**
     * Prueba del método executeOperation en caso que el metodo validateInputs
     * regrese false
     * @type void
     */
     @isTest static void testMethodFour() {
         Contact contactInstance = new Contact(
             FirstName = 'SERVANDO',
             LastName = 'JIMENEZ LOPEZ'
         );
         Database.insert(contactInstance, true);

         BlockHistory__c blockhistoryInstance = new BlockHistory__c(
             PromotorAgentName__c = contactInstance.Id
         );
         Database.insert(blockhistoryInstance, true);

         Test.startTest();
             AAZ_SendDocumentsWizardBlkHst_ctr controller =
                 new AAZ_SendDocumentsWizardBlkHst_ctr(
                     new ApexPages.StandardController(blockhistoryInstance)
                 );
                 controller.strMode='Baja';
                 controller.validateInputs();
                 controller.executeOperation();
                 System.assertEquals(1, controller.lstErrorMsgs.size());
         Test.stopTest();
     }

    /**
     * Prueba del método validateInputs en caso que sea diferente de Baja y
     * Reemplazo y no haya ingresado datos
     * @type void
     */
     @isTest static void testMethodThree() {
         Contact contactInstance = new Contact(
             FirstName = 'SERVANDO',
             LastName = 'JIMENEZ LOPEZ'
         );
         Database.insert(contactInstance, true);

         BlockHistory__c blockhistoryInstance = new BlockHistory__c(
             PromotorAgentName__c = contactInstance.Id
         );
         Database.insert(blockhistoryInstance, true);

         Test.startTest();

             AAZ_SendDocumentsWizardBlkHst_ctr controller =
                 new AAZ_SendDocumentsWizardBlkHst_ctr(
                     new ApexPages.StandardController(blockhistoryInstance)
                 );
                 controller.strMode='Alta';
                 System.assertEquals(false, controller.validateInputs());
         Test.stopTest();
     }

    /**
     * Prueba del método validateInputs en caso que sea Reemplazo y no haya
     * ingresado datos
     * @type void
     */
     @isTest static void testMethodTwo() {
         Contact contactInstance = new Contact(
             FirstName = 'SERVANDO',
             LastName = 'JIMENEZ LOPEZ'
         );
         Database.insert(contactInstance, true);

         BlockHistory__c blockhistoryInstance = new BlockHistory__c(
             PromotorAgentName__c = contactInstance.Id
         );
         Database.insert(blockhistoryInstance, true);

         Test.startTest();

             AAZ_SendDocumentsWizardBlkHst_ctr controller =
                 new AAZ_SendDocumentsWizardBlkHst_ctr(
                     new ApexPages.StandardController(blockhistoryInstance)
                 );
                 controller.strMode='Reemplazo';
                 System.assertEquals(false, controller.validateInputs());
         Test.stopTest();
     }

    /**
     * Prueba del método validateInputs en caso que sea Baja
     * @type void
     */
     @isTest static void testMethodOne() {
         Contact contactInstance = new Contact(
             FirstName = 'SERVANDO',
             LastName = 'JIMENEZ LOPEZ'
         );
         Database.insert(contactInstance, true);

         BlockHistory__c blockhistoryInstance = new BlockHistory__c(
             PromotorAgentName__c = contactInstance.Id
         );
         Database.insert(blockhistoryInstance, true);

         Test.startTest();

             AAZ_SendDocumentsWizardBlkHst_ctr controller =
                 new AAZ_SendDocumentsWizardBlkHst_ctr(
                     new ApexPages.StandardController(blockhistoryInstance)
                 );
                 controller.strMode='Baja';
                 System.assertEquals(false, controller.validateInputs());
         Test.stopTest();
     }

    /**
     * Prueba inicialización constructor correctamente
     */
    @isTest static void testInitial() {
        Contact contactInstance = new Contact(
            FirstName = 'SERVANDO',
            LastName = 'JIMENEZ LOPEZ'
        );
        Database.insert(contactInstance, true);

        BlockHistory__c blockhistoryInstance = new BlockHistory__c(
            PromotorAgentName__c = contactInstance.Id
        );
        Database.insert(blockhistoryInstance, true);

        Test.startTest();

            AAZ_SendDocumentsWizardBlkHst_ctr controller =
                new AAZ_SendDocumentsWizardBlkHst_ctr(
                    new ApexPages.StandardController(blockhistoryInstance)
                );
                System.assertEquals(false, controller.blnSuccessfulProcedure);
                System.assertEquals('', controller.strMode);
        Test.stopTest();
    }
}