/*******************************************************************************
Desarrollado por: Avanxo México
Autor: Luis Enrique
Proyecto: Afore Azteca
Descripción: Clase test para la clase AAZ_GenericCallout_cls
-------------------------------------
No.    Fecha      Autor                          Descripción
------ ---------- -----------------------------  -----------
1.2    09/11/2017 Samuel Galindo                 Modificación
*******************************************************************************/

@isTest private class AAZ_GenericCallout_tst {

		@isTest static void shouldRespondNotSuccessfulTransaction() {

				EndpointSetting__mdt tokenEndpoint = AAZ_Utils_cls.getEndpointSetting('Afore_Authorization');
				String strTokenEndpoint = AAZ_GenericCallout_cls.getEndpoint(tokenEndpoint);

				EndpointSetting__mdt documentsEndpoint = AAZ_Utils_cls.getEndpointSetting('Afore_ForTestingService0');
				String strDocumentsEndpoint = AAZ_GenericCallout_cls.getEndpoint(documentsEndpoint);

				// Create response mocks
				SingleRequestMock tokenMock = new SingleRequestMock('{"signToken":{"signedToken":"ZWQzNzUyZTg5MDk4MzE0YTA1OTY4ZGU0YWI4MjljMzFhYmU5MDNkOTA0NzIzYTlhOGNmNGJhNTAwYjE5YzYwNg==","expiration":"2017-04-26 13:24:19"}}');
				SingleRequestMock documentsMock = new SingleRequestMock('{}');

				// Save response mocks in a MultiRequestMock instance
				MultiRequestMock multiRequestMock = new MultiRequestMock();
				multiRequestMock.addRequestMock(strTokenEndpoint, tokenMock);
				multiRequestMock.addRequestMock(strDocumentsEndpoint, documentsMock);

				Test.setMock(HttpCalloutMock.class, multiRequestMock);

				String STR_CONFNAME = 'Afore_ForTestingService0';
				AAZ_GenericCallout_cls.intTestMode = 4;
				AAZ_GenericCallout_cls.strTestConfigName = STR_CONFNAME;

				Case caseInstance = new Case(
						EmployeeNumberPromoterAgent__c = '63698766',
						Subject = 'Tramite de prueba',
						Description = 'Tramite de prueba',
						EmployeeNumber__c = '210792591',
						idServiceType__c = '123456'
				);
				Database.insert(caseInstance,true);

				Map<String,Object> mapExtraAtts = new Map<String,Object>{
						'system'=>'SFDC',
						'operation'=>'Mesa_Control'
				};

				Map<String,String> mapExtraHeaders = new Map<String,String>{
						'Content-Type' => 'text/plain',
						'Cache-Control' => 'no-caché'
				};

				Test.startTest();
						Boolean blnIsThereAnException = false;
						Map<String, Object> requestMap = AAZ_GenericCallout_cls.generateRequestMap(STR_CONFNAME, new List<SObject>{caseInstance}, mapExtraAtts);
						String strResponse = AAZ_GenericCallout_cls.fn_runCallout(JSON.serializePretty(requestMap), STR_CONFNAME, mapExtraHeaders);
						try{
								Map<String,Object> mapResponse = AAZ_GenericCallout_cls.processServiceResponse(strResponse,STR_CONFNAME);
						}catch(Exception gE){
								blnIsThereAnException=true;
						}

						System.assert(blnIsThereAnException);
						blnIsThereAnException = false;
						AAZ_GenericCallout_cls.intTestMode = 5;
						requestMap = AAZ_GenericCallout_cls.generateRequestMap(STR_CONFNAME, new List<SObject>{caseInstance}, mapExtraAtts);
						strResponse = AAZ_GenericCallout_cls.fn_runCallout(JSON.serializePretty(requestMap), STR_CONFNAME, mapExtraHeaders);
						try{
								Map<String,Object> mapResponse = AAZ_GenericCallout_cls.processServiceResponse(strResponse,STR_CONFNAME);
						}catch(Exception gE){
								blnIsThereAnException=true;
						}
						System.assert(blnIsThereAnException);
						blnIsThereAnException = false;
						AAZ_GenericCallout_cls.intTestMode = 6;
						requestMap = AAZ_GenericCallout_cls.generateRequestMap(STR_CONFNAME, new List<SObject>{caseInstance}, mapExtraAtts);
						strResponse = AAZ_GenericCallout_cls.fn_runCallout(JSON.serializePretty(requestMap), STR_CONFNAME, mapExtraHeaders);
						try{
								Map<String,Object> mapResponse = AAZ_GenericCallout_cls.processServiceResponse(strResponse,STR_CONFNAME);
						}catch(Exception gE){
								blnIsThereAnException=true;
						}
						System.assert(blnIsThereAnException);

						AAZ_GenericCallout_cls.intTestMode = 1;
						AAZ_GenericCallout_cls.setTestMock();
						AAZ_GenericCallout_cls.intTestMode = 2;
						AAZ_GenericCallout_cls.setTestMock();
						AAZ_GenericCallout_cls.intTestMode = 3;
						AAZ_GenericCallout_cls.setTestMock();
						AAZ_GenericCallout_cls.intTestMode = 4;
						AAZ_GenericCallout_cls.setTestMock();
						AAZ_GenericCallout_cls.intTestMode = 5;
						AAZ_GenericCallout_cls.setTestMock();
						AAZ_GenericCallout_cls.intTestMode = 6;
						AAZ_GenericCallout_cls.setTestMock();
						AAZ_GenericCallout_cls.intTestMode = 7;
						AAZ_GenericCallout_cls.setTestMock();
						AAZ_GenericCallout_cls.intTestMode = 8;
						AAZ_GenericCallout_cls.setTestMock();

						ServiceMapping__mdt objMapping = [ SELECT DataType__c, AttributeName__c, DefaultValueTxt__c, DefaultValueBLN__c, DefaultValueNbr__c
							FROM ServiceMapping__mdt LIMIT 1 ];
            System.debug('porfa ='+objMapping);
						AAZ_GenericCallout_cls.assignDefaultAttribute(mapExtraAtts, objMapping);
            
			Test.stopTest();
		}
    @isTest static void newTest() {
        
        EndpointSetting__mdt tokenEndpoint = AAZ_Utils_cls.getEndpointSetting('Afore_Authorization');
				String strTokenEndpoint = AAZ_GenericCallout_cls.getEndpoint(tokenEndpoint);

				EndpointSetting__mdt documentsEndpoint = AAZ_Utils_cls.getEndpointSetting('Afore_ForTestingService1');
				String strDocumentsEndpoint = AAZ_GenericCallout_cls.getEndpoint(documentsEndpoint);

				// Create response mocks
				SingleRequestMock tokenMock = new SingleRequestMock('{"signToken":{"signedToken":"ZWQzNzUyZTg5MDk4MzE0YTA1OTY4ZGU0YWI4MjljMzFhYmU5MDNkOTA0NzIzYTlhOGNmNGJhNTAwYjE5YzYwNg==","expiration":"2017-04-26 13:24:19"}}');
				SingleRequestMock documentsMock = new SingleRequestMock('{}');

				// Save response mocks in a MultiRequestMock instance
				MultiRequestMock multiRequestMock = new MultiRequestMock();
				multiRequestMock.addRequestMock(strTokenEndpoint, tokenMock);
				multiRequestMock.addRequestMock(strDocumentsEndpoint, documentsMock);

				Test.setMock(HttpCalloutMock.class, multiRequestMock);

				String STR_CONFNAME = 'Afore_ForTestingService1';
				AAZ_GenericCallout_cls.intTestMode = 4;
				AAZ_GenericCallout_cls.strTestConfigName = STR_CONFNAME;

				Case caseInstance = new Case(
						EmployeeNumberPromoterAgent__c = '63698766',
						Subject = 'Tramite de prueba',
						Description = 'Tramite de prueba',
						EmployeeNumber__c = '210792591',
						idServiceType__c = '123456'
				);
				Database.insert(caseInstance,true);

        Map<String,Object> mapExtraAtts = new Map<String,Object>{
						'system'=>'SFDC',
						'operation'=>'Mesa_Control'
				};
                    Map<String,String> mapExtraHeaders = new Map<String,String>{
						'Content-Type' => 'text/plain',
						'Cache-Control' => 'no-caché'
				};
        Test.startTest();
        Boolean blnIsThereAnException = false;
						Map<String, Object> requestMap = AAZ_GenericCallout_cls.generateRequestMap(STR_CONFNAME, new List<SObject>{caseInstance}, mapExtraAtts);
						String strResponse = AAZ_GenericCallout_cls.fn_runCallout(JSON.serializePretty(requestMap), STR_CONFNAME, mapExtraHeaders);
						try{
								Map<String,Object> mapResponse = AAZ_GenericCallout_cls.processServiceResponse(strResponse,STR_CONFNAME);
						}catch(Exception gE){
								blnIsThereAnException=true;
						}
        
            ServiceMapping__mdt objMapping2 = [ SELECT DataType__c, AttributeName__c, DefaultValueTxt__c, DefaultValueBLN__c, DefaultValueNbr__c
							FROM ServiceMapping__mdt WHERE DataType__c='STRING' LIMIT 1 ];
						AAZ_GenericCallout_cls.assignDefaultAttribute(mapExtraAtts, objMapping2);
            ServiceMapping__mdt objMapping3 = [ SELECT DataType__c, AttributeName__c, DefaultValueTxt__c, DefaultValueBLN__c, DefaultValueNbr__c
							FROM ServiceMapping__mdt WHERE DataType__c='BOOLEAN' LIMIT 1 ];
						AAZ_GenericCallout_cls.assignDefaultAttribute(mapExtraAtts, objMapping3);
            ServiceMapping__mdt objMapping4 = [ SELECT DataType__c, AttributeName__c, DefaultValueTxt__c, DefaultValueBLN__c, DefaultValueNbr__c
							FROM ServiceMapping__mdt WHERE DataType__c='INTEGER' LIMIT 1 ];
						AAZ_GenericCallout_cls.assignDefaultAttribute(mapExtraAtts, objMapping4);
        ServiceMapping__mdt objMapping5 = [ SELECT DataType__c, AttributeName__c, DefaultValueTxt__c, DefaultValueBLN__c, DefaultValueNbr__c
							FROM ServiceMapping__mdt WHERE DataType__c='NUMBER' LIMIT 1 ];
						AAZ_GenericCallout_cls.assignDefaultAttribute(mapExtraAtts, objMapping5);
			Test.stopTest();
    }

