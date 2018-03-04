/*******************************************************************************
Desarrollado por: Avanxo México
Autor: Samuel Galindo Rodríguez
Proyecto: Afore Azteca
Descripción: Clase de pruebas de la clase AAZ_ContactComplaints_ctr

-------------------------------------
No.    Fecha      Autor                          Descripción
------ ---------- ----------------------------- -----------
1.0    03-11-2017 Samuel Galindo Rodríguez      Creación
*******************************************************************************/
@isTest
private class AAZ_ContactComplaints_tst {

    /**
     * Prueba donde hay quejas asignadas al contacto
     * @type void
     */
     @isTest static void testAsignado() {
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
             employeeNumber__c = '171232',
             ContactId = contactInstance1.Id,
             complaintsAndTrades__c = contactInstance2.Id,
             FolioNSS__c= '201710100000008914',
             Status =	'PENDIENTE POR DOCUMENTO',
             Type =	'MODIFICACION DE DATOS'
         );

         TriggerManager.inactivate('AAZ_CaseMainTrigger_tgr');
         insert userForTesting;

         System.runAs(userForTesting){

             TriggerManager.inactivate('AAZ_CaseMainTrigger_tgr');
             Database.insert(caseInstance, true);

             Test.startTest();
                 AAZ_ContactComplaints_ctr controller =
                     new AAZ_ContactComplaints_ctr(
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
      * Prueba donde hay una Caso pero no es del tipo queja
      * @type void
      */
      @isTest static void testTramite() {
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

          TriggerManager.inactivate('AAZ_CaseMainTrigger_tgr');
          Database.insert(contactInstance1, true);

          Case caseInstance = new Case(
              ContactId = contactInstance1.Id,
              employeeNumber__c = '171232',
              FolioNSS__c= '201710100000008914',
              Status =	'PENDIENTE POR DOCUMENTO',
              Type =	'MODIFICACION DE DATOS'
          );

          TriggerManager.inactivate('AAZ_CaseMainTrigger_tgr');
          insert userForTesting;

          System.runAs(userForTesting){

              TriggerManager.inactivate('AAZ_CaseMainTrigger_tgr');
              Database.insert(caseInstance, true);

              Test.startTest();
                  AAZ_ContactComplaints_ctr controller =
                      new AAZ_ContactComplaints_ctr(
                          new ApexPages.StandardController(contactInstance1)
                  );

                  System.assertEquals(
                      controller.lstCase.size(),
                      0
                  );
              Test.stopTest();
          }
      }

      /**
       * Prueba donde hay queja pero no asignado al contacto
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
               ContactId = contactInstance1.Id,
               employeeNumber__c = '171232',
               FolioNSS__c= '201710100000008914',
               Status =	'PENDIENTE POR DOCUMENTO',
               SubType__c =	'MODIFICACION',
               Type =	'MODIFICACION DE DATOS'
           );

           TriggerManager.inactivate('AAZ_CaseMainTrigger_tgr');
           insert userForTesting;

           System.runAs(userForTesting){

               TriggerManager.inactivate('AAZ_CaseMainTrigger_tgr');
               Database.insert(caseInstance, true);

               Test.startTest();
                   AAZ_ContactComplaints_ctr controller =
                       new AAZ_ContactComplaints_ctr(
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