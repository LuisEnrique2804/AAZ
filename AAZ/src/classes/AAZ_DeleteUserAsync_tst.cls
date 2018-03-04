@isTest
public class AAZ_DeleteUserAsync_tst {
	
    @isTest static void deleteUserTibco() {
        
           String  profileName = Label.AAZ_AdministratorProfile; // Colocar en Etiqueta Personalizada 
          String   username = Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '@ari.com';
       String username1 = Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '@ari1.com';
        String   password = Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000);


        Profile p = [ SELECT Id FROM Profile WHERE Name=:profileName ];
        

      
     Map<id,user> MapaUser = new map<id,user>();
          User usr = new User();
            usr.Alias             = username.substringAfterLast('@');
            usr.Email             = username;
            usr.EmailEncodingKey  = 'UTF-8';
            usr.LastName          = username;
            usr.LanguageLocaleKey = 'es_MX';
            usr.LocaleSidKey      = 'es_MX';
            usr.ProfileId         = p.Id;
            usr.TimeZoneSidKey    = 'America/Mexico_City';
            usr.UserName          = username;
             usr.IsActive=false;
              usr.EmployeeNumber = 'teste1';
        
   
        MapaUser.put(usr.id,usr);
   insert usr;     
        System.debug(usr);
       
     Map<id,user> MapaUser1 = new map<id,user>();
          User usr1 = new User();
            usr1.Alias             = username1.substringAfterLast('@');
            usr1.Email             = username1;
            usr1.EmailEncodingKey  = 'UTF-8';
            usr1.LastName          = username1;
            usr1.LanguageLocaleKey = 'es_MX';
            usr1.LocaleSidKey      = 'es_MX';
            usr1.ProfileId         = p.Id;
            usr1.TimeZoneSidKey    = 'America/Mexico_City';
            usr1.UserName          = username1;
             usr1.IsActive=true;
              usr1.EmployeeNumber = 'teste';
        
  
          MapaUser1.put(usr1.id,usr1);
 insert usr1;

Test.startTest();
        AAZ_DeleteUserAsync_cls.deleteUserTibco(MapaUser,MapaUser1);
     Test.stopTest();
    }
    
     @isTest static void testadois() {
        
           String  profileName = Label.AAZ_AdministratorProfile; // Colocar en Etiqueta Personalizada
          String   username = Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '@ari.com';
       String username1 = Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '@ari1.com';
        String   password = Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000);


        Profile p = [ SELECT Id FROM Profile WHERE Name=:profileName ];

      
     Map<id,user> MapaUser = new map<id,user>();
          User usr = new User();
            usr.Alias             = username.substringAfterLast('@');
            usr.Email             = username;
            usr.EmailEncodingKey  = 'UTF-8';
            usr.LastName          = username;
            usr.LanguageLocaleKey = 'es_MX';
            usr.LocaleSidKey      = 'es_MX';
            usr.ProfileId         = p.Id;
            usr.TimeZoneSidKey    = 'America/Mexico_City';
            usr.UserName          = username;
             usr.IsActive=true;
              usr.EmployeeNumber = '';
        
   
        MapaUser.put(usr.id,usr);
   insert usr;     
        System.debug(usr);
       
     Map<id,user> MapaUser1 = new map<id,user>();
          User usr1 = new User();
            usr1.Alias             = username1.substringAfterLast('@');
            usr1.Email             = username1;
            usr1.EmailEncodingKey  = 'UTF-8';
            usr1.LastName          = username1;
            usr1.LanguageLocaleKey = 'es_MX';
            usr1.LocaleSidKey      = 'es_MX';
            usr1.ProfileId         = p.Id;
            usr1.TimeZoneSidKey    = 'America/Mexico_City';
            usr1.UserName          = username1;
             usr1.IsActive=false;
              usr1.EmployeeNumber = 'teste';
        
  
          MapaUser1.put(usr1.id,usr1);
 insert usr1;