		/**
		 * Prueba para el método setResultAttribute en caso que mapResponse venga vacio
		 * @type void
		 */
		 @isTest static void testMethodTwo() {

				 Map<String, Object> mapResult = new Map<String, Object>();

				 Map<String, Object> mapResponse = new Map<String, Object>();

				 ServiceMapping__mdt mapping = [
						SELECT Id, DataType__c, AttributeName__c, ObjectField__c, ObjectName__c
						FROM ServiceMapping__mdt
						WHERE DataType__c!='' AND AttributeName__c != '' AND ObjectField__c != ''
						AND ObjectName__c != ''
						LIMIT 1
				 ];

				 EndpointSetting__mdt objEndpointSetting = [
				 		SELECT Description__c, DeveloperName, DevelopmentEndpoint__c, EmailCC__c,
							EmailTo__c, Endpoint__c, Id, IsActive__c, Label, Language, MasterLabel,
							MethodName__c, NamespacePrefix, NotifyException__c, OperationCode__c,
							ProductionEndpoint__c, QAEndpoint__c, QualifiedApiName, RequestBodyType__c,
							RequiresBodyEncryption__c, RequiresToken__c, ResponseBodyType__c,
							ServiceMethod__c, ServiceName__c, ServiceProvider__c, Stage__c, Timeout__c
						FROM EndpointSetting__mdt
						LIMIT 1
				 ];

		     Test.startTest();
				 		AAZ_GenericCallout_cls.setResultAttribute(mapResult, mapResponse, mapping, objEndpointSetting);
						System.assertEquals(0, mapResult.size());
		     Test.stopTest();
     }

