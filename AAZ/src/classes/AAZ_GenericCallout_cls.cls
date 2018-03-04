/****************************************************************************************
    Desarrollado por:  Avanxo México
    Autor:             Luis Enrique Garcia Sanabria
    Proyecto:          Mesa de Control Afore
    Descripción:       Clase de APEX que realiza la función de generan el llamado a los
    servicios de manera generica

    Cambios (Versiones)
    -------------------------------------
      No.      Fecha                  Autor                      Descripción
    ------  -------------  ------------------------------   ----------------------
     0.1     04-08-2017    Luis Enrique Garcia Sanabria     Creacion
     0.2     04-08-2017    Luis Enrique Garcia Sanabria     Construcción
     1.0     09-08-2017    Luis Enrique Garcia Sanabria     Finalización y documentación
****************************************************************************************/
public class AAZ_GenericCallout_cls {

    // Cargar los mainsettings para las clases de prueba
    public static AppMainSetting_cs__c mainSettings = Test.isRunningTest()?
        AAZ_TestUtils_tst.getMainSettings() : AppMainSetting_cs__c.getOrgDefaults();

    /**
     * Método principal de ejecución de llamado a servicios web.
     * @param  strJsonRequest  Cadena JSON del cuerpo de la petición HTTP
     * @param  strConfigName   Nombre de l objeto de metadatos con la configuración a utilizar
     * @param  mapExtraHeaders Cabeceras HTTP adicionales
     * @param  isLastCallout   Indica si el callout es el último en la transacción
     * @return                 Cadena JSON con el cuerpo de la respuesta del servicio web
    **/

    public static Integer intTestMode;
    public static String strTestConfigName;

    public static String fn_runCallout(String strRequestBody, String strConfigName, Map<String, String> mapExtraHeaders, Boolean isLastCallout)
    {
        String strJsonResponse = null;
        //AppMainSetting_cs__c mainSettings = AppMainSetting_cs__c.getOrgDefaults();
        EndpointSetting__mdt objEndpointSetting = AAZ_Utils_cls.getEndpointSetting(strConfigName);
        Http httpClient = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(AAZ_GenericCallout_cls.getEndpoint(objEndpointSetting));
        request.setMethod(objEndpointSetting.ServiceMethod__c);
        request.setTimeout(objEndpointSetting.Timeout__c.intValue());
        System.debug('This '+objEndpointSetting );
        if (objEndpointSetting.RequiresBodyEncryption__c) {
            strRequestBody = AAZ_SecurityServices_cls.encryptPassword(
                strRequestBody, mainSettings.PasswordEncryptionKey__c, mainSettings.PasswordEncryptionAlgorithm__c);
            request.setHeader('Content-Type', 'text/plain');
            //request.setHeader('Accept'      , 'text/plain');
        } else {
            request.setHeader('Content-Type', objEndpointSetting.RequestBodyType__c);
            request.setHeader('Accept'      , objEndpointSetting.ResponseBodyType__c);
        }
        request.setBody(strRequestBody);
        request.setHeader('Cache-Control', 'no-cache');
        request.setHeader('Content-Length', String.valueOf(strRequestBody.length()));
        request.setHeader('accessType', 'application');
        request.setHeader('system', 'SALESFORCE');
        if (mapExtraHeaders != null && !mapExtraHeaders.isEmpty()) {
            for (String headerName : mapExtraHeaders.keySet()) {
                request.setHeader(headerName, mapExtraHeaders.get(headerName));
            }
        }
        if(objEndpointSetting.RequiresToken__c && !('DEVELOPMENT'.equalsIgnoreCase(objEndpointSetting.Stage__c))) {
            try {
                AAZ_GenericCallout_cls.setServiceToken(request);
            } catch (Exception e) {
                e.setMessage('No se obtuvo un token de autenticación válido.');
                throw e;
            }
        }
        System.debug(loggingLevel.Error, '*** request.getEndpoint(): ' + request.getEndpoint());
        System.debug(loggingLevel.Error, '*** request.getMethod(): ' + request.getMethod());
        System.debug(loggingLevel.Error, '*** request.getHeader(Content-Type): ' + request.getHeader('Content-Type'));
        System.debug(loggingLevel.Error, '*** request.getHeader(Authorization): ' + request.getHeader('Authorization'));
        System.debug(loggingLevel.Error, '*** strRequestBody: ' + strRequestBody);
        HttpResponse response = httpClient.send(request);
        System.debug(response );
        Integer statusCode = response.getStatusCode();
        String responseBody = response.getBody();
        System.debug(loggingLevel.Error, '*** statusCode: ' + statusCode);
        System.debug(loggingLevel.Error, '*** responseBody: ' + responseBody);
        if (String.isNotBlank(responseBody) && (statusCode == 200 || statusCode == 201)) {
            strJsonResponse = responseBody;
        } else {
            throw new AAZ_WebServiceException('No se obtuvo una respuesta correcta del servicio: ' + objEndpointSetting.MasterLabel.toUpperCase());
        }
        System.debug(loggingLevel.Error, '*** strJsonResponse: ' + strJsonResponse);
        if (objEndpointSetting.RequiresBodyEncryption__c) {
            try {
                strJsonResponse = AAZ_SecurityServices_cls.decryptPassword(
                    strJsonResponse, mainSettings.PasswordEncryptionKey__c, mainSettings.PasswordEncryptionAlgorithm__c);

            } catch (Exception e) {
                e.setMessage('No se obtuvo una respuesta correcta del servicio: ' + objEndpointSetting.MasterLabel.toUpperCase());
            }
        }
        System.debug(loggingLevel.Error, '*** strJsonResponse: ' + strJsonResponse);
        return strJsonResponse;


    }