Test.startTest();
        AAZ_DeleteUserAsync_cls.deleteUserTibco(MapaUser,MapaUser1);
     Test.stopTest();
    }
    
    
     @isTest static void testatres() {
        
           String  profileName = Label.AAZ_AdministratorProfile; // Colocar en Etiqueta Personalizada
          String   username = Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '@ari.com';
       String username1 = Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '@ari1.com';
        String   password = Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000);


        Profile p = [ SELECT Id FROM Profile WHERE Name=:profileName ];

      
     Map<id,user> MapaUser = new map<id,user>();
          User usr = new User();
            usr.Alias             = username.substringAfterLast('@');
            usr.Email             = username;
            usr.EmailEncodingKey  = 'UTF-8';
            usr.LastName          = username;
            usr.LanguageLocaleKey = 'es_MX';
            usr.LocaleSidKey      = 'es_MX';
            usr.ProfileId         = p.Id;
            usr.TimeZoneSidKey    = 'America/Mexico_City';
            usr.UserName          = username;
             usr.IsActive=false;
              usr.EmployeeNumber = 'teste';
        
   
        MapaUser.put(usr.id,usr);
   insert usr;     
        System.debug(usr);
       
     Map<id,user> MapaUser1 = new map<id,user>();
          User usr1 = new User();
            usr1.Alias             = username1.substringAfterLast('@');
            usr1.Email             = username1;
            usr1.EmailEncodingKey  = 'UTF-8';
            usr1.LastName          = username1;
            usr1.LanguageLocaleKey = 'es_MX';
            usr1.LocaleSidKey      = 'es_MX';
            usr1.ProfileId         = p.Id;
            usr1.TimeZoneSidKey    = 'America/Mexico_City';
            usr1.UserName          = username1;
             usr1.IsActive=false;
              usr1.EmployeeNumber = '';
        
  
          MapaUser1.put(usr1.id,usr1);
 insert usr1;

Test.startTest();
        AAZ_DeleteUserAsync_cls.deleteUserTibco(MapaUser,MapaUser1);
   Test.stopTest();  
    }
    
    @isTest static void testaquatro() {
        
           String  profileName = Label.AAZ_AdministratorProfile; // Colocar en Etiqueta Personalizada
          String   username = Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '@ari.com';
       String username1 = Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '@ari1.com';
        String   password = Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000);


        Profile p = [ SELECT Id FROM Profile WHERE Name=:profileName ];

      
     Map<id,user> MapaUser = new map<id,user>();
          User usr = new User();
            usr.Alias             = username.substringAfterLast('@');
            usr.Email             = username;
            usr.EmailEncodingKey  = 'UTF-8';
            usr.LastName          = username;
            usr.LanguageLocaleKey = 'es_MX';
            usr.LocaleSidKey      = 'es_MX';
            usr.ProfileId         = p.Id;
            usr.TimeZoneSidKey    = 'America/Mexico_City';
            usr.UserName          = username;
             usr.IsActive=false;
              usr.EmployeeNumber = '';
        
   
        MapaUser.put(usr.id,usr);
   insert usr;     
        System.debug(usr);
       
     Map<id,user> MapaUser1 = new map<id,user>();
          User usr1 = new User();
            usr1.Alias             = username1.substringAfterLast('@');
            usr1.Email             = username1;
            usr1.EmailEncodingKey  = 'UTF-8';
            usr1.LastName          = username1;
            usr1.LanguageLocaleKey = 'es_MX';
            usr1.LocaleSidKey      = 'es_MX';
            usr1.ProfileId         = p.Id;
            usr1.TimeZoneSidKey    = 'America/Mexico_City';
            usr1.UserName          = username1;
             usr1.IsActive=false;
              usr1.EmployeeNumber = 'teste';
        
  
          MapaUser1.put(usr1.id,usr1);
 insert usr1;

Test.startTest();
        AAZ_DeleteUserAsync_cls.deleteUserTibco(MapaUser,MapaUser1);
