@isTest
private class AAZ_SecurityServices_tst {
    
    @TestSetup static void setup() {
        
        //AppMainSetting_cs__c mainSettings = Test.isRunningTest()?
        //AAZ_TestUtils_tst.getMainSettings() : AppMainSetting_cs__c.getOrgDefaults();
        //insert mainSettings;

        String username = 'testeuser@azteca.com';
        Profile p = [ SELECT Id FROM Profile WHERE Name = 'Analista Validador' LIMIT 1 ];
        User thisUser = new User (
            Alias = 'qawsedq',
            Email = username,
            EmailEncodingKey = 'UTF-8',
            LastName = 'LastName',
            LanguageLocaleKey = 'es_MX',
            LocaleSidKey = 'es_MX',
            ProfileId = p.Id,
            TimeZoneSidKey = 'America/Mexico_City',
            UserName = username,
            IsActive = true,
            EmployeeNumber = '1234567890'
        );

        insert thisUser;

    }

    @isTest static void test_method_getPlainToken() {

        User thisUser = [ SELECT EmployeeNumber, LastName FROM User  WHERE EmployeeNumber='1234567890' LIMIT 1 ];
System.debug('aqui pinches esta='+thisUser);
        //AppMainSetting_cs__c mainSettings = AppMainSetting_cs__c.getOrgDefaults();
        AppMainSetting_cs__c mainSettings = Test.isRunningTest()?
        AAZ_TestUtils_tst.getMainSettings() : AppMainSetting_cs__c.getOrgDefaults();
        
        String tokenUsername = thisUser.EmployeeNumber;
        String tokenPassword = mainSettings.PasswordServiceToken__c;
        // Get endpoints for services
        EndpointSetting__mdt tokenEndpoint = AAZ_Utils_cls.getEndpointSetting('Afore_Authorization');
        String strTokenEndpoint = AAZ_GenericCallout_cls.getEndpoint(tokenEndpoint);

        EndpointSetting__mdt referencesEndpoint = AAZ_Utils_cls.getEndpointSetting('AAZ_SecurityServices');
        String strReferencesEndpoint = AAZ_GenericCallout_cls.getEndpoint(referencesEndpoint);

        // Create response mocks
        SingleRequestMock tokenMock = new SingleRequestMock('{"signToken":{"signedToken":"ZWQzNzUyZTg5MDk4MzE0YTA1OTY4ZGU0YWI4MjljMzFhYmU5MDNkOTA0NzIzYTlhOGNmNGJhNTAwYjE5YzYwNg==","expiration":"2017-04-26 13:24:19"}}');
        SingleRequestMock referencesMock = new SingleRequestMock('{}');
    
        // Save response mocks in a MultiRequestMock instance
        MultiRequestMock multiRequestMock = new MultiRequestMock();
        multiRequestMock.addRequestMock(strTokenEndpoint, tokenMock);
        multiRequestMock.addRequestMock(strReferencesEndpoint, referencesMock);

        Test.setMock(HttpCalloutMock.class, multiRequestMock);
    
        
        Test.startTest();
            AAZ_SecurityServices_cls.getPlainToken( tokenUsername, tokenPassword );
            AAZ_SecurityServices_cls.encryptPassword( 'testeap', '1ZRqah8/mgDGetKXKOmE1g==', 'AES128' );
            //AAZ_SecurityServices_cls.deleteTibcoUser(String.valueOf(thisUser));
            //AAZ_SecurityServices_cls.createTibcoUser(thisUser.Id);
            //AAZ_SecurityServices_cls.decryptPassword( 'testeap', String.valueOf(Crypto.generateAesKey(128)), 'AES128' );
            //AAZ_SecurityServices_cls.encryptPassword( '', String.valueOf(Crypto.generateAesKey(128)), 'AES128' );
        Test.stopTest();
    }
    
