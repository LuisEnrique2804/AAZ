@isTest
public class AAZ_AgentQuery_tst {
    
    @testSetup
    static void setup() {
        // Crear configuración global de la app
        //AppMainSetting_cs__c mainSettings = Test.isRunningTest()?
        //AAZ_TestUtils_tst.getMainSettings() : AppMainSetting_cs__c.getOrgDefaults();
        // Configuración para métodos de prueba


          String  profileName = Label.AAZ_AdministratorProfile; // Colocar en Etiqueta Personalizada 
          String   username = Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '@test.com';
          String   password = Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000);


        Profile p = [ SELECT Id FROM Profile WHERE Name=:profileName ];

        User usr = new User(
            Alias             = username.substringAfterLast('@'),
            Email             = username,
            EmailEncodingKey  = 'UTF-8',
            LastName          = username,
            LanguageLocaleKey = 'es_MX',
            LocaleSidKey      = 'es_MX',
            ProfileId         = p.Id,
            TimeZoneSidKey    = 'America/Mexico_City',
            UserName          = username

        );

        Case cas = new Case(
            Subject = 'Prueba',
            employeeNumber__c='teste'
        );
        insert cas;
   }


    @isTest
    static void should_get_case_documents() {

        User usr = [SELECT Id FROM User LIMIT 1];
        Case caso = [SELECT Id, employeeNumber__c, idServiceType__c, caseNumber, Account.NSS__c, FolioNSS__c FROM Case LIMIT 1];

        // Get endpoints for services
        EndpointSetting__mdt tokenEndpoint = AAZ_Utils_cls.getEndpointSetting('Afore_Authorization');
        String strTokenEndpoint = AAZ_GenericCallout_cls.getEndpoint(tokenEndpoint);

        EndpointSetting__mdt referencesEndpoint = AAZ_Utils_cls.getEndpointSetting('Afore_QueryAgent');
        String strReferencesEndpoint = AAZ_GenericCallout_cls.getEndpoint(referencesEndpoint);

        // Create response mocks
        SingleRequestMock tokenMock = new SingleRequestMock('{"signToken":{"signedToken":"ZWQzNzUyZTg5MDk4MzE0YTA1OTY4ZGU0YWI4MjljMzFhYmU5MDNkOTA0NzIzYTlhOGNmNGJhNTAwYjE5YzYwNg==","expiration":"2017-04-26 13:24:19"}}');
        SingleRequestMock referencesMock = new SingleRequestMock('{"Out_ConsultaAgentes":{"employedServiceRs":{"isSucessful":"true","references":{"reference":[{"EmployeeNumber__c":"test","LastName":"test","PaternalLastName__c":"test","MaternalLastName__c":"test","FirstName ":"test","AdmitionDate__c ":"2017-09-22-05:00","LevelStudy__c ":"test","Birthdate ":"2017-04-26 13:24:19","Phone":"1111111111","Status__c ":"teste","weeks__c":"teste","productivity__c":"teste","numberNewWorkers__c":"teste","Status__c":"teste","NumberLocks__c":"1111","numberTI__c ":"1111","admitionDateEKT__c":"2017-09-22-05:00","SucursalNumber__c":"1111"}]}}}}');

        // Save response mocks in a MultiRequestMock instance
        MultiRequestMock multiRequestMock = new MultiRequestMock();
        multiRequestMock.addRequestMock(strTokenEndpoint, tokenMock);
        multiRequestMock.addRequestMock(strReferencesEndpoint, referencesMock);

        Test.setMock(HttpCalloutMock.class, multiRequestMock);

        Test.startTest();
            AAZ_AgentQuery_cls.getLockUnlockAPList(new SObject[]{ caso }, null);
        Test.stopTest();

        // Documentos del Caso
        Contact[] foundAgent = new List <Contact>([ SELECT 
                          EmployeeNumber__c,
                          PaternalLastName__c,
                           MaternalLastName__c,
                           AdmitionDate__c,  
                           LevelStudy__c,    
                           Status__c,          
                           weeks__c,          
                           productivity__c,    
                           numberNewWorkers__c,
                           NumberLocks__c,     
                           numberTI__c,      
                           admitionDateEKT__c, 
                           SucursalNumber__c
            FROM  Contact ]);
    }

}