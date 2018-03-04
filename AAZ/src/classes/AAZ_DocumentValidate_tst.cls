/*******************************************************************************
Desarrollado por: Avanxo México
Autor: Samuel Galindo
Proyecto: Afore Azteca
Descripción: Clase test para la clase AAZ_DocumentValidate_ctr
-------------------------------------
No.    Fecha      Autor                          Descripción
------ ---------- ----------------------------- -----------
1.2    08-11-2017 Samuel Galindo 				         Modificación
*******************************************************************************/
@isTest
private class AAZ_DocumentValidate_tst {

		@TestSetup static void setup() {

				AppMainSetting_cs__c mainSettings = Test.isRunningTest()?
				AAZ_TestUtils_tst.getMainSettings() : AppMainSetting_cs__c.getOrgDefaults();

				List<SObject> lstSObjects = new List<SObject>();

				Account thisAccount = new Account (
						LastName = 'TESTE X',
						NSS__c = '210792591',
						RFC__c = 'testezxd',
						RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cuenta personal').getRecordTypeId(),
						Type = 'Analyst'
				);

				lstSObjects.add ( thisAccount );

				Contact thisContact = new Contact(
						LastName = 'LastName',
				  	employeeNumber__c = '1234567'
				);

				lstSObjects.add ( thisContact);

				Case parentCase = new Case (
						Status = 'EN VALIDACION',
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
				    ContactId = thisContact.Id,
				    ParentId = parentCase.Id,
				    NumberOfPrints__c = 1,
				    AccountId = thisAccount.Id,
				    Type =  'AFILIACION',
				    SubType__c = 'Traspaso'
				);

				lstSObjects.add ( caseOne );

				Case caseTwo = new Case(
				    Status = 'Nueva',
				    Origin = 'Phone',
				    employeeNumber__c = '11233',
				    ContactId = thisContact.Id,
				    ParentId = parentCase.Id,
				    NumberOfPrints__c = 2,
				    AccountId = thisAccount.Id,
				    Type =  'Retiros Parciales',
				    SubType__c = 'MATRIMONIOs'
				);

				lstSObjects.add ( caseTwo );

				insert lstSObjects;

				lstSObjects = new List<SObject>();

				Document__c documentOne = new Document__c (
						RelatedProcedure__c = caseOne.Id,
				    FileURL__c = 'https://i.stack.imgur.com/6yyQs.png',
						DocumentTypeId__c = '1004'
				);

				lstSObjects.add ( documentOne );

				Document__c documentTwo = new Document__c (
						RelatedProcedure__c = caseOne.Id,
				    FileURL__c = 'https://i.stack.imgur.com/6yyQs.png',
				  	DocumentTypeId__c = '1003'
				);

				lstSObjects.add ( documentTwo );

				Document__c documentThree = new Document__c (
						RelatedProcedure__c = caseOne.Id,
				    FileURL__c = 'https://i.stack.imgur.com/6yyQs.png',
				  	DocumentTypeId__c = '26'
				);

				lstSObjects.add ( documentThree );

				Document__c documentFour = new Document__c (
						RelatedProcedure__c = caseTwo.Id,
				    FileURL__c = 'https://i.stack.imgur.com/6yyQs.png',
				  	DocumentTypeId__c = '0',
				    Orden__c=1,
				    page__c=1
				);

				lstSObjects.add ( documentFour );

				insert lstSObjects;

				lstSObjects = new List<SObject>();

				CaseComment thisComent = new CaseComment(
				  	CommentBody = 'test',
				  	ParentId = caseOne.Id
				);

				lstSObjects.add ( thisComent );

				ReasonRejection__c thisRejection = new ReasonRejection__c(
				  	//ReasonRejectionID__c = 1,
				  	ProcedureId__c = caseOne.Id,
				  	Document__c = documentFour.Id,
				  	DocumentIndex__c = 1
				);

				lstSObjects.add ( thisRejection );

				insert lstSObjects;
		}