Test.stopTest();    
    }
    @isTest static void testacinco() {
        
           String  profileName = Label.AAZ_AdministratorProfile; // Colocar en Etiqueta Personalizada
          String   username = Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '@ari.com';
       String username1 = Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '@ari1.com';
        String   password = Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000);


        Profile p = [ SELECT Id FROM Profile WHERE Name=:profileName ];

      
     Map<id,user> MapaUser = new map<id,user>();
          User usr = new User();
            usr.Alias             = username.substringAfterLast('@');
            usr.Email             = username;
            usr.EmailEncodingKey  = 'UTF-8';
            usr.LastName          = username;
            usr.LanguageLocaleKey = 'es_MX';
            usr.LocaleSidKey      = 'es_MX';
            usr.ProfileId         = p.Id;
            usr.TimeZoneSidKey    = 'America/Mexico_City';
            usr.UserName          = username;
             usr.IsActive=false;
              usr.EmployeeNumber = '';
        
   
        MapaUser.put(usr.id,usr);
   insert usr;     
        System.debug(usr);
       
     Map<id,user> MapaUser1 = new map<id,user>();
          User usr1 = new User();
            usr1.Alias             = username1.substringAfterLast('@');
            usr1.Email             = username1;
            usr1.EmailEncodingKey  = 'UTF-8';
            usr1.LastName          = username1;
            usr1.LanguageLocaleKey = 'es_MX';
            usr1.LocaleSidKey      = 'es_MX';
            usr1.ProfileId         = p.Id;
            usr1.TimeZoneSidKey    = 'America/Mexico_City';
            usr1.UserName          = username1;
             usr1.IsActive=true;
              usr1.EmployeeNumber = 'teste1';
        
  
          MapaUser1.put(usr1.id,usr1);
 insert usr1;

Test.startTest();
        AAZ_DeleteUserAsync_cls.deleteUserTibco(MapaUser,MapaUser1);
     Test.stopTest();
    }
    
    
    @isTest static void testaseis() {
        
           String  profileName = Label.AAZ_AdministratorProfile; // Colocar en Etiqueta Personalizada
          String   username = Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '@ari.com';
       String username1 = Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '@ari1.com';
        String   password = Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000);


        Profile p = [ SELECT Id FROM Profile WHERE Name=:profileName ];

      
     Map<id,user> MapaUser = new map<id,user>();
          User usr = new User();
            usr.Alias             = username.substringAfterLast('@');
            usr.Email             = username;
            usr.EmailEncodingKey  = 'UTF-8';
            usr.LastName          = username;
            usr.LanguageLocaleKey = 'es_MX';
            usr.LocaleSidKey      = 'es_MX';
            usr.ProfileId         = p.Id;
            usr.TimeZoneSidKey    = 'America/Mexico_City';
            usr.UserName          = username;
             usr.IsActive=true;
              usr.EmployeeNumber = '';
        
   
        MapaUser.put(usr.id,usr);
   insert usr;     
        System.debug(usr);
       
     Map<id,user> MapaUser1 = new map<id,user>();
          User usr1 = new User();
            usr1.Alias             = username1.substringAfterLast('@');
            usr1.Email             = username1;
            usr1.EmailEncodingKey  = 'UTF-8';
            usr1.LastName          = username1;
            usr1.LanguageLocaleKey = 'es_MX';
            usr1.LocaleSidKey      = 'es_MX';
            usr1.ProfileId         = p.Id;
            usr1.TimeZoneSidKey    = 'America/Mexico_City';
            usr1.UserName          = username1;
             usr1.IsActive=false;
              usr1.EmployeeNumber ='';
        
  
          MapaUser1.put(usr1.id,usr1);
 insert usr1;