		 /**
 		 * Prueba para el método setResultAttribute en caso que mapResponse contenga
 		 * un BOOLEAN, STRING, DATE, DATETIME, DOUBLE, INTEGER, SOBJECT, STRUCTURE, LIST
 		 * @type void
 		 */
 		 @isTest static void testMethodThree() {

 				 Map<String, Object> mapResult = new Map<String, Object>();

 				 ServiceMapping__mdt mappingB = [
 						SELECT Id, DataType__c, AttributeName__c, ObjectField__c, ObjectName__c
 						FROM ServiceMapping__mdt
 						WHERE DataType__c = 'BOOLEAN'
 						LIMIT 1
 				 ];
				 Map<String, Object> mapResponseB = new Map<String, Object>{
				 		mappingB.AttributeName__c => mappingB.AttributeName__c
				 };

				 ServiceMapping__mdt mappingS = [
 						SELECT Id, DataType__c, AttributeName__c, ObjectField__c, ObjectName__c
 						FROM ServiceMapping__mdt
 						WHERE DataType__c = 'STRING'
 						LIMIT 1
 				 ];
				 Map<String, Object> mapResponseS = new Map<String, Object>{
				 		mappingS.AttributeName__c => mappingS.AttributeName__c
				 };

				 ServiceMapping__mdt mappingD = [
 						SELECT Id, DataType__c, AttributeName__c, ObjectField__c, ObjectName__c
 						FROM ServiceMapping__mdt
 						WHERE DataType__c = 'DATE'
 						LIMIT 1
 				 ];
				 Map<String, Object> mapResponseD = new Map<String, Object>{
				 		mappingD.AttributeName__c => mappingD.AttributeName__c
				 };

				 ServiceMapping__mdt mappingDT = [
 						SELECT Id, DataType__c, AttributeName__c, ObjectField__c, ObjectName__c
 						FROM ServiceMapping__mdt
 						WHERE DataType__c = 'DATETIME'
 						LIMIT 1
 				 ];
				 Map<String, Object> mapResponseDT = new Map<String, Object>{
				 		mappingDT.AttributeName__c => mappingDT.AttributeName__c
				 };

				 ServiceMapping__mdt mappingDB = [
 						SELECT Id, DataType__c, AttributeName__c, ObjectField__c, ObjectName__c
 						FROM ServiceMapping__mdt
 						WHERE DataType__c = 'DOUBLE'
 						LIMIT 1
 				 ];
				 Map<String, Object> mapResponseDB = new Map<String, Object>{
				 		mappingDB.AttributeName__c => mappingDB.AttributeName__c
				 };

				 ServiceMapping__mdt mappingI = [
 						SELECT Id, DataType__c, AttributeName__c, ObjectField__c, ObjectName__c
 						FROM ServiceMapping__mdt
 						WHERE DataType__c = 'INTEGER'
 						LIMIT 1
 				 ];
				 Map<String, Object> mapResponseI = new Map<String, Object>{
				 		mappingI.AttributeName__c => mappingI.AttributeName__c
				 };

				 ServiceMapping__mdt mappingO = [
 						SELECT Id, DataType__c, AttributeName__c, ObjectField__c, ObjectName__c
 						FROM ServiceMapping__mdt
 						WHERE DataType__c = 'SOBJECT'
 						LIMIT 1
 				 ];
				 Map<String, Object> mapResponseO = new Map<String, Object>{
				 		mappingO.AttributeName__c => mappingO.AttributeName__c
				 };

				 ServiceMapping__mdt mappingST = [
 						SELECT Id, DataType__c, AttributeName__c, ObjectField__c, ObjectName__c
 						FROM ServiceMapping__mdt
 						WHERE DataType__c = 'STRUCTURE'
 						LIMIT 1
 				 ];
				 Map<String, Object> mapResponseST = new Map<String, Object>{
				 		mappingST.AttributeName__c => mappingST.AttributeName__c
				 };

				 ServiceMapping__mdt mappingLT = [
 						SELECT Id, DataType__c, AttributeName__c, ObjectField__c, ObjectName__c
 						FROM ServiceMapping__mdt
 						WHERE DataType__c = 'LIST'
 						LIMIT 1
 				 ];
				 Map<String, Object> mapResponseLT = new Map<String, Object>{
				 		mappingLT.AttributeName__c => mappingLT.AttributeName__c
				 };

 				 EndpointSetting__mdt objEndpointSetting = [
 				 		SELECT Description__c, DeveloperName, DevelopmentEndpoint__c, EmailCC__c,
 							EmailTo__c, Endpoint__c, Id, IsActive__c, Label, Language, MasterLabel,
 							MethodName__c, NamespacePrefix, NotifyException__c, OperationCode__c,
 							ProductionEndpoint__c, QAEndpoint__c, QualifiedApiName, RequestBodyType__c,
 							RequiresBodyEncryption__c, RequiresToken__c, ResponseBodyType__c,
 							ServiceMethod__c, ServiceName__c, ServiceProvider__c, Stage__c, Timeout__c
 						FROM EndpointSetting__mdt
 						LIMIT 1
 				 ];

 		     Test.startTest();
				 		// BOOLEAN
 				 		AAZ_GenericCallout_cls.setResultAttribute(mapResult, mapResponseB, mappingB, objEndpointSetting);
						System.assertEquals(1, mapResult.size());
						mapResult = new Map<String, Object>();

						// STRING
						AAZ_GenericCallout_cls.setResultAttribute(mapResult, mapResponseS, mappingS, objEndpointSetting);
						System.assertEquals(1, mapResult.size());
						mapResult = new Map<String, Object>();

						// DATE
						AAZ_GenericCallout_cls.setResultAttribute(mapResult, mapResponseD, mappingD, objEndpointSetting);
						System.assertEquals(1, mapResult.size());
						mapResult = new Map<String, Object>();

						// DATETIME
						AAZ_GenericCallout_cls.setResultAttribute(mapResult, mapResponseDT, mappingDT, objEndpointSetting);
						System.assertEquals(1, mapResult.size());
						mapResult = new Map<String, Object>();

						// DOUBLE
						AAZ_GenericCallout_cls.setResultAttribute(mapResult, mapResponseDB, mappingDB, objEndpointSetting);
						System.assertEquals(1, mapResult.size());
						mapResult = new Map<String, Object>();

						// INTEGER
						AAZ_GenericCallout_cls.setResultAttribute(mapResult, mapResponseI, mappingI, objEndpointSetting);
						System.assertEquals(1, mapResult.size());
						mapResult = new Map<String, Object>();

						// SOBJECT
						AAZ_GenericCallout_cls.setResultAttribute(mapResult, mapResponseO, mappingO, objEndpointSetting);
						System.assertEquals(1, mapResult.size());
						mapResult = new Map<String, Object>();

						// STRUCTURE
						AAZ_GenericCallout_cls.setResultAttribute(mapResult, mapResponseST, mappingST, objEndpointSetting);
						System.assertEquals(1, mapResult.size());
						mapResult = new Map<String, Object>();

						// LIST
						AAZ_GenericCallout_cls.setResultAttribute(mapResult, mapResponseLT, mappingLT, objEndpointSetting);
						System.assertEquals(1, mapResult.size());
						mapResult = new Map<String, Object>();

 		     Test.stopTest();
      }