		/**
		 * Prueba para probar todos los métodos
		 * @type void
		 */
		@isTest static void testMethods() {
            List<SObject> lstSObjects = new List<SObject>();
				Case thisCase = [
						SELECT Status, Origin, employeeNumber__c, ContactId, ParentId, NumberOfPrints__c, AccountId, Type
						FROM Case
						WHERE Type = 'AFILIACION' LIMIT 1
				];

				List<RejectionReasonByDoc__mdt> mtdRejection = [
						SELECT Id, RelatedDocumentType__c, RelatedDocumentType__r.Label,
						RelatedDocumentType__r.DigitizationID__c, RelatedRejectionReason__c,
						Label, RelatedRejectionReason__r.ReasonRejectionID__c
						FROM RejectionReasonByDoc__mdt LIMIT 2
				];
				List<Document__c> Doclst =[
						SELECT DocumentTypeId__c, name , Id, FileURL__c, RelatedProcedure__c
						FROM Document__c
				];
                ReasonRejection__c reasonRejection = [ SELECT Id FROM ReasonRejection__c LIMIT 1];
                lstSObjects.add ( reasonRejection );
				Test.startTest();
						AAZ_DocumentValidate_ctr controller = new AAZ_DocumentValidate_ctr(new ApexPages.StandardController(thisCase));
						controller.strDigitalizationVideo='TestVideo';
						controller.strDigitalizationSound='testvideo';
						controller.strComments='Test Comentario';
						controller.strUserSelected='Test User';
						controller.currentDocumentIndex=1;
						controller.blnIsComplainRecord = true;
						controller.strOptionSelect = new List<String>{'test'};
						controller.strRevertComment = 'strRevertComment';

						controller.lstRejectionsProcedureSelect = '10,103';
						controller.strAceptComment = 'test';
						controller.lstRejectionsReasonByDoc = mtdRejection;
						controller.intCurrentIndex=519;
						controller.lstDocumentProcess=Doclst;
						controller.getRejectionProcedureSaved();
						controller.fileNextDoc();
						controller.filePreviousDoc();
						controller.imageUpdate();
						//controller.getDocumentRejections();
						controller.setOptionSelect(1);
						controller.getSaveRejections();
						controller.strPendingComment = 'strPendingComment';
						controller.savePending();
						controller.saveRevert();
						controller.fileNext();
						controller.initOrdinaryProcessApprovalVars();
						controller.approveProcedureFirstStep();
						controller.approveProcedureSecondStep();
						controller.setListeningMode();
						controller.getComponentStatusQuery();
						controller.saveResults(true);
						controller.statusProcedure();
						controller.searchAcc();
						controller.getDefaultProcedureRejections();
						controller.LockUnlockAP2();
						controller.sendFingerPrints(null);
						controller.saveRevert();
						controller.savePending();
						controller.filePrevious();
						controller.saveAllRejections();
						controller.counterRejections();
						controller.getRejectionSaved();
						controller.setOptionSelect(1);
						controller.setOptionReject( new List<String>{'a'} );
						controller.strPendingComment = 'strPendingComment';
						//controller.backProcedure();
						controller.documentSelectionChange();
						controller.goToPreviousDocument();
						controller.goToNextDocument();
						controller.goToPreviousPage();
						controller.goToNextPage();
						controller.changeStatus();
						controller.strAceptComment = 'test';
						controller.saveAccept();
						controller.updaterRelatedWorker();
                        controller.saveRejections();
						thisCase.Status='RECHAZADO';
						controller.statusProcedure();

						AAZ_DocumentValidate_ctr.normalJson(thisCase);
				Test.stopTest();
		}

		/**
		 * Prueba para una excepción
		 * @type void
		 */
		@isTest static void testMethodExceptionOne() {

				List<SObject> lstSObjects = new List<SObject>();

				Case thisCase = [
						SELECT Status, Origin, employeeNumber__c, ContactId, ParentId, NumberOfPrints__c,
						AccountId, Type
						FROM Case WHERE Type = 'Retiros Parciales'
						LIMIT 1
				];

				List<RejectionReasonByDoc__mdt> mtdRejection = [
						SELECT Id, RelatedDocumentType__c, RelatedDocumentType__r.Label,
						RelatedDocumentType__r.DigitizationID__c, RelatedRejectionReason__c,
						Label, RelatedRejectionReason__r.ReasonRejectionID__c
						FROM RejectionReasonByDoc__mdt LIMIT 2
				];

				ReasonRejection__c reasonRejection = [ SELECT Id FROM ReasonRejection__c LIMIT 1];
				reasonRejection.Document__c = null;

				lstSObjects.add ( reasonRejection );

				thisCase.Status = 'En Validación MC';

				lstSObjects.add ( thisCase );

				update lstSObjects;

				Test.startTest();
						AAZ_DocumentValidate_ctr controller = new AAZ_DocumentValidate_ctr(new ApexPages.StandardController(thisCase));
						controller.lstRejectionsReasonByDoc = mtdRejection;
						controller.getListRejectionProcedure();
				Test.stopTest();
		}