Test.startTest();
        AAZ_DeleteUserAsync_cls.deleteUserTibco(MapaUser,MapaUser1);
     Test.stopTest();
    }
    
    @isTest static void testasiete() {
        
           String  profileName = Label.AAZ_AdministratorProfile; // Colocar en Etiqueta Personalizada
          String   username = Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '@ari.com';
       String username1 = Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '@ari1.com';
        String   password = Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000);


        Profile p = [ SELECT Id FROM Profile WHERE Name=:profileName ];

      
     Map<id,user> MapaUser = new map<id,user>();
          User usr = new User();
            usr.Alias             = username.substringAfterLast('@');
            usr.Email             = username;
            usr.EmailEncodingKey  = 'UTF-8';
            usr.LastName          = username;
            usr.LanguageLocaleKey = 'es_MX';
            usr.LocaleSidKey      = 'es_MX';
            usr.ProfileId         = p.Id;
            usr.TimeZoneSidKey    = 'America/Mexico_City';
            usr.UserName          = username;
             usr.IsActive=true;
              usr.EmployeeNumber = '';
        
   
        MapaUser.put(usr.id,usr);
   insert usr;     
        System.debug(usr);
       
     Map<id,user> MapaUser1 = new map<id,user>();
          User usr1 = new User();
            usr1.Alias             = username1.substringAfterLast('@');
            usr1.Email             = username1;
            usr1.EmailEncodingKey  = 'UTF-8';
            usr1.LastName          = username1;
            usr1.LanguageLocaleKey = 'es_MX';
            usr1.LocaleSidKey      = 'es_MX';
            usr1.ProfileId         = p.Id;
            usr1.TimeZoneSidKey    = 'America/Mexico_City';
            usr1.UserName          = username1;
             usr1.IsActive=true;
              usr1.EmployeeNumber ='';
        
  
          MapaUser1.put(usr1.id,usr1);
 insert usr1;

Test.startTest();
        AAZ_DeleteUserAsync_cls.deleteUserTibco(MapaUser,MapaUser1);
     Test.stopTest();
    }
    
    @isTest static void testaocho() {
        
           String  profileName = Label.AAZ_AdministratorProfile; // Colocar en Etiqueta Personalizada
          String   username = Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '@ari.com';
       String username1 = Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '@ari1.com';
        String   password = Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000);


        Profile p = [ SELECT Id FROM Profile WHERE Name=:profileName ];

      
     Map<id,user> MapaUser = new map<id,user>();
          User usr = new User();
            usr.Alias             = username.substringAfterLast('@');
            usr.Email             = username;
            usr.EmailEncodingKey  = 'UTF-8';
            usr.LastName          = username;
            usr.LanguageLocaleKey = 'es_MX';
            usr.LocaleSidKey      = 'es_MX';
            usr.ProfileId         = p.Id;
            usr.TimeZoneSidKey    = 'America/Mexico_City';
            usr.UserName          = username;
             usr.IsActive=true;
              usr.EmployeeNumber = '';
        
   
        MapaUser.put(usr.id,usr);
   insert usr;     
        System.debug(usr);
       
     Map<id,user> MapaUser1 = new map<id,user>();
          User usr1 = new User();
            usr1.Alias             = username1.substringAfterLast('@');
            usr1.Email             = username1;
            usr1.EmailEncodingKey  = 'UTF-8';
            usr1.LastName          = username1;
            usr1.LanguageLocaleKey = 'es_MX';
            usr1.LocaleSidKey      = 'es_MX';
            usr1.ProfileId         = p.Id;
            usr1.TimeZoneSidKey    = 'America/Mexico_City';
            usr1.UserName          = username1;
             usr1.IsActive=true;
              usr1.EmployeeNumber ='123';
        
  
          MapaUser1.put(usr1.id,usr1);
 insert usr1;

Test.startTest();
        AAZ_DeleteUserAsync_cls.deleteUserTibco(MapaUser,MapaUser1);
     Test.stopTest();
    }
    @isTest static void testanueve() {
        
           String  profileName = Label.AAZ_AdministratorProfile; // Colocar en Etiqueta Personalizada
          String   username = Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '@ari.com';
       String username1 = Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '@ari1.com';
        String   password = Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000);


        Profile p = [ SELECT Id FROM Profile WHERE Name=:profileName ];

      
     Map<id,user> MapaUser = new map<id,user>();
          User usr = new User();
            usr.Alias             = username.substringAfterLast('@');
            usr.Email             = username;
            usr.EmailEncodingKey  = 'UTF-8';
            usr.LastName          = username;
            usr.LanguageLocaleKey = 'es_MX';
            usr.LocaleSidKey      = 'es_MX';
            usr.ProfileId         = p.Id;
            usr.TimeZoneSidKey    = 'America/Mexico_City';
            usr.UserName          = username;
             usr.IsActive=false;
              usr.EmployeeNumber = '';
        
   
        MapaUser.put(usr.id,usr);
   insert usr;     
        System.debug(usr);
       
     Map<id,user> MapaUser1 = new map<id,user>();
          User usr1 = new User();
            usr1.Alias             = username1.substringAfterLast('@');
            usr1.Email             = username1;
            usr1.EmailEncodingKey  = 'UTF-8';
            usr1.LastName          = username1;
            usr1.LanguageLocaleKey = 'es_MX';
            usr1.LocaleSidKey      = 'es_MX';
            usr1.ProfileId         = p.Id;
            usr1.TimeZoneSidKey    = 'America/Mexico_City';
            usr1.UserName          = username1;
             usr1.IsActive=true;
              usr1.EmployeeNumber =' ';
        
  
          MapaUser1.put(usr1.id,usr1);
 insert usr1;

