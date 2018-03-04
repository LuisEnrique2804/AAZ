/****************************************************************************************
    Desarrollado por:  Avanxo México
    Autor:             Luis Enrique Garcia Sanabria
    Proyecto:          Mesa de Control Afore
    Descripción:       Clase de APEX que realiza la función encriptacion y desencriptacion
    de los mensajes, asi como la generaacion del token.

    Cambios (Versiones)
    -------------------------------------
      No.      Fecha                  Autor                      Descripción
    ------  -------------  ------------------------------   ----------------------
     0.1     30-06-2017    Luis Enrique Garcia Sanabria     Creacion
     0.2     30-06-2017    Luis Enrique Garcia Sanabria     Construcción
     1.0     09-08-2017    Luis Enrique Garcia Sanabria     Finalización y documentación
****************************************************************************************/

public class AAZ_SecurityServices_cls {

    @testVisible private static String STR_TOKEN_CONFIG_CODE = 'Afore_Authorization';
    @testVisible private static String STR_USER_CONFIG_CODE  = 'Afore_AddUserRs';
    @testVisible private static String STR_USER_CONFIG_DELETE  = 'Afore_OutUserRs';
    public static AAZ_ServiceTokenResponse_wpr objTokenWrapper = null;
    public static String strDecryptedToken = null;
    
    // Cargar los mainsettings para las clases de prueba
   public static AppMainSetting_cs__c mainSettings = Test.isRunningTest()?
        AAZ_TestUtils_tst.getMainSettings() : AppMainSetting_cs__c.getOrgDefaults();

    /**
     * Obtener token para consumir servicio web
     * @param  tokenUsername Usuario para generar token
     * @param  tokenPassword Contraseña para generar token
     * @return strPlainToken Token en texto plano
    **/

    public static String getPlainToken(String tokenUsername, String tokenPassword)
    {
        String strPlainToken = null; 
        AAZ_SecurityServices_cls.objTokenWrapper = AAZ_SecurityServices_cls.getServiceToken(tokenUsername, tokenPassword);
        if (AAZ_SecurityServices_cls.objTokenWrapper != null && AAZ_SecurityServices_cls.objTokenWrapper.signToken != null) {
            strPlainToken = AAZ_SecurityServices_cls.objTokenWrapper.signToken.signedToken;
        }
        return strPlainToken;
    }

    /**
     * Metodo que realiza el REQUEST al servicio de TOKEN por parte de TIBCO.
     * @param  tokenUsername Usuario para generar token
     * @param  tokenPassword Contraseña para generar token
     * @param  accessType    Tipo de acceso (application/system)
     * @return               Objeto de respuesta del servicio con información del token
    **/

    public static AAZ_ServiceTokenResponse_wpr getServiceToken(String tokenUsername, String tokenPassword, String accessType) {
        System.debug(loggingLevel.Error, '*** tokenPassword: ' + tokenPassword);
        AAZ_ServiceTokenResponse_wpr tokenWrapper = new AAZ_ServiceTokenResponse_wpr();
        //AppMainSetting_cs__c mainSettings = AppMainSetting_cs__c.getOrgDefaults();
        //String systemId  = mainSettings.WebServiceSystemId__c;
        //String aesKey    = mainSettings.PasswordEncryptionKey__c;
        //String algorithm = mainSettings.PasswordEncryptionAlgorithm__c;
        //String decryptedPassword = AAZ_SecurityServices_cls.decryptPassword(tokenPassword, aesKey, algorithm);
        //String encryptedPassword = AAZ_SecurityServices_cls.encryptPassword(decryptedPassword, aesKey, algorithm);
        EndpointSetting__mdt tknEndpointSetting = new EndpointSetting__mdt();
        try{tknEndpointSetting = AAZ_Utils_cls.getEndpointSetting(STR_TOKEN_CONFIG_CODE);}catch(Exception ex){return tokenWrapper;}
        Http tokenClient = new Http();
        HttpRequest tokenRequest = new HttpRequest();
        tokenRequest.setEndpoint(AAZ_GenericCallout_cls.getEndpoint(tknEndpointSetting));
        tokenRequest.setMethod(tknEndpointSetting.ServiceMethod__c);
        tokenRequest.setHeader('Content-Type', tknEndpointSetting.RequestBodyType__c);
        tokenRequest.setBody(
            'username=' + tokenUsername +
            '&password=' + EncodingUtil.urlEncode(tokenPassword, 'UTF-8')
        ); 
        //if(Test.isRunningTest()){
        //    AAZ_GenericCallOutMock_mck mockInstance = new AAZ_GenericCallOutMock_mck(
        //        200,
        //        'SUCCESS',
        //        '{"signedToken":"Zjk3Y2NlYWRjOTNkMjFmNDYwZTFlZGZjNWI4YTQ5NWI4MTIwZmMzM2ZkOTRmZTg2NTgxZjcxZTAyNTA5ZDIwZg==","expiration":"2017-05-17 10:26:14"}',
        //        new Map<String,String>()
        //    );
        //    Test.setMock(HttpCalloutMock.class, mockInstance);
        //}
        HttpResponse tokenResponse = new HttpResponse();
        tokenResponse = tokenClient.send(tokenRequest);
        System.debug('token response body : '+tokenResponse.getBody());
        try {tokenWrapper = AAZ_ServiceTokenResponse_wpr.parse(tokenResponse.getBody());}catch (Exception e){}
        return tokenWrapper;
    }