			/**
			* Prueba del método setObjectField en caso que mapResponse venga vacío
			* @type void
			*/
			@isTest static void testMethodFour() {

					Account objResult = new Account();

					Map<String, Object> mapResponse = new Map<String, Object>();

					ServiceMapping__mdt mapping = [
 						SELECT Id, DataType__c, AttributeName__c, ObjectField__c, ObjectName__c
 						FROM ServiceMapping__mdt
 						WHERE DataType__c!='' AND AttributeName__c != '' AND ObjectField__c != ''
 						AND ObjectName__c != ''
 						LIMIT 1
 				  ];

 				  EndpointSetting__mdt objEndpointSetting = [
 				 		SELECT Description__c, DeveloperName, DevelopmentEndpoint__c, EmailCC__c,
 							EmailTo__c, Endpoint__c, Id, IsActive__c, Label, Language, MasterLabel,
 							MethodName__c, NamespacePrefix, NotifyException__c, OperationCode__c,
 							ProductionEndpoint__c, QAEndpoint__c, QualifiedApiName, RequestBodyType__c,
 							RequiresBodyEncryption__c, RequiresToken__c, ResponseBodyType__c,
 							ServiceMethod__c, ServiceName__c, ServiceProvider__c, Stage__c, Timeout__c
 						FROM EndpointSetting__mdt
 						LIMIT 1
 				  ];

					Map<String, Object> mapResult = new Map<String, Object>();

			    Test.startTest();

						AAZ_GenericCallout_cls.setObjectField(objResult, mapResponse, mapping, objEndpointSetting, mapResult);

					Test.stopTest();
			}