Test.startTest();
        AAZ_DeleteUserAsync_cls.deleteUserTibco(MapaUser,MapaUser1);
     Test.stopTest();
    }
    @isTest static void testadiez() {
        
           String  profileName = Label.AAZ_AdministratorProfile; // Colocar en Etiqueta Personalizada
          String   username = Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '@ari.com';
       String username1 = Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '@ari1.com';
        String   password = Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000);


        Profile p = [ SELECT Id FROM Profile WHERE Name=:profileName ];

      
     Map<id,user> MapaUser = new map<id,user>();
          User usr = new User();
            usr.Alias             = username.substringAfterLast('@');
            usr.Email             = username;
            usr.EmailEncodingKey  = 'UTF-8';
            usr.LastName          = username;
            usr.LanguageLocaleKey = 'es_MX';
            usr.LocaleSidKey      = 'es_MX';
            usr.ProfileId         = p.Id;
            usr.TimeZoneSidKey    = 'America/Mexico_City';
            usr.UserName          = username;
             usr.IsActive=false;
              usr.EmployeeNumber = '';
        
   
        MapaUser.put(usr.id,usr);
   insert usr;     
        System.debug(usr);
       
     Map<id,user> MapaUser1 = new map<id,user>();
          User usr1 = new User();
            usr1.Alias             = username1.substringAfterLast('@');
            usr1.Email             = username1;
            usr1.EmailEncodingKey  = 'UTF-8';
            usr1.LastName          = username1;
            usr1.LanguageLocaleKey = 'es_MX';
            usr1.LocaleSidKey      = 'es_MX';
            usr1.ProfileId         = p.Id;
            usr1.TimeZoneSidKey    = 'America/Mexico_City';
            usr1.UserName          = username1;
             usr1.IsActive=false;
              usr1.EmployeeNumber ='';
        
  
          MapaUser1.put(usr1.id,usr1);
 insert usr1;

Test.startTest();
        AAZ_DeleteUserAsync_cls.deleteUserTibco(MapaUser,MapaUser1);
     Test.stopTest();
    }
    @isTest static void testatrece() {
        
           String  profileName = Label.AAZ_AdministratorProfile; // Colocar en Etiqueta Personalizada
          String   username = Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '@ari.com';
       String username1 = Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '@ari1.com';
        String   password = Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000);


        Profile p = [ SELECT Id FROM Profile WHERE Name=:profileName ];

      
     Map<id,user> MapaUser = new map<id,user>();
          User usr = new User();
            usr.Alias             = username.substringAfterLast('@');
            usr.Email             = username;
            usr.EmailEncodingKey  = 'UTF-8';
            usr.LastName          = username;
            usr.LanguageLocaleKey = 'es_MX';
            usr.LocaleSidKey      = 'es_MX';
            usr.ProfileId         = p.Id;
            usr.TimeZoneSidKey    = 'America/Mexico_City';
            usr.UserName          = username;
             usr.IsActive=false;
              usr.EmployeeNumber = '1234';
        
   
        MapaUser.put(usr.id,usr);
   insert usr;     
        System.debug(usr);
       
     Map<id,user> MapaUser1 = new map<id,user>();
          User usr1 = new User();
            usr1.Alias             = username1.substringAfterLast('@');
            usr1.Email             = username1;
            usr1.EmailEncodingKey  = 'UTF-8';
            usr1.LastName          = username1;
            usr1.LanguageLocaleKey = 'es_MX';
            usr1.LocaleSidKey      = 'es_MX';
            usr1.ProfileId         = p.Id;
            usr1.TimeZoneSidKey    = 'America/Mexico_City';
            usr1.UserName          = username1;
             usr1.IsActive=true;
              usr1.EmployeeNumber ='';
        
  
          MapaUser1.put(usr1.id,usr1);
 insert usr1;