    /**
     * Metodo que realiza el REQUEST al servicio de TOKEN por parte de TIBCO con accessType por defecto "application".
     * @param  tokenUsername Usuario para generar token
     * @param  tokenPassword Contraseña para generar token
     * @return Objeto de respuesta del servicio con información del token
    **/

    public static AAZ_ServiceTokenResponse_wpr getServiceToken(String tokenUsername, String tokenPassword) {
        return AAZ_SecurityServices_cls.getServiceToken(tokenUsername, tokenPassword, 'application');
    }

    /**
     * Encriptar contraseña de usuario
     * @param  password  Contraseña a encriptar
     * @param  aesKey    Llave AES
     * @param  algorithm Algoritmo de cifrado
     * @return           Contraseña encriptada
    **/

    public static String encryptPassword(String password, String aesKey, String algorithm) {
        String strEncryptedPassword = null; System.debug('this is ** '+aesKey);
        Blob cryptoKey = EncodingUtil.base64Decode(aesKey);
        Blob data = Blob.valueOf(password);
        Blob encryptedData = Crypto.encryptWithManagedIV(algorithm, cryptoKey, data);
        strEncryptedPassword = EncodingUtil.base64Encode(encryptedData);
        return strEncryptedPassword;
    }

    /**
     * Desencriptar contraseña de usuario
     * @param  password  Contraseña a desencriptar
     * @param  aesKey    Llave AES
     * @param  algorithm Algoritmo de cifrado
     * @return           Contraseña desencriptada
    **/

    public static String decryptPassword(String password, String aesKey, String algorithm) {
        String strDecryptedPassword = null;
        Blob cryptoKey = EncodingUtil.base64Decode(aesKey);
        Blob data = EncodingUtil.base64Decode(password);
        Blob decryptedData = Crypto.decryptWithManagedIV(algorithm, cryptoKey, data);
        strDecryptedPassword = decryptedData.toString();
        return strDecryptedPassword;
    }

    /**
     * Registrar un nuevo usuario en TIBCO al ser creado en Salesforce
     * @param  usr Usuario a registrar
     * @return     Id del usuario registrado
    **/

