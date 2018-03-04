@isTest
public class AAZ_PromoterAgentClient_tst {

    @isTest static void should_get_promoter_agent() {
   
    
    List<Id> lstCaseIds = new List<Id> ();
    
    Contact contactInstance = new Contact(
          LastName = 'LastName',
          employeeNumber__c = '1234567'
        ); 
        insert contactInstance;
        Account account = new Account ();
        account.LastName='teste';
        account.NSS__c = '11111111111';
        account.RecordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cuenta personal').getRecordTypeId();
        
        insert account;

   Case caso1 = new Case ();
  //caso1.CaseNumber=3333;
    caso1.FolioNSS__c='teste';
    caso1.ContactId= contactInstance.Id;    
    caso1.AccountId= account.Id;
    caso1.idServiceType__c = '123';
    caso1.employeeNumber__c = '1234567';
    insert caso1;
    
   lstCaseIds.add(caso1.id);

   // Get endpoints for services
        EndpointSetting__mdt tokenEndpoint = AAZ_Utils_cls.getEndpointSetting('Afore_Authorization');
        String strTokenEndpoint = AAZ_GenericCallout_cls.getEndpoint(tokenEndpoint);
         EndpointSetting__mdt referencesEndpoint = AAZ_Utils_cls.getEndpointSetting('Afore_QueryAgent');
        String strReferencesEndpoint = AAZ_GenericCallout_cls.getEndpoint(referencesEndpoint);

        // Create response mocks
        SingleRequestMock tokenMock = new SingleRequestMock('{"signToken":{"signedToken":"ZWQzNzUyZTg5MDk4MzE0YTA1OTY4ZGU0YWI4MjljMzFhYmU5MDNkOTA0NzIzYTlhOGNmNGJhNTAwYjE5YzYwNg==","expiration":"2017-04-26 13:24:19"}}');
        SingleRequestMock referencesMock = new SingleRequestMock('{"Out_ConsultaAgentes":{"employedServiceRs":{"isSucessful":"true","employeeNumber":"1234567","paternalLastName":"true","maternalLastName":"true","firstName":"true","admitionDatePosition":"2017-12-12","schoolGrade":"true","birthDate":"true","phone":"true","statusAP":"true","weeks":"true","productivity":"true","numberNewWorkers":"true","status":"true","NumberLocks":"true","numberTI":"true","admitionDateEKT":"2017-12-12","SucursalNumber":"true"}}}');

        // Save response mocks in a MultiRequestMock instance
        MultiRequestMock multiRequestMock = new MultiRequestMock();
        multiRequestMock.addRequestMock(strTokenEndpoint, tokenMock);
        multiRequestMock.addRequestMock(strReferencesEndpoint, referencesMock);

        Test.setMock(HttpCalloutMock.class, multiRequestMock);

    Test.startTest();
    AAZ_PromoterAgentClient_cls.getPromoterAgentAsync(lstCaseIds);
          Test.stopTest();
  
           }

  // Consulta de Agente promotor con error
  @isTest static void should_not_get_promoter_agent() {
   
    List<Id> lstCaseIds = new List<Id> ();
    
    Contact contactInstance = new Contact(
          LastName = 'LastName',
          employeeNumber__c = '1234567'
        ); 
        insert contactInstance;
        Account account = new Account ();
        account.LastName='teste';
        account.NSS__c = '11111111111';
        account.RecordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cuenta personal').getRecordTypeId();
        
        insert account;

   Case caso1 = new Case ();
  //caso1.CaseNumber=3333;
    caso1.FolioNSS__c='teste';
    caso1.ContactId= contactInstance.Id;    
    caso1.AccountId= account.Id;
    caso1.idServiceType__c = '123';
    caso1.employeeNumber__c = '1234567';
    insert caso1;
    
   lstCaseIds.add(caso1.id);

   // Get endpoints for services
        EndpointSetting__mdt tokenEndpoint = AAZ_Utils_cls.getEndpointSetting('Afore_Authorization');
        String strTokenEndpoint = AAZ_GenericCallout_cls.getEndpoint(tokenEndpoint);
         EndpointSetting__mdt referencesEndpoint = AAZ_Utils_cls.getEndpointSetting('Afore_QueryAgent');
        String strReferencesEndpoint = AAZ_GenericCallout_cls.getEndpoint(referencesEndpoint);

        // Create response mocks
        SingleRequestMock tokenMock = new SingleRequestMock('{"signToken":{"signedToken":"ZWQzNzUyZTg5MDk4MzE0YTA1OTY4ZGU0YWI4MjljMzFhYmU5MDNkOTA0NzIzYTlhOGNmNGJhNTAwYjE5YzYwNg==","expiration":"2017-04-26 13:24:19"}}');
        SingleRequestMock referencesMock = new SingleRequestMock('null');

        // Save response mocks in a MultiRequestMock instance
        MultiRequestMock multiRequestMock = new MultiRequestMock();
        multiRequestMock.addRequestMock(strTokenEndpoint, tokenMock);
        multiRequestMock.addRequestMock(strReferencesEndpoint, referencesMock);

        Test.setMock(HttpCalloutMock.class, multiRequestMock);

    Test.startTest();
    AAZ_PromoterAgentClient_cls.getPromoterAgentAsync(lstCaseIds);
          Test.stopTest();
  
           }
}