    public static void setTestMock(){

        Map<String,Object> mapResponse = new Map<String,Object>();
        if(intTestMode == 1){
            mapResponse.put(strTestConfigName+'_Out',new Map<String,Object>{
                'customer' => new Map<String,Object>{
                    'customerName'=>'Fernando',
                    'customerLastName'=>'Sotelo',
                    'shippingAddress' => new Map<String,Object>{
                        'shippingCity'=>'Cuernavaca'
                    },
                    'opportunities'=> new List<Object>{
                        new Map<String,Object>{
                            'isWon'=>false,
                            'closeDate'=>'2017-05-05',
                            'createdDate'=>'2017-05-05T00:00:00',
                            'amount'=>100000.19,
                            'totalOpportunityQuantity'=>2
                        }
                    },
                    'notExistingMapping1'=>'test'
                },
                'notExistingMapping0'=>'test',
                'isSuccessful'=>true
            });
        }else if(intTestMode == 2){
            mapResponse.put(strTestConfigName+'_Out',new Map<String,Object>{
                'customers' => new List<Object>{
                    new Map<String,Object>{
                        'customerName'=>'Fernando',
                        'customerLastName'=>'Sotelo'
                    },
                    new Map<String,Object>{
                        'customerName'=>'Roberto',
                        'customerLastName'=>'Álvarez'
                    }
                },
                'isSuccessful'=>true
            });
        }else if(intTestMode == 3){
            mapResponse.put(strTestConfigName+'_Out',new Map<String,Object>{
                'dummyField0'=>false,
                'dummyField1'=>'T',
                'dummyField2'=>'2017-05-05',
                'dummyField3'=>'2017-05-05T00:00:00',
                'dummyField4'=>2.0123432,
                'dummyField5'=>10,
                'dummyField6'=>10.2,
                'dummyField7'=>'Test string',
                'dummyStructure'=>new Map<String,Object>(),
                'isSuccessful'=>true
            });
        }else if(intTestMode == 4){
            mapResponse.put(strTestConfigName+'_Out',new Map<String,Object>{
                'isSuccessful'=>false,
                'errorList'=>new List<Object>{
                    new Map<String,Object>{
                        'code'=>'test code',
                        'description'=>'test description'
                    }
                }
            });
        }
        else if(intTestMode == 5){
            mapResponse.put(strTestConfigName,new Map<String,Object>());
        }
        else if(intTestMode == 6){
            mapResponse.put('ErrorMessage',new Map<String,Object>());
        }

        else if(intTestMode == 7){
            System.debug('7');
            mapResponse.put('Out_ConsultaReferencias',new Map<String,Object>{

                'isSucessful'=>'true',
            	'employedServiceRs' =>  new Map<String,Object>{

             	'errorItem' => new List<Object>{},
                'beneficiaries' => new Map<String,Object>{'beneficiary' => new List<Object>{
                    	  		new Map<String,Object>{
                        			'isUpdateData'=>'true',
                        			'name'=>'teste',
                        			'paternalLastName'=>'teste',
                        			'maternalLastName'=>'teste',
                        			'gender'=>'M',
                        			'birthDate'=>'teste',
                        			'birthState'=>'teste',
                        			'curp'=>'teste',
                        			'relationship'=>'teste',
                        			'phone'=>'teste',
                        			'phoneType'=>'teste',
                        			'percentage'=>'teste'}
                    	    	}}
                	 }
        });
     System.debug(mapResponse);
        }
        else if(intTestMode == 8){

        AAZ_BeneficiaryQuery_cls.ResponseWrapper resposta = new AAZ_BeneficiaryQuery_cls.ResponseWrapper();
        AAZ_BeneficiaryQuery_cls.BeneficaryRs   aux1 = new AAZ_BeneficiaryQuery_cls.BeneficaryRs();
        AAZ_BeneficiaryQuery_cls.BeneficaryData aux2 = new AAZ_BeneficiaryQuery_cls.BeneficaryData();

        aux2.isSucessful = 'true';
        aux2.errorItem = new List<AAZ_BeneficiaryQuery_cls.Error>();
        AAZ_BeneficiaryQuery_cls.Beneficiary aux3 = new AAZ_BeneficiaryQuery_cls.Beneficiary();
        aux3.beneficiary = new List<AAZ_BeneficiaryQuery_cls.BeneficiaryCase>();
        AAZ_BeneficiaryQuery_cls.BeneficiaryCase caso1 = new AAZ_BeneficiaryQuery_cls.BeneficiaryCase();
 		caso1.isUpdateData = '';
    	caso1.name = '';
    	caso1.paternalLastName = '';
 		caso1.maternalLastName ='';
 		caso1.gender ='';
 		caso1.birthDate ='';
 		caso1.birthState ='';
 		caso1.curp ='';
 		caso1.relationship ='';
 		caso1.phone = '';
 		caso1.phoneType ='';
 		caso1.percentage ='';
 		aux3.beneficiary.add(caso1);
 		aux2.beneficiaries = aux3;
 		aux1.employedServiceRs = aux2;
 		resposta.Out_ConsultaBeneficiarios = aux1;

        }
System.debug('testedebug');
        Map<String,Object> mapDeserialized = (Map<String,Object>)JSON.deserializeUntyped(JSON.serializePretty(mapResponse));
        AAZ_GenericCallOutMock_mck mockInstance = new AAZ_GenericCallOutMock_mck(
            200,
            'SUCCESS',
            JSON.serializePretty(mapResponse),
            new Map<String,String>()
        );
        Test.setMock(HttpCalloutMock.class, mockInstance);
    }