			/**
			* Prueba del método setObjectField en caso que mapResponse contenga
			* BOOLEAN, STRING, DATE, DATETIME, DOUBLE, INTEGER, STRUCTURE, LIST
			* @type void
			*/
			@isTest static void testMethodFive() {

					Account objResult = new Account();

					Map<String, Object> mapResult = new Map<String, Object>();

  				 ServiceMapping__mdt mappingB = [
  						SELECT Id, DataType__c, AttributeName__c, ObjectField__c, ObjectName__c
  						FROM ServiceMapping__mdt
  						WHERE DataType__c = 'BOOLEAN'
  						LIMIT 1
  				 ];
 				 Map<String, Object> mapResponseB = new Map<String, Object>{
 				 		mappingB.AttributeName__c => mappingB.AttributeName__c
 				 };

 				 ServiceMapping__mdt mappingS = [
  						SELECT Id, DataType__c, AttributeName__c, ObjectField__c, ObjectName__c
  						FROM ServiceMapping__mdt
  						WHERE DataType__c = 'STRING'
  						LIMIT 1
  				 ];
 				 Map<String, Object> mapResponseS = new Map<String, Object>{
 				 		mappingS.AttributeName__c => mappingS.AttributeName__c
 				 };

 				 ServiceMapping__mdt mappingD = [
  						SELECT Id, DataType__c, AttributeName__c, ObjectField__c, ObjectName__c
  						FROM ServiceMapping__mdt
  						WHERE DataType__c = 'DATE'
  						LIMIT 1
  				 ];
 				 Map<String, Object> mapResponseD = new Map<String, Object>{
 				 		mappingD.AttributeName__c => mappingD.AttributeName__c
 				 };

 				 ServiceMapping__mdt mappingDT = [
  						SELECT Id, DataType__c, AttributeName__c, ObjectField__c, ObjectName__c
  						FROM ServiceMapping__mdt
  						WHERE DataType__c = 'DATETIME'
  						LIMIT 1
  				 ];
 				 Map<String, Object> mapResponseDT = new Map<String, Object>{
 				 		mappingDT.AttributeName__c => mappingDT.AttributeName__c
 				 };

 				 ServiceMapping__mdt mappingDB = [
  						SELECT Id, DataType__c, AttributeName__c, ObjectField__c, ObjectName__c
  						FROM ServiceMapping__mdt
  						WHERE DataType__c = 'DOUBLE'
  						LIMIT 1
  				 ];
 				 Map<String, Object> mapResponseDB = new Map<String, Object>{
 				 		mappingDB.AttributeName__c => mappingDB.AttributeName__c
 				 };

 				 ServiceMapping__mdt mappingI = [
  						SELECT Id, DataType__c, AttributeName__c, ObjectField__c, ObjectName__c
  						FROM ServiceMapping__mdt
  						WHERE DataType__c = 'INTEGER'
  						LIMIT 1
  				 ];
 				 Map<String, Object> mapResponseI = new Map<String, Object>{
 				 		mappingI.AttributeName__c => mappingI.AttributeName__c
 				 };

 				 ServiceMapping__mdt mappingO = [
  						SELECT Id, DataType__c, AttributeName__c, ObjectField__c, ObjectName__c
  						FROM ServiceMapping__mdt
  						WHERE DataType__c = 'SOBJECT'
  						LIMIT 1
  				 ];
 				 Map<String, Object> mapResponseO = new Map<String, Object>{
 				 		mappingO.AttributeName__c => mappingO.AttributeName__c
 				 };

 				 ServiceMapping__mdt mappingST = [
  						SELECT Id, DataType__c, AttributeName__c, ObjectField__c, ObjectName__c
  						FROM ServiceMapping__mdt
  						WHERE DataType__c = 'STRUCTURE'
  						LIMIT 1
  				 ];
 				 Map<String, Object> mapResponseST = new Map<String, Object>{
 				 		mappingST.AttributeName__c => mappingST.AttributeName__c
 				 };

 				 ServiceMapping__mdt mappingLT = [
  						SELECT Id, DataType__c, AttributeName__c, ObjectField__c, ObjectName__c
  						FROM ServiceMapping__mdt
  						WHERE DataType__c = 'LIST'
  						LIMIT 1
  				 ];
 				 Map<String, Object> mapResponseLT = new Map<String, Object>{
 				 		mappingLT.AttributeName__c => mappingLT.AttributeName__c
 				 };

  				 EndpointSetting__mdt objEndpointSetting = [
  				 		SELECT Description__c, DeveloperName, DevelopmentEndpoint__c, EmailCC__c,
  							EmailTo__c, Endpoint__c, Id, IsActive__c, Label, Language, MasterLabel,
  							MethodName__c, NamespacePrefix, NotifyException__c, OperationCode__c,
  							ProductionEndpoint__c, QAEndpoint__c, QualifiedApiName, RequestBodyType__c,
  							RequiresBodyEncryption__c, RequiresToken__c, ResponseBodyType__c,
  							ServiceMethod__c, ServiceName__c, ServiceProvider__c, Stage__c, Timeout__c
  						FROM EndpointSetting__mdt
  						LIMIT 1
  				 ];

			    Test.startTest();

						// BOOLEAN
						AAZ_GenericCallout_cls.setObjectField(objResult, mapResponseB, mappingB, objEndpointSetting, mapResult);
						System.assertEquals(0, mapResult.size());
						objResult = new Account();

						// STRING
						AAZ_GenericCallout_cls.setObjectField(objResult, mapResponseS, mappingS, objEndpointSetting, mapResult);
						System.assertEquals(0, mapResult.size());
						objResult = new Account();

						// DATE
						AAZ_GenericCallout_cls.setObjectField(objResult, mapResponseD, mappingD, objEndpointSetting, mapResult);
						System.assertEquals(0, mapResult.size());
						objResult = new Account();

						// DATETIME
						AAZ_GenericCallout_cls.setObjectField(objResult, mapResponseDT, mappingDT, objEndpointSetting, mapResult);
						System.assertEquals(0, mapResult.size());
						objResult = new Account();

						// DOUBLE
						AAZ_GenericCallout_cls.setObjectField(objResult, mapResponseDB, mappingDB, objEndpointSetting, mapResult);
						System.assertEquals(0, mapResult.size());
						objResult = new Account();

						// INTEGER
						AAZ_GenericCallout_cls.setObjectField(objResult, mapResponseI, mappingI, objEndpointSetting, mapResult);
						System.assertEquals(0, mapResult.size());
						objResult = new Account();

						// SOBJECT
						AAZ_GenericCallout_cls.setObjectField(objResult, mapResponseO, mappingO, objEndpointSetting, mapResult);
						System.assertEquals(0, mapResult.size());
						objResult = new Account();

						// STRUCTURE
						AAZ_GenericCallout_cls.setObjectField(objResult, mapResponseST, mappingST, objEndpointSetting, mapResult);
						System.assertEquals(0, mapResult.size());
						objResult = new Account();

						// LIST
						AAZ_GenericCallout_cls.setObjectField(objResult, mapResponseLT, mappingLT, objEndpointSetting, mapResult);
						System.assertEquals(0, mapResult.size());
						objResult = new Account();
					Test.stopTest();
			}
}