    @isTest static void test_method_createTibcoUser() {

        User thisUser = [ SELECT EmployeeNumber, LastName FROM User  WHERE EmployeeNumber='1234567890' LIMIT 1 ];
System.debug('aqui pinches esta='+thisUser);
        //AppMainSetting_cs__c mainSettings = AppMainSetting_cs__c.getOrgDefaults();
        AppMainSetting_cs__c mainSettings = Test.isRunningTest()?
        AAZ_TestUtils_tst.getMainSettings() : AppMainSetting_cs__c.getOrgDefaults();
        
        String tokenUsername = thisUser.EmployeeNumber;
        String tokenPassword = mainSettings.PasswordServiceToken__c;
        // Get endpoints for services
        EndpointSetting__mdt tokenEndpoint = AAZ_Utils_cls.getEndpointSetting('Afore_AddUserRs');
        String strTokenEndpoint = AAZ_GenericCallout_cls.getEndpoint(tokenEndpoint);

        EndpointSetting__mdt referencesEndpoint = AAZ_Utils_cls.getEndpointSetting('AAZ_SecurityServices');
        String strReferencesEndpoint = AAZ_GenericCallout_cls.getEndpoint(referencesEndpoint);

        // Create response mocks
        SingleRequestMock tokenMock = new SingleRequestMock('{"signToken":{"signedToken":"ZWQzNzUyZTg5MDk4MzE0YTA1OTY4ZGU0YWI4MjljMzFhYmU5MDNkOTA0NzIzYTlhOGNmNGJhNTAwYjE5YzYwNg==","expiration":"2017-04-26 13:24:19"}}');
        SingleRequestMock referencesMock = new SingleRequestMock('{}');
    
        // Save response mocks in a MultiRequestMock instance
        MultiRequestMock multiRequestMock = new MultiRequestMock();
        multiRequestMock.addRequestMock(strTokenEndpoint, tokenMock);
        multiRequestMock.addRequestMock(strReferencesEndpoint, referencesMock);

        Test.setMock(HttpCalloutMock.class, multiRequestMock);
    
        
        Test.startTest();
            //AAZ_SecurityServices_cls.getPlainToken( tokenUsername, tokenPassword );
            //AAZ_SecurityServices_cls.encryptPassword( 'testeap', '1ZRqah8/mgDGetKXKOmE1g==', 'AES128' );
            //AAZ_SecurityServices_cls.deleteTibcoUser(String.valueOf(thisUser));
            AAZ_SecurityServices_cls.createTibcoUser(thisUser.Id);
            //AAZ_SecurityServices_cls.decryptPassword( 'testeap', String.valueOf(Crypto.generateAesKey(128)), 'AES128' );
            //AAZ_SecurityServices_cls.encryptPassword( '', String.valueOf(Crypto.generateAesKey(128)), 'AES128' );
        Test.stopTest();
    }
    @isTest static void test_method_deleteTibcoUser() {

        User thisUser = [ SELECT EmployeeNumber, LastName FROM User  WHERE EmployeeNumber='1234567890' LIMIT 1 ];
System.debug('aqui pinches esta='+thisUser);
        //AppMainSetting_cs__c mainSettings = AppMainSetting_cs__c.getOrgDefaults();
        AppMainSetting_cs__c mainSettings = Test.isRunningTest()?
        AAZ_TestUtils_tst.getMainSettings() : AppMainSetting_cs__c.getOrgDefaults();
        
        String tokenUsername = thisUser.EmployeeNumber;
        String tokenPassword = mainSettings.PasswordServiceToken__c;
        // Get endpoints for services
        EndpointSetting__mdt tokenEndpoint = AAZ_Utils_cls.getEndpointSetting('Afore_OutUserRs');
        String strTokenEndpoint = AAZ_GenericCallout_cls.getEndpoint(tokenEndpoint);

        EndpointSetting__mdt referencesEndpoint = AAZ_Utils_cls.getEndpointSetting('AAZ_SecurityServices');
        String strReferencesEndpoint = AAZ_GenericCallout_cls.getEndpoint(referencesEndpoint);

        // Create response mocks
        SingleRequestMock tokenMock = new SingleRequestMock('{"signToken":{"signedToken":"ZWQzNzUyZTg5MDk4MzE0YTA1OTY4ZGU0YWI4MjljMzFhYmU5MDNkOTA0NzIzYTlhOGNmNGJhNTAwYjE5YzYwNg==","expiration":"2017-04-26 13:24:19"}}');
        SingleRequestMock referencesMock = new SingleRequestMock('{}');
    
        // Save response mocks in a MultiRequestMock instance
        MultiRequestMock multiRequestMock = new MultiRequestMock();
        multiRequestMock.addRequestMock(strTokenEndpoint, tokenMock);
        multiRequestMock.addRequestMock(strReferencesEndpoint, referencesMock);

        Test.setMock(HttpCalloutMock.class, multiRequestMock);
    
        
        Test.startTest();
            //AAZ_SecurityServices_cls.getPlainToken( tokenUsername, tokenPassword );
            //AAZ_SecurityServices_cls.encryptPassword( 'testeap', '1ZRqah8/mgDGetKXKOmE1g==', 'AES128' );
            //AAZ_SecurityServices_cls.deleteTibcoUser(String.valueOf(thisUser));
            //AAZ_SecurityServices_cls.createTibcoUser(thisUser.Id);
            //AAZ_SecurityServices_cls.decryptPassword( 'testeap', String.valueOf(Crypto.generateAesKey(128)), 'AES128' );
            //AAZ_SecurityServices_cls.encryptPassword( '', String.valueOf(Crypto.generateAesKey(128)), 'AES128' );
        Test.stopTest();
    }
    
}