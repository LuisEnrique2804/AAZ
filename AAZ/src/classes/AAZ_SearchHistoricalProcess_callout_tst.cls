@isTest public class AAZ_SearchHistoricalProcess_callout_tst {
    @testSetup static void AAZ_DocumentQueryWS(){

          String  profileName = Label.AAZ_AdministratorProfile; // Colocar en Etiqueta Personalizada
          String   username = Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '@test.com';
          String   password = Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000);

        Profile p = [ SELECT Id FROM Profile WHERE Name=:profileName ];


    }
    
    @isTest public static void should_do_callOut() {

        //User usr = [SELECT Id FROM User LIMIT 1];
        //Case caso = [SELECT Id, employeeNumber__c, idServiceType__c, caseNumber, APValidationContact__c, Contact.NSS__c, Contact.Id, Account.NSS__c, FolioNSS__c FROM Case LIMIT 1];

        // Get endpoints for services
        EndpointSetting__mdt tokenEndpoint = AAZ_Utils_cls.getEndpointSetting('Afore_Authorization');
        String strTokenEndpoint = AAZ_GenericCallout_cls.getEndpoint(tokenEndpoint);
         EndpointSetting__mdt referencesEndpoint = AAZ_Utils_cls.getEndpointSetting('SearchHistoricalProcess');
        String strReferencesEndpoint = AAZ_GenericCallout_cls.getEndpoint(referencesEndpoint);

        // Create response mocks
        SingleRequestMock tokenMock = new SingleRequestMock('{"signToken":{"signedToken":"ZWQzNzUyZTg5MDk4MzE0YTA1OTY4ZGU0YWI4MjljMzFhYmU5MDNkOTA0NzIzYTlhOGNmNGJhNTAwYjE5YzYwNg==","expiration":"2017-04-26 13:24:19"}}');
        SingleRequestMock referencesMock = new SingleRequestMock('{ "Out_ConsultaHistoricos":{ "isSucessful":true, "errorList":{ "code":"0", "description":"Cargando la información" } } }');

        // Save response mocks in a MultiRequestMock instance
        MultiRequestMock multiRequestMock = new MultiRequestMock();
        multiRequestMock.addRequestMock(strTokenEndpoint, tokenMock);
        multiRequestMock.addRequestMock(strReferencesEndpoint, referencesMock);

        Test.setMock(HttpCalloutMock.class, multiRequestMock);
        
    AAZ_SearchHistoricalProcess_callout.SearchObject wrapper = new AAZ_SearchHistoricalProcess_callout.SearchObject();
        wrapper.startDate='10/10/2017'; 
        wrapper.endDate ='15/10/2017';
        wrapper.nss ='83856405523'; 
        wrapper.curp ='DIRA640508HTCZDN00'; 
        wrapper.rfc ='JSKM89548'; 
        wrapper.status ='Nuevo'; 
        wrapper.serviceType ='Afiliacion'; 
        wrapper.serviceSubType ='Traspaso'; 
        wrapper.withdrawtype ='tst';
        wrapper.securitytype ='securityType';
        wrapper.pensiontype ='PensionType';
        wrapper.regimeType ='RegimenType';
        wrapper.divisional ='Divisional';
        wrapper.estate ='EstadoTst';
        wrapper.municipality ='MunTst'; 
        wrapper.regional ='RegionTst';
        wrapper.implement ='implementTst';
        wrapper.promoterAgent ='PromoterTst';
        wrapper.analistValidate ='2345678';
        wrapper.apNumber ='278323';
        wrapper.idSearch = 'a0Cg0000007l4ihEAA';
        Test.startTest();
        AAZ_SearchHistoricalProcess_callout.callOut(wrapper);
        Test.stopTest();
       }
   @isTest public static AAZ_SearchHistoricalProcess_callout.ResponseWrapper Wresponse (){
       AAZ_SearchHistoricalProcess_callout.ResponseWrapper wrapper2 = new AAZ_SearchHistoricalProcess_callout.ResponseWrapper();
       
       // Get endpoints for services
        EndpointSetting__mdt tokenEndpoint = AAZ_Utils_cls.getEndpointSetting('Afore_Authorization');
        String strTokenEndpoint = AAZ_GenericCallout_cls.getEndpoint(tokenEndpoint);
         EndpointSetting__mdt referencesEndpoint = AAZ_Utils_cls.getEndpointSetting('SearchHistoricalProcess');
        String strReferencesEndpoint = AAZ_GenericCallout_cls.getEndpoint(referencesEndpoint);

        // Create response mocks
        SingleRequestMock tokenMock = new SingleRequestMock('{"signToken":{"signedToken":"ZWQzNzUyZTg5MDk4MzE0YTA1OTY4ZGU0YWI4MjljMzFhYmU5MDNkOTA0NzIzYTlhOGNmNGJhNTAwYjE5YzYwNg==","expiration":"2017-04-26 13:24:19"}}');
        SingleRequestMock referencesMock = new SingleRequestMock('{ "Out_ConsultaHistoricos":{ "isSucessful":true, "errorList":{ "code":"0", "description":"Cargando la información" } } }');

        // Save response mocks in a MultiRequestMock instance
        MultiRequestMock multiRequestMock = new MultiRequestMock();
        multiRequestMock.addRequestMock(strTokenEndpoint, tokenMock);
        multiRequestMock.addRequestMock(strReferencesEndpoint, referencesMock);

        Test.setMock(HttpCalloutMock.class, multiRequestMock);
        
    AAZ_SearchHistoricalProcess_callout.SearchObject wrapper = new AAZ_SearchHistoricalProcess_callout.SearchObject();
        wrapper.startDate='10/10/2017'; 
        wrapper.endDate ='15/10/2017';
        wrapper.nss ='83856405523'; 
        wrapper.curp ='DIRA640508HTCZDN00'; 
        wrapper.rfc ='JSKM89548'; 
        wrapper.status ='Nuevo'; 
        wrapper.serviceType ='Afiliacion'; 
        wrapper.serviceSubType ='Traspaso'; 
        wrapper.withdrawtype ='tst';
        wrapper.securitytype ='securityType';
        wrapper.pensiontype ='PensionType';
        wrapper.regimeType ='RegimenType';
        wrapper.divisional ='Divisional';
        wrapper.estate ='EstadoTst';
        wrapper.municipality ='MunTst'; 
        wrapper.regional ='RegionTst';
        wrapper.implement ='implementTst';
        wrapper.promoterAgent ='PromoterTst';
        wrapper.analistValidate ='2345678';
        wrapper.apNumber ='278323';
        wrapper.idSearch = 'a0Cg0000007l4ihEAA';
        wrapper2= AAZ_SearchHistoricalProcess_callout.callOut(wrapper);
       
       
       return wrapper2;
    }
    

}