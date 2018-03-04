/*******************************************************************************
Desarrollado por: Avanxo México
Autor: Daniel Peñaloza
Proyecto: Banco Azteca - Afore
Descripción: Clase con métodos utilitarios para todos los métodos de prueba

------ ---------- -------------------------- -----------------------------------
No.    Fecha      Autor                      Descripción
------ ---------- -------------------------- -----------------------------------
1.0    10/08/2017 Daniel Peñaloza            Clase creada
*******************************************************************************/

@isTest
public class AAZ_TestUtils_tst {
    // Cadenas JSON de RESPUESTA
    public static final String TEST_AUTH_TOKEN             = 'ZWQzNzUyZTg5MDk4MzE0YTA1OTY4ZGU0YWI4MjljMzFhYmU5MDNkOTA0NzIzYTlhOGNmNGJhNTAwYjE5YzYwNg==';
    public static final String RES_OK_AUTH_TOKEN           = '{"signToken":{"signedToken":"' + TEST_AUTH_TOKEN + '","expiration":"2017-04-26 13:24:19"}}';
    public static final String RES_ERROR_AUTH_TOKEN        = '{"error":"error"}';
    public static final String RES_OK_CREATE_TIBCO_USER    = '{"AddUserRs": {"username": "111111","password": "O5bNiFTFi6aGjJD6DXnea4yQbGob4crxK2fF0ngmMIc=","systemId": "SALESFORCE","alnovaTerminal": "CALL"}}';
    public static final String RES_ERROR_CREATE_TIBCO_USER = '{"Error":"Error"}';
    public static final String RES_OK_DELETE_TIBCO_USER    = '';
    public static final String RES_OK_AGENT_QUERY          = '{"Afore_QueryAgent_Out":{"isSuccessful":true,"employeeNumber":"1","paternalLastName":"paternalLastName","maternalLastName":"maternalLastName","firstName":"firstName","admitionDate":"2011-10-19","schoolGrade":"schoolGrade","birthDate":"2011-10-19","pointAPHistory":7,"maxPointAPHistory":7,"shopNumber":7,"shopName":"shopName","zone":"zone","state":"state","implementName":"implementName","implementPhone":"12365478","implementEmail":"implementEmail","DivisionalName":"DivisionalName","DivisionalPhone":"87456321","errorList":[{"code":"code","description":"description"}]}}';
    public static final String RES_OK_DOCUMENTS_QUERY      = '{"Afore_QueryDocument_Out":{"isSuccessful":true,"DocsDigitalizados":[{"Orden":7,"ruta":"http://www.segurosazteca.com.mx/segurosAzteca/imagenes/estructura/logo.gif","digitalNumber":"001","idDoctoTienda":"0001","page":7}],"errorList":[{"code":"1","description":"Transacción Exitosa"}]}}';
    public static final String RES_OK_QUERY_BENEFICIARY    = '{"Afore_QueryBeneficiary_Out":{"isSuccessful":true,"beneficiary":[{"percentage":"teste1","phoneType":"teste1","phone":"teste1","relationship":"teste1","curp":"teste1","birthState":"teste1","birthDate":"teste1","gender":"M","maternalLastName":"teste1","paternalLastName":"teste1","name":"teste1","isUpdateData":"true"}],"errorList":[{"code":"1","description":"Transacción Exitosa"}]}}';
    /**
     * Generar una instancia de Ajustes Globales de la Aplicación
     * @return Instancia de ajustes globales
     */
    public static AppMainSetting_cs__c getMainSettings() {
        AppMainSetting_cs__c mainSettings = new AppMainSetting_cs__c(
            PasswordEncryptionKey__c       = 'R042TngxdXpsSTYzZEsybFEzazRtUWxLMjg2eE5sTTA=', // GN6Nx1uzlI63dK2lQ3k4mQlK286xNlM0
            TokenEncriptionKey__c          = 'd2hjUFp3VWkwc0VEMEhNblA3TGdKdmpkZzhMMk1WOEg=', // whcPZwUi0sED0HMnP7LgJvjdg8L2MV8H
            PasswordEncryptionAlgorithm__c = 'AES256',
            TokenEncryptionAlgorithm__c    = 'AES256',
            UserServiceToken__c            = 'SALESFORCE',
            PasswordServiceToken__c        = 'testTokenServicePassword',
            WebServiceSystemId__c          = 'SALESFORCE'
        );

        return mainSettings;
    }

    /**
     * Crear un usuario de Salesforce
     * @return             Usuario creado
     */
    public static User createUser() {
        return AAZ_TestUtils_tst.createUser(null);
    }

    /**
     * Crear un usuario de Salesforce
     * @param  profileName Nombre del perfil
     * @return             Usuario creado
     */
    public static User createUser(String profileName) {
        return AAZ_TestUtils_tst.createUser(profileName, null, null);
    }

    /**
     * Crear un usuario de Salesforce
     * @param  profileName Nombre del perfil
     * @param  username    Nombre de usuario
     * @param  password    Contraseña de servicio de token
     * @return             Usuario creado
     */
    public static User createUser(String profileName, String username, String password) {
        AppMainSetting_cs__c mainSettings = AAZ_TestUtils_tst.getMainSettings();

        // Perfil por defecto
        if (String.isBlank(profileName)) {
            profileName = 'System Administrator';
        }

        // Usuario por defecto
        if (String.isBlank(username)) {
            username = Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000) + '@test.com';
        }

        // Contraseña por defecto
        if (String.isBlank(password)) {
            password = Math.round(Math.random() * 10000) + '_' + Math.round(Math.random() * 10000);
        }

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
            UserName          = username,
            ServiceTokenPassword__c = AAZ_SecurityServices_cls.encryptPassword(
                password, mainSettings.PasswordEncryptionKey__c, mainSettings.PasswordEncryptionAlgorithm__c)
        );

        return usr;
    }
}