    /**
     * Método principal de ejecución de llamado a servicios web (con parámetro isLastCallout en "true" por defecto).
     * @param  strRequestBody  Cadena JSON del cuerpo de la petición HTTP
     * @param  strConfigName   Nombre de l objeto de metadatos con la configuración a utilizar
     * @param  mapExtraHeaders Cabeceras HTTP adicionales
     * @return                 Cadena JSON con el cuerpo de la respuesta del servicio web
    **/

    public static String fn_runCallout(String strRequestBody, String strConfigName, Map<String, String> mapExtraHeaders)
    {
        return AAZ_GenericCallout_cls.fn_runCallout(strRequestBody, strConfigName, mapExtraHeaders, true);
    }

    /**
     * Obtener el endpoint del servicio dependiendo de la etapa de desarrollo
     * @param  objEndpointSetting Objeto de Configuración de Endpoint
     * @return                    Endpoint del servicio
    **/

    public static String getEndpoint(EndpointSetting__mdt objEndpointSetting) {
        String strEndpoint = '';
        if ('DEVELOPMENT'.equalsIgnoreCase(objEndpointSetting.Stage__c)) {
            strEndpoint = objEndpointSetting.DevelopmentEndpoint__c;
        } else if ('PRODUCTION'.equalsIgnoreCase(objEndpointSetting.Stage__c)) {
            strEndpoint = objEndpointSetting.ProductionEndpoint__c;
        } else if ('QA'.equalsIgnoreCase(objEndpointSetting.Stage__c)) {
            strEndpoint = objEndpointSetting.QAEndpoint__c;
        }
        return strEndpoint;
    }