		/**
		 * Prueba para la segunda excepción
		 * @type void
		 */
		@isTest static void testMethodExceptionTwo() {

				Case thisCase = [
						SELECT Status, Origin, employeeNumber__c, ContactId, ParentId, NumberOfPrints__c,
						AccountId, Type
						FROM Case
						WHERE Type = 'Retiros Parciales' LIMIT 1
				];

				thisCase.Status = 'Autorizada';

				update thisCase;

				Test.startTest();
						AAZ_DocumentValidate_ctr controller = new AAZ_DocumentValidate_ctr(new ApexPages.StandardController(thisCase));
				Test.stopTest();
		}

		/**
		 * Prueba excepción tres
		 * @type void
		 */
		@isTest static void testMethodExceptionThree() {
            List<SObject> lstSObjects = new List<SObject>();
				Case thisCase = [
						SELECT Status, Origin, employeeNumber__c, ContactId, ParentId, NumberOfPrints__c,
						AccountId, Type
						FROM Case
						WHERE Type = 'Retiros Parciales' LIMIT 1
				];

				thisCase.Status = 'Rechazada';
				update thisCase;

				Case caseOne = new Case(
						Status = 'Nueva',
						Origin = 'Phone',
						employeeNumber__c = '11233',
						NumberOfPrints__c = 1,
						Type =  'AFILIACION',
						SubType__c = 'Traspasos'
				);
				insert caseOne;

				Map<integer,Document__c> MapDc = new map<integer,Document__c>();
				Document__c Dcmt = new Document__c();
				Dcmt.DocumentTypeId__c='1003';
				Dcmt.FileURL__c='https://i.stack.imgur.com/6yyQs.png';
				Dcmt.Orden__c=1;
				Dcmt.RelatedProcedure__c=caseOne.Id;

				MapDc.put(integer.valueOf(Dcmt.orden__c),Dcmt);
				insert Dcmt;

				Map<integer,List<String>> MapRj = new map<integer,List<String>>();
				List<String> LstRj = new List<String>();
				LstRj.add('1');
				MapRj.put(1,LstRj);

				RejectionReasonByDoc__mdt mtdRejection = [
						SELECT Id, RelatedDocumentType__c, RelatedDocumentType__r.Label,
						RelatedDocumentType__r.DigitizationID__c, RelatedRejectionReason__c,
						Label, RelatedRejectionReason__r.ReasonRejectionID__c
						FROM RejectionReasonByDoc__mdt LIMIT 1
				];

				Map<String, RejectionReasonByDoc__mdt> MapRr = new Map<String, RejectionReasonByDoc__mdt>();
				MapRr.put('1', mtdRejection);

				case CaseIns = [
						SELECT id, Status, Origin, employeeNumber__c, ContactId, ParentId,
						NumberOfPrints__c, AccountId, Type
						FROM Case
						LIMIT 1
				];

				List<Document__c> LstDcs = [SELECT  id FROM Document__c LIMIT 1];
                ReasonRejection__c reasonRejection = [ SELECT Id FROM ReasonRejection__c LIMIT 1];
                lstSObjects.add ( reasonRejection );
				List<String> LstIds = new List<String>();
				String ssid = String.valueOf(LstDcs);
				LstIds.add(ssid);

				Test.startTest();
						AAZ_DocumentValidate_ctr controller = new AAZ_DocumentValidate_ctr(new ApexPages.StandardController(thisCase));
						controller.lstRejectionsProcedureSelect = '10,103';
						controller.intCurrentIndex=1;
						controller.mapDocuments=MapDc;
						controller.mapRejection=MapRj;
						controller.mapReasonRejectionDocs=MapRr;
						controller.lstDocumentsIdentificacion=LstIds;
						controller.getRejectionSaved();
						controller.intCurrentIndex2=1;
						//controller.saveRejectionsDocs();
						controller.getSaveRejections();

						thisCase.Status='REVERTIDO';
						update thisCase;
						AAZ_DocumentValidate_ctr controller2 = new AAZ_DocumentValidate_ctr(new ApexPages.StandardController(thisCase));
						controller2.statusProcedure();

						thisCase.Status='ACEPTADO';
						update thisCase;
						AAZ_DocumentValidate_ctr controller3 = new AAZ_DocumentValidate_ctr(new ApexPages.StandardController(thisCase));
						controller3.statusProcedure();

						thisCase.Status='RECHAZADO';
						update thisCase;
						AAZ_DocumentValidate_ctr controller4 = new AAZ_DocumentValidate_ctr(new ApexPages.StandardController(thisCase));
						controller4.statusProcedure();
				Test.stopTest();
		}