    public static void createTibcoUser(Id userId) {
        User usr = AAZ_Utils_cls.getUserCustomInfo(userId);
        if (String.isBlank(usr.EmployeeNumber)) {return;}
        AAZ_UserResponseWrapper_wpr userWrapper = new AAZ_UserResponseWrapper_wpr();
        //AppMainSetting_cs__c mainSettings = AppMainSetting_cs__c.getOrgDefaults();
        EndpointSetting__mdt endpointSetting = null;
        endpointSetting = AAZ_Utils_cls.getEndpointSetting(STR_USER_CONFIG_CODE);
        System.debug(loggingLevel.Error, '*** endpointSetting: ' + endpointSetting);
        if(endpointSetting != null){
            Http client = new Http();
            HttpRequest request = new HttpRequest();
            request.setMethod(endpointSetting.ServiceMethod__c);
            request.setHeader('Content-Type', endpointSetting.RequestBodyType__c);
            request.setEndpoint((endpointSetting.Stage__c == 'Producción')?endpointSetting.ProductionEndpoint__c:(endpointSetting.Stage__c == 'QA')?endpointSetting.QAEndpoint__c:endpointSetting.DevelopmentEndpoint__c);
            String tokenUsername = mainSettings.UserServiceToken__c;
            String tokenPassword = mainSettings.PasswordServiceToken__c;
            String strMsgBody = '{"userName":"'+usr.EmployeeNumber+'","password":"'+tokenPassword+'"}';
            request.setBody(strMsgBody);
            System.debug(loggingLevel.Error, '*** request: ' + request);
            System.debug(loggingLevel.Error, '*** Content-Type Header : '+request.getHeader('Content-Type'));
            System.debug(loggingLevel.Error, '*** Request Body : '+request.getBody());
            HttpResponse response = client.send(request);
            System.debug('response body : '+response.getBody());
            System.debug(loggingLevel.Error, '*** response body : '+response.getBody());
            Integer resStatusCode = response.getStatusCode();
            if (resStatusCode != 200 && resStatusCode != 201) {return;}
            try{ System.debug(loggingLevel.Error, '*** Entro');
                userWrapper = AAZ_UserResponseWrapper_wpr.parse(response.getBody());
                System.debug(loggingLevel.Error, '*** userWrapper: ' + userWrapper);
                usr.ServiceTokenPassword__c = userWrapper.signToken.signedToken;
                Database.update(usr,true);
            }catch(DmlException dE){}catch(SerializationException sE){}catch(Exception gE){}
        }
    }

    /**
     * Eliminar un usuario de TIBCO
     * @param  usr Usuario a eliminar
     * @retun nada (void)
    **/

    //public static Void deleteTibcoUser(Id userId) {
    public static void deleteTibcoUser(String strUserEmployeeNumber) {
        //User usr = AAZ_Utils_cls.getUserCustomInfo(userId);
        //if (String.isBlank(usr.EmployeeNumber)){return;}
        if (String.isBlank(strUserEmployeeNumber)){return;}
        //AppMainSetting_cs__c mainSettings = AppMainSetting_cs__c.getOrgDefaults();
        EndpointSetting__mdt endpointSetting = null;
        try {endpointSetting = AAZ_Utils_cls.getEndpointSetting(STR_USER_CONFIG_DELETE);}catch(Exception ex){return;}
        if(endpointSetting != null){
            Http client = new Http();
            HttpRequest request = new HttpRequest();
            request.setMethod(endpointSetting.ServiceMethod__c);
            request.setHeader('Content-Type', endpointSetting.RequestBodyType__c);
            request.setEndpoint((endpointSetting.Stage__c == 'Producción')?endpointSetting.ProductionEndpoint__c:(endpointSetting.Stage__c == 'QA')?endpointSetting.QAEndpoint__c:endpointSetting.DevelopmentEndpoint__c);
            String tokenUsername = mainSettings.UserServiceToken__c;
            String tokenPassword = mainSettings.PasswordServiceToken__c;
            String strMsgBody = '{"userName":"'+strUserEmployeeNumber+'","password":"'+tokenPassword+'"}';
            request.setBody(strMsgBody);
            System.debug(loggingLevel.Error, '*** request: ' + request);
            System.debug(loggingLevel.Error, '*** Content-Type Header : '+request.getHeader('Content-Type'));
            System.debug(loggingLevel.Error, '*** Request Body : '+request.getBody());
            HttpResponse response = client.send(request);
            System.debug(loggingLevel.Error, '*** response body : '+response.getBody());
            Integer resStatusCode = response.getStatusCode();
            if (resStatusCode != 200 && resStatusCode != 201) {return;}
            try{
                String strUser = 'SELECT '+ String.join(new List<String>(SObjectType.User.Fields.getMap().keySet()),', ')+' FROM USER WHERE EmployeeNumber = \'' + strUserEmployeeNumber + '\' LIMIT 1';
                User usr = Database.query(strUser);

                usr.ServiceTokenPassword__c = null;
                usr.AlnovaTerminal__c = null;
                TriggerManager.inactivate('AAZ_UserTrigger_tgr');
                update usr;
            }catch(DmlException dmlE){System.debug(loggingLevel.Error, '*** dmlE: ' + dmlE.getMessage());}catch(Exception gE){System.debug(loggingLevel.Error, '*** ge: ' + ge.getMessage() );}
        }
    }

}