    /**
     * Establecer token de autenticación en la petición HTTP
     * @param request Objeto Request
    **/

    private static void setServiceToken(HttpRequest request) {
        User u = AAZ_Utils_cls.getUserCustomInfo(UserInfo.getUserId());
        //AppMainSetting_cs__c mainSettings = AppMainSetting_cs__c.getOrgDefaults();
        String tokenUsername = u.EmployeeNumber;
        String tokenPassword = mainSettings.PasswordServiceToken__c;
        String strPlainToken = AAZ_SecurityServices_cls.getPlainToken(tokenUsername, tokenPassword);
        request.setHeader('Authorization', tokenUsername + ':' + strPlainToken);
    }

    /**
     * Método genérico para generar Request como un Mapa de objetos.
     * @param  strSetupCode  Nombre del objeto de metadatos a utilizar para la generación del Request
     * @param  requestObject Objeto de Salesforce del cual se tomarán los campos para el Mapeo
     * @param  mapExtraAttrs Atributos adicionales en caso de ser requeridos
     * @return               Mapa de Objetos que representa el Request.
    **/

    public static Map<String, Object> generateRequestMap(String strSetupCode, SObject[] lstRequestObjects, Map<String, Object> mapExtraAttrs)
    {
        User usr = AAZ_Utils_cls.getUserCustomInfo(UserInfo.getUserId());
        lstRequestObjects.add(usr);
        Map<String, SObject> mapRequestObjects = new Map<String, SObject>();
        for (SObject obj : lstRequestObjects) {
            if (obj != null) {
                mapRequestObjects.put(obj.getSObjectType().getDescribe().getName(), obj);
            }
        }
        Map<String, Object> mapRequest = new Map<String, Object>();
        EndpointSetting__mdt objEndpointSetting = AAZ_Utils_cls.getEndpointSetting(strSetupCode, 'REQUEST');
        for (ServiceMapping__mdt objMapping : objEndpointSetting.ServiceMapping__r) {
            if (objMapping.AppliesConstantValue__c) {
                assignDefaultAttribute(mapRequest, objMapping);
            } else {
                SObject objRequest = mapRequestObjects.get(objMapping.ObjectName__c);
                if (objRequest == null) {
                    continue;
                }
                if (String.isNotBlank(String.valueOf(objRequest.get(objMapping.ObjectField__c)))) {
                    // Mapeos tomados de objetos SFDC
                    try {
                        mapRequest.put( objMapping.AttributeName__c, objRequest.get(objMapping.ObjectField__c) );
                    } catch (Exception ex) {
                        // poner nuevo metodo aqui
                    }
                }
            }
        }
        if (mapExtraAttrs != null && !mapExtraAttrs.isEmpty()) {
            mapRequest.putAll(mapExtraAttrs);
        }
        return mapRequest;
    }