		@isTest static void testMethodZipFile() {

				List<SObject> lstSObjects = new List<SObject>();

				Account thisAccount = new Account (
						LastName = 'TESTE XYYYYY',
						NSS__c = '099877899',
						RFC__c = '90998766',
						RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cuenta personal').getRecordTypeId(),
						Type = 'Analyst'
				);

				insert thisAccount;

				Contact thisContact = new Contact(
						LastName = 'LastName test',
				  	employeeNumber__c = '1234566'
				);
				insert  thisContact;

				Case thisCase = new Case(
				    Status = 'Nueva',
				    Origin = 'Phone',
				    employeeNumber__c = '11233',
				    ContactId = thisContact.Id,
				    NumberOfPrints__c = 2,
				    AccountId = thisAccount.Id,
				    Type =  'Retiros Parciales',
				    SubType__c = 'MATRIMONIOs'
				);
				insert thisCase;

				List<RejectionReasonByDoc__mdt> mtdRejection = [
						SELECT Id, RelatedDocumentType__c, RelatedDocumentType__r.Label,
						RelatedDocumentType__r.DigitizationID__c, RelatedRejectionReason__c,
						Label, RelatedRejectionReason__r.ReasonRejectionID__c
						FROM RejectionReasonByDoc__mdt LIMIT 2
				];

				ReasonRejection__c reasonRejection = [ SELECT Id FROM ReasonRejection__c LIMIT 1];
				reasonRejection.Document__c = null;

				Document__c documentOne = new Document__c (
						RelatedProcedure__c = thisCase.Id,
				    FileURL__c = 'https://i.stack.imgur.com/6yyQs.png',
						DocumentTypeId__c = '1004'
				);

				insert documentOne;

				lstSObjects.add ( reasonRejection );

				thisCase.Status = 'En Validación MC';

				lstSObjects.add ( thisCase );

				update lstSObjects;

						String myString = 'StringToBlob';
						Blob.valueof(myString);

		        // Create response mocks
		        SingleRequestMock tokenMock = new SingleRequestMock('{"signToken":{"signedToken":"ZWQzNzUyZTg5MDk4MzE0YTA1OTY4ZGU0YWI4MjljMzFhYmU5MDNkOTA0NzIzYTlhOGNmNGJhNTAwYjE5YzYwNg==","expiration":"2017-04-26 13:24:19"}}');
		        SingleRequestMock referencesMock = new SingleRequestMock('{}');
						String strReferencesEndpoint='https://i.stack.imgur.com/6yyQs.png';
		        // Save response mocks in a MultiRequestMock instance
		        MultiRequestMock multiRequestMock = new MultiRequestMock();
		        multiRequestMock.addRequestMock(strReferencesEndpoint, referencesMock);

				Test.startTest();
						AAZ_DocumentValidate_ctr controller = new AAZ_DocumentValidate_ctr(new ApexPages.StandardController(thisCase));
						Test.setMock(HttpCalloutMock.class, multiRequestMock);
						controller.getFilesToZip();
				Test.stopTest();
		}
}