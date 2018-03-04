/*******************************************************************************
Desarrollado por: Avanxo México
Autor: Iván Neria
Proyecto: Afore Azteca
Descripción: Clase test para la clase AAZ_SendDocumentsWizardAP_ctr
-------------------------------------
No.    Fecha      Autor                          Descripción
------ ---------- ----------------------------- -----------
1.2    08-11-2017 Iván Neria 				     Modificación
*******************************************************************************/
@isTest
private class AAZ_SendDocumentsWizard_ctr_tst {
    @TestSetup static void setup(){
        Contact contactInstance = new Contact(
        	LastName = 'LastName',
        	employeeNumber__c = '1234567'
        ); 

        insert contactInstance;

        Case thisCase = new Case (
        	Status = 'Nueva',
            Origin = 'Phone',
            employeeNumber__c = '11234'
        );

        insert thisCase;

        Case caseInstance = new Case(
            Status = 'Nueva',
            Origin = 'Phone',
            employeeNumber__c = '11233',
            ContactId = contactInstance.Id,
            ParentId = thisCase.Id            
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
    
        Documentos_AP__c docAPinstance = new Documentos_AP__c();
        docAPinstance.FileURL__c = 'https://i.stack.imgur.com/6yyQs.png';
        docAPinstance.DocumentType__c ='Acta Administrativa';
        docAPinstance.DocName__c = 'NewDocument';
         TriggerManager.inactivate('AAZ_CaseMainTrigger_tgr');
        Database.insert(docAPinstance, true);
        
        

		
    }
	// En el método uno se realiza la mayor parte del proceso
	public static testMethod void methodOne() {
		Documentos_AP__c docAPinstance = [SELECT Id FROM Documentos_AP__c LIMIT 1];
        case caseInstance =[SELECT Id FROM Case LIMIT 1];
        contact newInstance = [SELECT Id, LastName, ChoosenAPDocument__c FROM contact LIMIT 1];
        System.debug('Este es el contacto insertado'+newInstance);
		newInstance.ChoosenAPDocument__c = docAPinstance.Id;
        newInstance.APDocsCase__c = caseInstance.Id;
        
        
        TriggerManager.inactivate('AAZ_CaseMainTrigger_tgr');
        Database.upsert(newInstance, true);
        
         
        
        contact newInstanceUpt = [SELECT Id, LastName, ChoosenAPDocument__c, APDocsCase__c FROM contact LIMIT 1];
        System.debug('Al final queda así'+newInstance);
		
       
        
        Test.startTest();
        	        
            AAZ_SendDocumentsWizardAP_ctr objC = new AAZ_SendDocumentsWizardAP_ctr(new ApexPages.StandardController(newInstanceUpt));
            //AAZ_SendDocumentsWizard_ctr Run = new AAZ_SendDocumentsWizard_ctr(new ApexPages.StandardController());
            Attachment attch = new Attachment(Body = Blob.valueof('body'), Name = 'Attch', ParentId = caseInstance.Id );
            insert attch;
            objC.attchmntInstance = attch;
            ObjC.initiateVars();
            objC.getDocumentTypeOptions();
            //objC.executeOperation();
            
            objC.strMode = 'Baja';
        	objC.contactInstance=newInstanceUpt;
            objC.executeOperation();
        	//objC.strMode = 'Alta';
        	//objC.executeOperation();
          
        Test.stopTest();
    }
    //El método dos solamente aumenta la cobertura para cuando el método validateInputs() devuelve false
    public static testMethod void methodTwo() {
		Documentos_AP__c docAPinstance = [SELECT Id FROM Documentos_AP__c LIMIT 1];
        
        contact newInstance = [SELECT Id, LastName, ChoosenAPDocument__c FROM contact LIMIT 1];
        System.debug('Este es el contacto insertado del metodo 2'+newInstance);
		
		
        case caseInstance =[SELECT Id FROM Case LIMIT 1];
        
        Test.startTest();
        	        
            AAZ_SendDocumentsWizardAP_ctr objC = new AAZ_SendDocumentsWizardAP_ctr(new ApexPages.StandardController(newInstance));
            //AAZ_SendDocumentsWizard_ctr Run = new AAZ_SendDocumentsWizard_ctr(new ApexPages.StandardController());
            Attachment attch = new Attachment(Body = Blob.valueof('body'), Name = 'Attch', ParentId = caseInstance.Id );
            insert attch;
            objC.attchmntInstance = attch;
            ObjC.initiateVars();
            objC.getDocumentTypeOptions();
            objC.strMode = 'Reemplazo';
            objC.executeOperation();
            objC.strMode = 'Baja';
            objC.executeOperation();
          
        Test.stopTest();
    }
    //El método tres solamente aumenta la cobertura para cuando el método validateInputs() devuelve true
    public static testMethod void methodThree() {
		Documentos_AP__c docAPinstance = [SELECT Id, DocumentType__c, DocName__c FROM Documentos_AP__c LIMIT 1];
        System.debug('el documenttype es ='+ docAPinstance);
        case caseInstance =[SELECT Id FROM Case LIMIT 1];
        contact newInstance = [SELECT Id, LastName, ChoosenAPDocument__c FROM contact LIMIT 1];
        System.debug('Este es el contacto insertado'+newInstance);
		newInstance.ChoosenAPDocument__c = docAPinstance.Id;
        newInstance.APDocsCase__c = caseInstance.Id;
        
        
        TriggerManager.inactivate('AAZ_CaseMainTrigger_tgr');
        Database.upsert(newInstance, true);
        
         
        
        contact newInstanceUpt = [SELECT Id, LastName, ChoosenAPDocument__c, APDocsCase__c FROM contact LIMIT 1];
        System.debug('Al final queda así'+newInstance);
		
       
        
        Test.startTest();
        	        
            AAZ_SendDocumentsWizardAP_ctr objC = new AAZ_SendDocumentsWizardAP_ctr(new ApexPages.StandardController(newInstanceUpt));
            //AAZ_SendDocumentsWizard_ctr Run = new AAZ_SendDocumentsWizard_ctr(new ApexPages.StandardController());
            Attachment attch = new Attachment(Body = Blob.valueof('body'), Name = 'Attch', ParentId = caseInstance.Id );
            insert attch;
        	objC.docAPInstance=docAPinstance;
            objC.attchmntInstance = attch;
            //ObjC.initiateVars();
            objC.getDocumentTypeOptions();
            //objC.executeOperation();
            
            //objC.strMode = 'Baja';
        	objC.contactInstance=newInstanceUpt;
            //objC.executeOperation();
        	objC.strMode = 'Alta';
        	objC.executeOperation();
          
        Test.stopTest();
    }
	//El método cuatro solamente aumenta la cobertura para cuando el método validateInputs() devuelve true    
    public static testMethod void methodFour() {
		Documentos_AP__c docAPinstance = [SELECT Id, DocumentType__c, DocName__c FROM Documentos_AP__c LIMIT 1];
        System.debug('el documenttype es ='+ docAPinstance);
        case caseInstance =[SELECT Id FROM Case LIMIT 1];
        contact newInstance = [SELECT Id, LastName, ChoosenAPDocument__c FROM contact LIMIT 1];
        System.debug('Este es el contacto insertado'+newInstance);
		newInstance.ChoosenAPDocument__c = docAPinstance.Id;
        newInstance.APDocsCase__c = caseInstance.Id;
        
        
        TriggerManager.inactivate('AAZ_CaseMainTrigger_tgr');
        Database.upsert(newInstance, true);
        
         
        
        contact newInstanceUpt = [SELECT Id, LastName, ChoosenAPDocument__c, APDocsCase__c FROM contact LIMIT 1];
        System.debug('Al final queda así'+newInstance);
		
       
        
        Test.startTest();
        	        
            AAZ_SendDocumentsWizardAP_ctr objC = new AAZ_SendDocumentsWizardAP_ctr(new ApexPages.StandardController(newInstanceUpt));
            //AAZ_SendDocumentsWizard_ctr Run = new AAZ_SendDocumentsWizard_ctr(new ApexPages.StandardController());
            Attachment attch = new Attachment(Body = Blob.valueof('body'), Name = 'Attch', ParentId = caseInstance.Id );
            insert attch;
        	objC.docAPInstance=docAPinstance;
            objC.attchmntInstance = attch;
            //ObjC.initiateVars();
            objC.getDocumentTypeOptions();
            //objC.executeOperation();
            
            //objC.strMode = 'Baja';
        	objC.contactInstance=newInstanceUpt;
            //objC.executeOperation();
        	objC.strMode = 'Reemplazo';
        	objC.executeOperation();
          
        Test.stopTest();
    }

}