    /**
     * Asignar un valor por defecto a un objeto request
     * @param mapR       Mapa de request/response al que se establecerá el valor
     * @param objMapping Objeto de mapeo de campos con la información de la asignación
    **/

    @testVisible private static void assignDefaultAttribute(Map<String, Object> mapR, ServiceMapping__mdt objMapping)
    {
        String dataType = objMapping.DataType__c;
        String attrName = objMapping.AttributeName__c;
        if ('STRING'.equalsIgnoreCase(dataType) || 'CHAR'.equalsIgnoreCase(dataType)) {
            mapR.put(attrName, objMapping.DefaultValueTxt__c);
        } else if ('BOOLEAN'.equalsIgnoreCase(dataType)) {
            mapR.put(attrName, objMapping.DefaultValueBLN__c);
        } else if ('INTEGER'.equalsIgnoreCase(dataType)) {
            mapR.put(attrName, Integer.valueOf(objMapping.DefaultValueNbr__c));
        } else if ('NUMBER'.equalsIgnoreCase(dataType)) {
            mapR.put(attrName, Integer.valueOf(objMapping.DefaultValueNbr__c));
        } else if ('DOUBLE'.equalsIgnoreCase(dataType)) {
            mapR.put(attrName, Double.valueOf(objMapping.DefaultValueNbr__c));
        }
    }

    /**
     * Método genérico para procesar una respuesta de web service y generar objetos de Salesforce.
     * @param  strJsonResponse Cadena JSON de la respuesta HTTP
     * @param  strSetupCode    Nombre del servicio web (configuración de metadatos)
     * @return                 Mapa contenedor de la respuesta
    **/

    public static Map<String, Object> processServiceResponse(String strJsonResponse, String strSetupCode)
    {
        EndpointSetting__mdt objEndpointSetting = AAZ_Utils_cls.getEndpointSetting(strSetupCode, 'RESPONSE');
        Map<String, Object> mapResponse = new Map<String, Object>();
        Map<String, Object> mapResult = new Map<String, Object>();
        Map<String, Object> mapResponseContainer = (Map<String, Object>) JSON.deserializeUntyped(strJsonResponse);
        System.debug('this shit = '+mapResponseContainer);
        if (!mapResponseContainer.containsKey(strSetupCode + '_Out')) {
            if (mapResponseContainer.containsKey('ErrorMessage')) {
                throw new AAZ_WebServiceException('ERROR: ' + String.valueOf(mapResponseContainer.get('ErrorMessage')));
            } else {
                throw new AAZ_WebServiceException('No se obtuvo una respuesta correcta del servicio: ' );
            }
        }
        mapResponse = (Map<String, Object>) mapResponseContainer.get(strSetupCode + '_Out');
        Boolean isSuccessful = false;
        if (mapResponse.containsKey('isSuccessful')) {
            isSuccessful = (Boolean) mapResponse.get('isSuccessful');
        }

        if (!isSuccessful) {
            Object[] lstObjErrors = null;
            if (mapResponse.containsKey('errorList')) {
                lstObjErrors = (Object[]) mapResponse.get('errorList');
            } else {
                throw new AAZ_WebServiceException('No se obtuvo una respuesta correcta del servicio. ');
            }
            String[] lstErrorList = new String[]{};
            for (Object objError: lstObjErrors) {
                Map<String, Object> mapError = (Map<String, Object>) objError;
                lstErrorList.add((String) mapError.get('description'));
            }
            String strError = String.join(lstErrorList, ', ');
            String transactionId = String.valueOf(mapResponse.get('transactionId'));
            strError += ' --- ID de Operación: ' + transactionId;
            throw new AAZ_WebServiceException(strError);
        }
        for (ServiceMapping__mdt mapping: objEndpointSetting.ServiceMapping__r) {
            if (String.isBlank(mapping.ParentAttributeName__c)) {
                setResultAttribute(mapResult, mapResponse, mapping, objEndpointSetting);
            }
        }
        return mapResult;
    }

