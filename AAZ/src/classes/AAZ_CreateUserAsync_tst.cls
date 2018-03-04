@isTest
private class AAZ_CreateUserAsync_tst {
	
	@isTest static void test_method_one() {
		
		Profile p = [ SELECT Id FROM Profile WHERE Name = 'Analista Validador' LIMIT 1 ];

		User usr = new User(
            Alias             = 'usrtest',
            Email             = 'email@email.com',
            EmailEncodingKey  = 'UTF-8',
            LastName          = 'userLastName',
            LanguageLocaleKey = 'es_MX',
            LocaleSidKey      = 'es_MX',
            ProfileId         = p.Id,
            TimeZoneSidKey    = 'America/Mexico_City',
            UserName          = 'testazteca@azteca.com'
        );

        insert usr;

        Test.startTest();
			AAZ_CreateUserAsync_cls createUser = new AAZ_CreateUserAsync_cls();
			createUser.usr = usr;
			String jobId = System.enqueueJob(createUser);
        Test.stopTest();

	}
		
}