Test.startTest();
        AAZ_DeleteUserAsync_cls.deleteUserTibco(MapaUser,MapaUser1);
     Test.stopTest();
    }
    @isTest static void testaonce() {
        
           String  profileName = Label.AAZ_AdministratorProfile; // Colocar en Etiqueta Personalizada
          String   username = Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '@ari.com';
       String username1 = Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '@ari1.com';
        String   password = Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000);


        Profile p = [ SELECT Id FROM Profile WHERE Name=:profileName ];

      
     Map<id,user> MapaUser = new map<id,user>();
          User usr = new User();
            usr.Alias             = username.substringAfterLast('@');
            usr.Email             = username;
            usr.EmailEncodingKey  = 'UTF-8';
            usr.LastName          = username;
            usr.LanguageLocaleKey = 'es_MX';
            usr.LocaleSidKey      = 'es_MX';
            usr.ProfileId         = p.Id;
            usr.TimeZoneSidKey    = 'America/Mexico_City';
            usr.UserName          = username;
             usr.IsActive=false;
              usr.EmployeeNumber = '123';
        
   
        MapaUser.put(usr.id,usr);
   insert usr;     
        System.debug(usr);
       
     Map<id,user> MapaUser1 = new map<id,user>();
          User usr1 = new User();
            usr1.Alias             = username1.substringAfterLast('@');
            usr1.Email             = username1;
            usr1.EmailEncodingKey  = 'UTF-8';
            usr1.LastName          = username1;
            usr1.LanguageLocaleKey = 'es_MX';
            usr1.LocaleSidKey      = 'es_MX';
            usr1.ProfileId         = p.Id;
            usr1.TimeZoneSidKey    = 'America/Mexico_City';
            usr1.UserName          = username1;
             usr1.IsActive=false;
              usr1.EmployeeNumber ='123';
        
  
          MapaUser1.put(usr1.id,usr1);
 insert usr1;

Test.startTest();
        AAZ_DeleteUserAsync_cls.deleteUserTibco(MapaUser,MapaUser1);
     Test.stopTest();
    }
    @isTest static void testadoce() {
        
           String  profileName = Label.AAZ_AdministratorProfile; // Colocar en Etiqueta Personalizada
          String   username = Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '@ari.com';
       String username1 = Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '@ari1.com';
        String   password = Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000);


        Profile p = [ SELECT Id FROM Profile WHERE Name=:profileName ];

      
     Map<id,user> MapaUser = new map<id,user>();
          User usr = new User();
            usr.Alias             = username.substringAfterLast('@');
            usr.Email             = username;
            usr.EmailEncodingKey  = 'UTF-8';
            usr.LastName          = username;
            usr.LanguageLocaleKey = 'es_MX';
            usr.LocaleSidKey      = 'es_MX';
            usr.ProfileId         = p.Id;
            usr.TimeZoneSidKey    = 'America/Mexico_City';
            usr.UserName          = username;
             usr.IsActive=false;
              usr.EmployeeNumber = '123';
        
   
        MapaUser.put(usr.id,usr);
   insert usr;     
        System.debug(usr);
       
     Map<id,user> MapaUser1 = new map<id,user>();
          User usr1 = new User();
            usr1.Alias             = username1.substringAfterLast('@');
            usr1.Email             = username1;
            usr1.EmailEncodingKey  = 'UTF-8';
            usr1.LastName          = username1;
            usr1.LanguageLocaleKey = 'es_MX';
            usr1.LocaleSidKey      = 'es_MX';
            usr1.ProfileId         = p.Id;
            usr1.TimeZoneSidKey    = 'America/Mexico_City';
            usr1.UserName          = username1;
             usr1.IsActive=false;
              usr1.EmployeeNumber ='';
        
  
          MapaUser1.put(usr1.id,usr1);
 insert usr1;