    /**
     * Asignar un atributo al mapa de respuesta del método processServiceResponse
     * @param mapResult          Mapa que se retornará como resultado del procesamiento
     * @param mapResponse        Mapa que representa la respuesta del servicio web
     * @param mapping            Mapeo de campos usado para establecer el valor del atributo
     * @param objEndpointSetting Configuración de metadatos a utilizar
    **/

    @TestVisible private static void setResultAttribute(Map<String, Object> mapResult, Map<String, Object> mapResponse, ServiceMapping__mdt mapping, EndpointSetting__mdt objEndpointSetting)
    {
        String dataType  = mapping.DataType__c;
        String attrName  = mapping.AttributeName__c;
        String fieldName = mapping.ObjectField__c;
        if (!mapResponse.containsKey(attrName)) {
            return;
        }
        try {
            if('BOOLEAN'.equalsIgnoreCase(dataType)) {
                mapResult.put(attrName, Boolean.valueOf(mapResponse.get(attrName)));
            }
            else if('STRING'.equalsIgnoreCase(dataType)) {
                mapResult.put(attrName, String.valueOf(mapResponse.get(attrName)));
            }
            else if('DATE'.equalsIgnoreCase(dataType)) {
                mapResult.put(attrName, Date.valueOf(String.valueOf(mapResponse.get(attrName))));
            }
            else if('DATETIME'.equalsIgnoreCase(dataType)) {
                String strDatetime = String.valueOf(mapResponse.get(attrName));
                Datetime dt = AAZ_Utils_cls.strToDatetime(strDatetime);
                mapResult.put(attrName, dt);
            }
            else if('DOUBLE'.equalsIgnoreCase(dataType) || 'NUMBER'.equalsIgnoreCase(dataType)) {
                mapResult.put(attrName, Decimal.valueOf(String.valueOf(mapResponse.get(attrName)).trim()));
            }
            else if('INTEGER'.equalsIgnoreCase(dataType)) {
                mapResult.put(attrName, Integer.valueOf(String.valueOf(mapResponse.get(attrName)).trim()));
            }
            else if ('SOBJECT'.equalsIgnoreCase(dataType)) {
                SObject sObj = Schema.getGlobalDescribe().get(mapping.ObjectName__c).newSObject();
                Map<String, Object> childMapResponse = (Map<String, Object>) mapResponse.get(attrName);
                for (ServiceMapping__mdt childMapping: objEndpointSetting.ServiceMapping__r) {
                    if (attrName.equalsIgnoreCase(childMapping.ParentAttributeName__c)) {
                        setObjectField(sObj, childMapResponse, childMapping, objEndpointSetting, mapResult);
                    }
                }
                mapResult.put(attrName, sObj);
            }
            else if ('STRUCTURE'.equalsIgnoreCase(dataType)) {
                Map<String, Object> childMapResult = new Map<String, Object>();
                Map<String, Object> childMapResponse = (Map<String, Object>) mapResponse.get(attrName);
                for (ServiceMapping__mdt childMapping: objEndpointSetting.ServiceMapping__r) {
                    if (attrName.equalsIgnoreCase(childMapping.ParentAttributeName__c)) {
                        setResultAttribute(childMapResult, childMapResponse, childMapping, objEndpointSetting);
                    }
                }
                mapResult.put(attrName, childMapResult);
            }
            else if ('LIST'.equalsIgnoreCase(dataType)) {
                Object[] lstResponseObjects = new Object[]{};
                try {
                    if (mapResponse.containsKey(attrName)) {
                        lstResponseObjects = (Object[]) mapResponse.get(attrName);
                    }
                } catch (Exception ex) {
                    // poner nuevo metodo aqui
                }
                SObject[] lstSObjects = new SObject[]{};
                for (Object childObjResponse: lstResponseObjects) {
                    Map<String, Object> mapObjResponse = (Map<String, Object>) childObjResponse;
                    SObject sObj = Schema.getGlobalDescribe().get(mapping.ObjectName__c).newSObject();
                    for (ServiceMapping__mdt childMapping: objEndpointSetting.ServiceMapping__r) {
                        if (attrName.equalsIgnoreCase(childMapping.ParentAttributeName__c)) {
                            setObjectField(sObj, mapObjResponse, childMapping, objEndpointSetting, mapResult);
                        }
                    }
                    lstSObjects.add(sObj);
                }
                mapResult.put(attrName, lstSObjects);
            }
        } catch (Exception ex) {
            // poner nuevo metodo aqui
            mapResult.put(attrName, null);
        }
    }

    /**
     * Asignar un campo a un objeto generado como procesamiento de una respuesta de web service
     * @param objResult          Objeto al cual se asignará el campo
     * @param mapResponse        Objeto que representa la respuesta del servicio web
     * @param mapping            Mapeo de campos a utilizar para asignar el valor
     * @param objEndpointSetting Configuración de Endpoint a utilizar
    **/

    @TestVisible private static void setObjectField(SObject objResult, Map<String, Object> mapResponse, ServiceMapping__mdt mapping, EndpointSetting__mdt objEndpointSetting, Map<String, Object> mapResult)
    {
        String dataType  = mapping.DataType__c;
        String attrName  = mapping.AttributeName__c;
        String fieldName = mapping.ObjectField__c;
        if (!mapResponse.containsKey(attrName)) {
            return;
        }
        try {
            if('BOOLEAN'.equalsIgnoreCase(dataType)) {
                objResult.put(fieldName, Boolean.valueOf(mapResponse.get(attrName)));
            }
            else if('STRING'.equalsIgnoreCase(dataType) || 'CHAR'.equalsIgnoreCase(dataType)) {
                objResult.put(fieldName, String.valueOf(mapResponse.get(attrName)));
            }
            else if('DATE'.equalsIgnoreCase(dataType)) {
                objResult.put(fieldName, Date.valueOf((String) mapResponse.get(attrName)));
            }
            else if('DATETIME'.equalsIgnoreCase(dataType)) {
                String strDatetime = String.valueOf(mapResponse.get(attrName));
                Datetime dt = AAZ_Utils_cls.strToDatetime(strDatetime);
                objResult.put(fieldName, dt);
            }
            else if('DOUBLE'.equalsIgnoreCase(dataType) || 'NUMBER'.equalsIgnoreCase(dataType)) {
                objResult.put(fieldName, Double.valueOf(mapResponse.get(attrName)));
            }
            else if('INTEGER'.equalsIgnoreCase(dataType)) {
                objResult.put(fieldName, Integer.valueOf(mapResponse.get(attrName)));
            }
            else if ('STRUCTURE'.equalsIgnoreCase(dataType)) {
                Map<String, Object> childMapResponse = (Map<String, Object>) mapResponse.get(attrName);
                for (ServiceMapping__mdt childMapping: objEndpointSetting.ServiceMapping__r) {
                    if (attrName.equalsIgnoreCase(childMapping.ParentAttributeName__c)) {
                        setObjectField(objResult, childMapResponse, childMapping, objEndpointSetting, mapResult);
                    }
                }
            }
            else if ('LIST'.equalsIgnoreCase(dataType)) {
                Object[] lstResponseObjects = (Object[]) mapResponse.get(attrName);
                SObject[] lstSObjects = new SObject[]{};
                for (Object childObjResponse: lstResponseObjects) {
                    Map<String, Object> mapObjResponse = (Map<String, Object>) childObjResponse;
                    SObject sObj = Schema.getGlobalDescribe().get(mapping.ObjectName__c).newSObject();
                    for (ServiceMapping__mdt childMapping: objEndpointSetting.ServiceMapping__r) {
                        if (attrName.equalsIgnoreCase(childMapping.ParentAttributeName__c)) {
                            try {
                                if (String.isBlank(childMapping.AttributeName__c)
                                    && String.isNotBlank(childMapping.ParentAttributeId__c)) {
                                    String[] lstParentIdAttributes = childMapping.ParentAttributeId__c.split(',');
                                    String[] lstParentIdValues = new String[]{};
                                    for (String str: lstParentIdAttributes) {
                                        lstParentIdValues.add(String.valueOf(mapResponse.get(str)));
                                    }
                                    sObj.put(childMapping.ObjectField__c, String.join(lstParentIdValues, '_'));
                                } else {
                                    setObjectField(sObj, mapObjResponse, childMapping, objEndpointSetting, mapResult);
                                }
                            } catch(Exception ex) {
                                // poner nuevo metodo aqui
                            }
                        }
                    }
                    lstSObjects.add(sObj);
                }
                if (!mapResult.containsKey(attrName)) {
                    mapResult.put(attrName, lstSObjects);
                } else {
                    SObject[] lstExistObjects = (SObject[]) mapResult.get(attrName);
                    for (sObject o: lstSObjects) {
                        lstExistObjects.add(o);
                    }
                }
            }
        } catch(Exception ex) {
            // poner nuevo metodo aqui
        }
    }