Test.startTest();
        AAZ_DeleteUserAsync_cls.deleteUserTibco(MapaUser,MapaUser1);
     Test.stopTest();
    }
    @isTest static void testacatorce() {
        
           String  profileName = Label.AAZ_AdministratorProfile; // Colocar en Etiqueta Personalizada
          String   username = Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '@ari.com';
       String username1 = Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '@ari1.com';
        String   password = Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000);


        Profile p = [ SELECT Id FROM Profile WHERE Name=:profileName ];

      
     Map<id,user> MapaUser = new map<id,user>();
          User usr = new User();
            usr.Alias             = username.substringAfterLast('@');
            usr.Email             = username;
            usr.EmailEncodingKey  = 'UTF-8';
            usr.LastName          = username;
            usr.LanguageLocaleKey = 'es_MX';
            usr.LocaleSidKey      = 'es_MX';
            usr.ProfileId         = p.Id;
            usr.TimeZoneSidKey    = 'America/Mexico_City';
            usr.UserName          = username;
             usr.IsActive=true;
              usr.EmployeeNumber = '1234';
        
   
        MapaUser.put(usr.id,usr);
   insert usr;     
        System.debug(usr);
       
     Map<id,user> MapaUser1 = new map<id,user>();
          User usr1 = new User();
            usr1.Alias             = username1.substringAfterLast('@');
            usr1.Email             = username1;
            usr1.EmailEncodingKey  = 'UTF-8';
            usr1.LastName          = username1;
            usr1.LanguageLocaleKey = 'es_MX';
            usr1.LocaleSidKey      = 'es_MX';
            usr1.ProfileId         = p.Id;
            usr1.TimeZoneSidKey    = 'America/Mexico_City';
            usr1.UserName          = username1;
             usr1.IsActive=true;
              usr1.EmployeeNumber ='123';
        
  
          MapaUser1.put(usr1.id,usr1);
 insert usr1;

Test.startTest();
        AAZ_DeleteUserAsync_cls.deleteUserTibco(MapaUser,MapaUser1);
     Test.stopTest();
    }
    @isTest static void testaquince() {
        
           String  profileName = Label.AAZ_AdministratorProfile; // Colocar en Etiqueta Personalizada
          String   username = Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '@ari.com';
       String username1 = Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '@ari1.com';
        String   password = Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000);


        Profile p = [ SELECT Id FROM Profile WHERE Name=:profileName ];

      
     Map<id,user> MapaUser = new map<id,user>();
          User usr = new User();
            usr.Alias             = username.substringAfterLast('@');
            usr.Email             = username;
            usr.EmailEncodingKey  = 'UTF-8';
            usr.LastName          = username;
            usr.LanguageLocaleKey = 'es_MX';
            usr.LocaleSidKey      = 'es_MX';
            usr.ProfileId         = p.Id;
            usr.TimeZoneSidKey    = 'America/Mexico_City';
            usr.UserName          = username;
             usr.IsActive=true;
              usr.EmployeeNumber = '123';
        
   
        MapaUser.put(usr.id,usr);
   insert usr;     
        System.debug(usr);
       
     Map<id,user> MapaUser1 = new map<id,user>();
          User usr1 = new User();
            usr1.Alias             = username1.substringAfterLast('@');
            usr1.Email             = username1;
            usr1.EmailEncodingKey  = 'UTF-8';
            usr1.LastName          = username1;
            usr1.LanguageLocaleKey = 'es_MX';
            usr1.LocaleSidKey      = 'es_MX';
            usr1.ProfileId         = p.Id;
            usr1.TimeZoneSidKey    = 'America/Mexico_City';
            usr1.UserName          = username1;
             usr1.IsActive=true;
              usr1.EmployeeNumber ='';
        
  
          MapaUser1.put(usr1.id,usr1);
 insert usr1;