    /**
     * Generar una lista de mapas para serializar en una lista JSON
     * @param  strConfigCode   Código de configuración para tomar mapeos de campos
     * @param  lstTransactions Lista de movimientos
     * @return                 [description]
    **/
    /*

    public static List<Map<String, Object>> generateListMap(String strConfigCode, String jsonListName, SObject[] lstObjects)
    {
        List<Map<String, Object>> lstMapObjects = new List<Map<String, Object>>();
        String strQueryOverEndpointAndRelatedSettings = 'SELECT '+String.join(new List<String>(SObjectType.EndpointSetting__mdt.Fields.getMap().keySet()),', ')+', (SELECT '+String.join(new List<String>(SObjectType.ServiceMapping__mdt.Fields.getMap().keySet()),', ')+' FROM ServiceMapping__r WHERE Component__c = \'REQUEST\' AND ParentAttributeName__c = \''+jsonListName+'\' AND IsActive__c = true) FROM EndpointSetting__mdt WHERE DeveloperName = \''+strConfigCode+'\' limit 1';
        EndpointSetting__mdt objEndpointSetting = Database.query(strQueryOverEndpointAndRelatedSettings);
        for (SObject obj: lstObjects) {
            Map<String, Object> mapObject = new Map<String, Object>();
            for (ServiceMapping__mdt objMapping : objEndpointSetting.ServiceMapping__r) {
                String dataType = objMapping.DataType__c;
                String attrName = objMapping.AttributeName__c;
                try {
                    if (objMapping.AppliesConstantValue__c) {
                        if ('STRING'.equalsIgnoreCase(dataType) || 'CHAR'.equalsIgnoreCase(dataType)) {
                            mapObject.put(attrName, objMapping.DefaultValueTxt__c);
                        } else if ('BOOLEAN'.equalsIgnoreCase(dataType)) {
                            mapObject.put(attrName, objMapping.DefaultValueBLN__c);
                        } else if ('INTEGER'.equalsIgnoreCase(dataType)) {
                            mapObject.put(attrName, Integer.valueOf(objMapping.DefaultValueNbr__c));
                        } else if ('NUMBER'.equalsIgnoreCase(dataType)) {
                            mapObject.put(attrName, Integer.valueOf(objMapping.DefaultValueNbr__c));
                        } else if ('DOUBLE'.equalsIgnoreCase(dataType)) {
                            mapObject.put(attrName, Double.valueOf(objMapping.DefaultValueNbr__c));
                        }
                    } else {
                        mapObject.put(attrName, obj.get(objMapping.ObjectField__c));
                    }
                } catch (Exception ex) {
                    // poner nuevo metodo aqui
                }
            }
            lstMapObjects.add(mapObject);
        }
        return lstMapObjects;
    }*/
}