Test.startTest();
        AAZ_DeleteUserAsync_cls.deleteUserTibco(MapaUser,MapaUser1);
     Test.stopTest();
    }
    @isTest static void testadieciseis() {
        
           String  profileName = Label.AAZ_AdministratorProfile; // Colocar en Etiqueta Personalizada
          String   username = Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '@ari.com';
       String username1 = Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '@ari1.com';
        String   password = Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000);


        Profile p = [ SELECT Id FROM Profile WHERE Name=:profileName ];

      
     Map<id,user> MapaUser = new map<id,user>();
          User usr = new User();
            usr.Alias             = username.substringAfterLast('@');
            usr.Email             = username;
            usr.EmailEncodingKey  = 'UTF-8';
            usr.LastName          = username;
            usr.LanguageLocaleKey = 'es_MX';
            usr.LocaleSidKey      = 'es_MX';
            usr.ProfileId         = p.Id;
            usr.TimeZoneSidKey    = 'America/Mexico_City';
            usr.UserName          = username;
             usr.IsActive=true;
              usr.EmployeeNumber = '123';
        
   
        MapaUser.put(usr.id,usr);
   insert usr;     
        System.debug(usr);
       
     Map<id,user> MapaUser1 = new map<id,user>();
          User usr1 = new User();
            usr1.Alias             = username1.substringAfterLast('@');
            usr1.Email             = username1;
            usr1.EmailEncodingKey  = 'UTF-8';
            usr1.LastName          = username1;
            usr1.LanguageLocaleKey = 'es_MX';
            usr1.LocaleSidKey      = 'es_MX';
            usr1.ProfileId         = p.Id;
            usr1.TimeZoneSidKey    = 'America/Mexico_City';
            usr1.UserName          = username1;
             usr1.IsActive=false;
              usr1.EmployeeNumber ='123';
        
  
          MapaUser1.put(usr1.id,usr1);
 insert usr1;

Test.startTest();
        AAZ_DeleteUserAsync_cls.deleteUserTibco(MapaUser,MapaUser1);
     Test.stopTest();
    }
    @isTest static void testaultimo() {
        
           String  profileName = Label.AAZ_AdministratorProfile; // Colocar en Etiqueta Personalizada
          String   username = Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '@ari.com';
       String username1 = Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '@ari1.com';
        String   password = Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000);


        Profile p = [ SELECT Id FROM Profile WHERE Name=:profileName ];

      
     Map<id,user> MapaUser = new map<id,user>();
          User usr = new User();
            usr.Alias             = username.substringAfterLast('@');
            usr.Email             = username;
            usr.EmailEncodingKey  = 'UTF-8';
            usr.LastName          = username;
            usr.LanguageLocaleKey = 'es_MX';
            usr.LocaleSidKey      = 'es_MX';
            usr.ProfileId         = p.Id;
            usr.TimeZoneSidKey    = 'America/Mexico_City';
            usr.UserName          = username;
             usr.IsActive=true;
              usr.EmployeeNumber = '123';
        
   
        MapaUser.put(usr.id,usr);
   insert usr;     
        System.debug(usr);
       
     Map<id,user> MapaUser1 = new map<id,user>();
          User usr1 = new User();
            usr1.Alias             = username1.substringAfterLast('@');
            usr1.Email             = username1;
            usr1.EmailEncodingKey  = 'UTF-8';
            usr1.LastName          = username1;
            usr1.LanguageLocaleKey = 'es_MX';
            usr1.LocaleSidKey      = 'es_MX';
            usr1.ProfileId         = p.Id;
            usr1.TimeZoneSidKey    = 'America/Mexico_City';
            usr1.UserName          = username1;
             usr1.IsActive=false;
              usr1.EmployeeNumber ='';
        
  
          MapaUser1.put(usr1.id,usr1);
 insert usr1;

Test.startTest();
        AAZ_DeleteUserAsync_cls.deleteUserTibco(MapaUser,MapaUser1);
     Test.stopTest();
    }
}