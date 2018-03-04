/****************************************************************************************
    Desarrollado por:  Avanxo México
    Autor:             Luis Enrique Garcia Sanabria
    Proyecto:          Mesa de Control Afore
    Descripción:       Clase de APEX que realiza la función de controlador perzonalizado
    para la página de visualForce AAZ_RiskLevel_pag en la que se muestra la tabla de los
    niveles de riesgo que tiene en conjunto el tramite en cuestion (Caso), el trabajador
    (Cuenta) y el Agente promotor (Contacto)

    Cambios (Versiones)
    -------------------------------------
      No.      Fecha                  Autor                      Descripción
    ------  -------------  ------------------------------   ----------------------
     0.1     30-06-2017    Luis Enrique Garcia Sanabria     Creacion
     0.2     30-06-2017    Luis Enrique Garcia Sanabria     Construcción
     1.0     11-08-2017    Luis Enrique Garcia Sanabria     Finalización y documentación
****************************************************************************************/

global class AAZ_Utils_cls {

    /**
     * Obtener mapa de todos los tipos de registro usando un campo especificado como llave
     * de los elementos del mapa.
     * @param      keyField  Campo llave a utilizar en el mapa.
     * @return     Mapa de tipos de registro (Ej. <SObjectName, Map<Key, RecordType>>)
    **/

    public static Map<String, Map<String, RecordType>> getRecordTypes(String keyField) {
        RecordType[] lstRecordTypes = new List<RecordType>();
        Map<String, Map<String, RecordType>> mapRecordTypes = new Map<String, Map<String, RecordType>>();
        String strQuerryRecordType = 'SELECT '+String.join(new List<String>(SObjectType.RecordType.Fields.getMap().keySet()), ', ')+' FROM RecordType WHERE IsActive = true';
        try{lstRecordTypes = Database.query(strQuerryRecordType);}catch(QueryException qE){}catch(Exception gE){}
        if(!lstRecordTypes.isEmpty()) {
            for (RecordType recType : lstRecordTypes) {
                String objType = recType.SobjectType;
                if (!mapRecordTypes.containsKey(objType)) {
                    mapRecordTypes.put(objType, new Map<String, RecordType>());
                }
                if(mapRecordTypes.containsKey(objType)) {
                    mapRecordTypes.get(objType).put((String)recType.get(keyField), recType);
                }
            }
        }
        return mapRecordTypes;
    }

    /**
     * Genera un mapa de cualquier lista de objetos usando como llave un campo especificado.
     * @param  lstObjects Lista de objetos para generar el mapa
     * @param  keyField   Nombre del campo llave a utilizar
     * @return            Mapa de objetos generado
    **/

    public static Map<String, SObject> generateMapWithCustomKey(SObject[] lstObjects, String keyField) {
        Map<String, SObject> mapObjects = new Map<String, SObject>();
        for (SObject obj : lstObjects) {
            mapObjects.put((String)obj.get(keyField), obj);
        }
        return mapObjects;
    }

    /**
     * Obtener información del usuario actual (solo cuando la clase UserInfo no contiene la información requerida)
     * @param  userId Id del usuario
     * @return        Usuario encontrado
    **/

    public static User getUserCustomInfo(Id userId) {
        String query = 'SELECT ' + String.join(new List<String>(SObjectType.User.Fields.getMap().keySet()),', ') + ' FROM User WHERE Id = \'' + userId + '\' LIMIT 1';
        User usr = Database.query(query);
        return usr;
    }

    /**
     * Obtener configuración de mapeo de campos sin incluir mapeos de campos
     * @param  strSetupCode Código de configuración
     * @return              Objeto de configuración de Endpoing
    **/

    public static EndpointSetting__mdt getEndpointSetting(String strSetupCode){
        EndpointSetting__mdt objEndpointSetting = new EndpointSetting__mdt();
        String strQueryOverEndpointSetting = 'SELECT '+String.join(new List<String>(SObjectType.EndpointSetting__mdt.Fields.getMap().keySet()),', ')+' FROM EndpointSetting__mdt WHERE DeveloperName = \''+strSetupCode+'\' LIMIT 1';
        try {objEndpointSetting = Database.query(strQueryOverEndpointSetting);} catch(DmlException dE){} catch(Exception e) {}
        return objEndpointSetting;
    }


    /**
    * Registrar una excepción en el log de errores del sistema
    * @param caseDescription Mensaje de error
    * @param caseType tipo de error
    * @param caseRecordNumber Id del registro
    * @param currentUser id del usuario actual
    **/
    public static void insertIncidence(String caseDescription, String caseType, Id caseRecordNumber, Id currentUser) {
        SystemIssue__c  newLog = new SystemIssue__c (
            Message__c = caseDescription,
            Type__c    = caseType,
            CaseId__c  = caseRecordNumber,
            UserId__c  = currentUser
        );
        Database.SaveResult sr = Database.insert(newLog, true);
        if(!sr.isSuccess()) {
            System.debug(loggingLevel.Error, '*** sr.getErrors(): ' + sr.getErrors());
        }
    }


    /**
     * Obtener configuración de mapeo de campos sin incluir mapeos de campos
     * @param  strSetupCode Código de configuración
     * @param  mappingType  Tipo de mapeo (REQUEST/RESPONSE)
     * @return              Objeto de configuración de Endpoing
    **/

    public static EndpointSetting__mdt getEndpointSetting(String strSetupCode, String mappingType){
        /*Revisión René: Meter query en try catch pero antes inicializar el objeto objEndpointSetting*/
        mappingType = mappingType.toUpperCase();
        String strQueryOverEndpointAndRelatedSettings = 'SELECT '+String.join(new List<String>(SObjectType.EndpointSetting__mdt.Fields.getMap().keySet()),', ')+', (SELECT '+String.join(new List<String>(SObjectType.ServiceMapping__mdt.Fields.getMap().keySet()),', ')+' FROM ServiceMapping__r WHERE Component__c = \''+mappingType+'\' AND IsActive__c = true) FROM EndpointSetting__mdt WHERE DeveloperName = \''+strSetupCode+'\' limit 1';
        EndpointSetting__mdt objEndpointSetting = Database.query(strQueryOverEndpointAndRelatedSettings);
        return objEndpointSetting;
    }

    /**
     * Convierte una fecha en formato "2017-02-01T10:14:58.421-06:00" a "2017-02-01 10:14:58"
     * @param  strDatetime Cadena de fecha a convertir
     * @return             Fecha/Hora generada
    **/

    public static Datetime strToDatetime(String strDatetime) {
        Datetime dt = null;
        try {
            strDatetime      = strDatetime.trim().replace('T', ' ').substring(0, 16); // 'yyyy-mm-dd hh:mm'
            String strDate   = strDatetime.substringBeforeLast(' ');
            String[] lstTime = strDatetime.substringAfterLast(' ').split(':');
            Date mDate = Date.valueOf(strDate);
            Time mTime = Time.newInstance(Integer.valueOf(lstTime[0]), Integer.valueOf(lstTime[1]), 0, 0);
            dt = Datetime.newInstance(mDate, mTime);
        } catch (Exception e){}
        return dt;
    }

    /*******************************************************************************************************
    * @description Objectos para las respuestas de los servicios web
    * @param objectName the name of the object to look up
    * @param fieldName the name of the field to look up
    * @return the describe field result for the given field
    * @example
    * Account a = new Account();
    **/

    global class reponseServices
    {
        public Boolean isSucessful;
        public errorList errorlist;
    }

    global class errorList
    {
        public String code;
        public String description;
    }

    public Static reponseServices getResponseServ(Boolean isSucessful,String code,String description)
    {
        reponseServices respuesta=new reponseServices();
        errorList errList=new errorList();
        respuesta.isSucessful=isSucessful;
        errList.code=code;
        errList.description=description;
        respuesta.errorlist=errList;
        return respuesta;
    }

    public static List<Schema.FieldSetMember> getFieldSetMembers(String strSObject, String strType, String strSubType, String strSubSubType){
        strType = (strType==null)?'':strType;
        strSubType = (strSubType==null)?'':strSubType;
        strSubSubType = (strSubSubType==null)?'':strSubSubType;
        System.debug(loggingLevel.Error, '*** strSObject: ' + strSObject);
        System.debug(loggingLevel.Error, '*** strType: ' + strType);
        System.debug(loggingLevel.Error, '*** strSubType: ' + strSubType);
        System.debug(loggingLevel.Error, '*** strSubSubType: ' + strSubSubType);
        List<ByObjectFieldSets__mdt> lstMtdTypes = new List<ByObjectFieldSets__mdt>();
        List<Schema.FieldSetMember> lstFieldSetMemebers =  new List<Schema.FieldSetMember>();
        String strMtdTypesQueryStatement = 'SELECT '+String.join(new List<String>(SObjectType.ByObjectFieldSets__mdt.Fields.getMap().keySet()),', ')+' FROM ByObjectFieldSets__mdt WHERE Type__c = \''+strType+'\' AND SubType__c = \''+strSubType+'\' AND SubSubType__c = \''+strSubSubType+'\' AND SObject__c = \''+strSObject+'\'';
        try{lstMtdTypes = Database.query(strMtdTypesQueryStatement);}catch(QueryException qE){}catch(UnexpectedException uE){}catch(Exception gE){}
        if(lstMtdTypes.isEmpty()){
            strMtdTypesQueryStatement = 'SELECT '+String.join(new List<String>(SObjectType.ByObjectFieldSets__mdt.Fields.getMap().keySet()),', ')+' FROM ByObjectFieldSets__mdt WHERE MasterLabel = \'Default\' AND SObject__c = \''+strSObject+'\'';
            try{lstMtdTypes = Database.query(strMtdTypesQueryStatement);}catch(QueryException qE){}catch(UnexpectedException uE){}catch(Exception gE){}
        }
        if(!lstMtdTypes.isEmpty()){
            String strFieldSetName = lstMtdTypes.get(0).FieldSetAPIName__c;
            if(strFieldSetName != null && !String.isBlank(strFieldSetName)){
                if(strSObject == 'Account'){
                    Schema.FieldSet fs = Schema.SObjectType.Account.fieldSets.getMap().get(strFieldSetName);
                    if(fs==null){
                        fs = Schema.SObjectType.Account.fieldSets.getMap().get('Default');
                    }
                    lstFieldSetMemebers = fs.getFields();
                }
                if(strSObject == 'Case'){                    
                    Schema.FieldSet fs = Schema.SObjectType.Case.fieldSets.getMap().get(strFieldSetName);
                    if(fs==null){
                        fs = Schema.SObjectType.Case.fieldSets.getMap().get('Default');
                    }
                    lstFieldSetMemebers = fs.getFields();
                }
                if(strSObject == 'Contact'){
                    Schema.FieldSet fs = Schema.SObjectType.Contact.fieldSets.getMap().get(strFieldSetName);
                    if(fs==null){
                        fs = Schema.SObjectType.Contact.fieldSets.getMap().get('Default');
                    }
                    lstFieldSetMemebers = fs.getFields();
                }
            }
        }
        return lstFieldSetMemebers;
    }



    /*
        Método para validar si los documentos requeridos por cada tramite estan en el mismo.
    */

    public static Boolean documentsRequiredComplete( Case objCase ){
        Boolean                                   blnServiceHadError           = false;
        string                                    stgMessage                   = '';
        String                                    stgtypeError                 = Label.AAZ_Utils_001;
        id                                        idCurrentCase                = objCase.Id;
        id                                        idCurrentId                  = UserInfo.getUserId();
        Boolean                                   blnDocComplete               = true;
        String                                    stgType                      = objCase.Type;
        String                                    stgSubType                   = objCase.SubType__c;
        String                                    stgSubSubType                = objCase.SubSubType__c;
        string                                    stgDefault                   = Label.AAZ_Utils_002;
        List<Document__c>                         lstDocs                      = new List<Document__c>();
        List<RequiredDocument__mdt>               lstReqDocs                   = new List<RequiredDocument__mdt>();
        set<String>                               setDocs                      = new set<String>();
        String                                    strQueryOverRequireddocument = '';
        String                                    strQueryOverDocuments        = '';
        String                                    strQueryRequiredDoc          = '';
        String                                    strQueryProcedureData        = '';
        String                                    strSpecialType               = 'Retiros Totales';
        Procedure__mdt                            objProcedureData             = new Procedure__mdt();
        List<TotalWithdrawalsDocuments__mdt>      lstTotalWithdrawals          = new List<TotalWithdrawalsDocuments__mdt>();
        Map<String, Map<String, RecordType>>      mapRegisterType              = new Map<string, Map<String, RecordType>>();
        String                                    caseDevName                  = '';
        String                                    strAPRegisterType            = 'AgentPromotionVerification';

        mapRegisterType = AAZ_Utils_cls.getRecordTypes('Id');
        caseDevName= (mapRegisterType.get('Case').containsKey(objCase.RecordTypeId))
            ?mapRegisterType.get('Case').get(objCase.RecordTypeId).DeveloperName:'';
        if(idCurrentCase != null) {
            strQueryOverDocuments = 'SELECT '+String.join(new List<String>(SObjectType.Document__c.Fields.getMap().keySet()), ', ')+' FROM Document__c WHERE RelatedProcedure__c = \''+idCurrentCase+'\'';
            try{lstDocs = Database.query(strQueryOverDocuments);}catch(QueryException qE){blnServiceHadError = true;stgMessage = qE.getMessage();}catch(Exception gE){blnServiceHadError = true; stgMessage = gE.getMessage();}
            System.debug(loggingLevel.Error, '*** lstDocs: ' + lstDocs);
            if(!lstDocs.isEmpty()) {
                for(Document__c rD: lstDocs) {
                    setDocs.add(rD.DocumentTypeId__c);
                }
            } else {
                blnDocComplete = false;
            }            
        }
        if(stgType != null || !String.isBlank(stgType)) {
            /*if (stgType == strSpecialType) {
                if (
                    (objCase.IdWithdrawtype__c!=null || !String.isBlank(objCase.IdWithdrawtype__c)) &&
                    (objCase.IdSecuritytype__c!=null || !String.isBlank(objCase.IdSecuritytype__c)) &&
                    (objCase.IdPensiontype__c!=null || !String.isBlank(objCase.IdPensiontype__c)) &&
                    (objCase.idRegimeType__c!=null || !String.isBlank(objCase.idRegimeType__c))
                ) {
                    String strQueryTotalWithdrawals = 'SELECT '+String.join(
                        new List<String>(SObjectType.TotalWithdrawalsDocuments__mdt.Fields.getMap().keySet()), ', ')+' FROM TotalWithdrawalsDocuments__mdt WHERE TypePension__c = \''+objCase.IdPensiontype__c+'\' AND RegimeType__c = '+objCase.idRegimeType__c+' AND TypeRetreat__c =\''+objCase.IdWithdrawtype__c+'\' AND TypeInsurance__c = \''+objCase.IdSecuritytype__c+'\'';

                    try{lstTotalWithdrawals = Database.query(strQueryTotalWithdrawals);}catch(QueryException qE){blnServiceHadError = true;stgMessage = qE.getMessage();}catch(Exception gE){blnServiceHadError = true; stgMessage = gE.getMessage();}

                    if(lstTotalWithdrawals.isEmpty()) {
                        blnDocComplete = false;
                    } else {
                        for(TotalWithdrawalsDocuments__mdt iterator:lstTotalWithdrawals){
                            if(!setDocs.contains(String.valueOf(iterator.ScannerID__c))) {
                                blnDocComplete = false;
                                break;
                            }
                        }
                    }
                } else {
                    blnDocComplete = false;
                }

            } else {*/
                if(stgSubType != null || !String.isBlank(stgSubType)) {
                    strQueryProcedureData = 'SELECT '+String.join(new List<String>(SObjectType.Procedure__mdt.Fields.getMap().keySet()), ', ')+' FROM Procedure__mdt WHERE ServiceType__c = \''+stgType+'\' AND SubType__c= \''+stgSubType+'\' LIMIT 1';
                } else {
                    strQueryProcedureData = 'SELECT '+String.join(new List<String>(SObjectType.Procedure__mdt.Fields.getMap().keySet()), ', ')+' FROM Procedure__mdt WHERE ServiceType__c = \''+stgType+'\' LIMIT 1';
                }
                System.debug(loggingLevel.Error, '*** strQueryProcedureData: ' + strQueryProcedureData);
                try{objProcedureData = Database.query(strQueryProcedureData);}catch(QueryException qE){blnServiceHadError = true;stgMessage = qE.getMessage();}catch(Exception gE){blnServiceHadError = true; stgMessage = gE.getMessage();}
                System.debug(loggingLevel.Error, '*** objProcedureData: ' + objProcedureData);
                Procedure__mdt emptyProcedure = new Procedure__mdt();
                if (objProcedureData == emptyProcedure) {
                    System.debug(loggingLevel.Error, '*** 5:');
                    blnDocComplete = false;
                } else {
                    System.debug(loggingLevel.Error, '*** 6:');
                    strQueryRequiredDoc = 'SELECT '+String.join(new List<String>(SObjectType.RequiredDocument__mdt.Fields.getMap().keySet()), ', ')+', RelatedDocumentType__r.DigitizationID__c, RelatedDocumentType__r.IsRequired__c FROM RequiredDocument__mdt WHERE RelatedDocumentType__r.IsRequired__c = true AND RelatedProcedure__c = \''+objProcedureData.Id+'\'';
                    try{lstReqDocs = Database.query(strQueryRequiredDoc);}catch(QueryException qE){blnServiceHadError = true;stgMessage = qE.getMessage();}catch(Exception gE){blnServiceHadError = true; stgMessage = gE.getMessage();}
                }


                if(!lstReqDocs.isEmpty()) {
                    for(RequiredDocument__mdt rqD: lstReqDocs) {
                        System.debug(loggingLevel.Error, '*** Documento: ' + rqD.RelatedDocumentType__r.DigitizationID__c);
                        if(!setDocs.contains(rqD.RelatedDocumentType__r.DigitizationID__c)) {
                            System.debug(loggingLevel.Error, '*** 7:');
                            blnDocComplete = false;
                            break;
                        }
                    }
                }
            //}
        } else {
            if (strAPRegisterType == caseDevName) {
                strQueryProcedureData = 'SELECT '+String.join(new List<String>(SObjectType.Procedure__mdt.Fields.getMap().keySet()), ', ')+' FROM Procedure__mdt WHERE ServiceType__c = \''+caseDevName+'\' LIMIT 1';
                try{objProcedureData = Database.query(strQueryProcedureData);}catch(QueryException qE){blnServiceHadError = true;stgMessage = qE.getMessage();}catch(Exception gE){blnServiceHadError = true; stgMessage = gE.getMessage();}
                Procedure__mdt emptyProcedure = new Procedure__mdt();
                if (objProcedureData == emptyProcedure) {
                    System.debug(loggingLevel.Error, '*** 8:');
                    blnDocComplete = false;
                } else {
                    System.debug(loggingLevel.Error, '*** 9:');
                    strQueryRequiredDoc = 'SELECT '+String.join(new List<String>(SObjectType.RequiredDocument__mdt.Fields.getMap().keySet()), ', ')+', RelatedDocumentType__r.DigitizationID__c FROM RequiredDocument__mdt WHERE RelatedProcedure__c = \''+objProcedureData.Id+'\'';
                    try{lstReqDocs = Database.query(strQueryRequiredDoc);}catch(QueryException qE){blnServiceHadError = true;stgMessage = qE.getMessage();}catch(Exception gE){blnServiceHadError = true; stgMessage = gE.getMessage();}
                }

                if(!lstReqDocs.isEmpty()) {
                    for(RequiredDocument__mdt rqD: lstReqDocs) {
                        System.debug(loggingLevel.Error, '*** Documento: ' + rqD.RelatedDocumentType__r.DigitizationID__c);
                        if(!setDocs.contains(rqD.RelatedDocumentType__r.DigitizationID__c)) {
                            System.debug(loggingLevel.Error, '*** 10:');
                            blnDocComplete = false;
                            break;
                        }
                    }
                }
            }
        }
        System.debug(loggingLevel.Error, '*** Resultado '+blnDocComplete);
        return blnDocComplete;
    }

    /*
        Método para la asignación de tipo de registro con base al tipo.
    */

    public static void assingRecorType ( Case procedureRecordType) {

        String stgProcedureType = procedureRecordType.idServiceType__c;
        Map<String, Map<String, RecordType>> mapRecordTypes = new Map<String, Map<String, RecordType>>();
        set<String> setNames = new set<string>();
        mapRecordTypes = getRecordTypes('DeveloperName');
        if(stgProcedureType == '1' || stgProcedureType == '2') {
            if(mapRecordTypes.get('Case').containsKey('affiliation')) {
                String stgcomplainRT = mapRecordTypes.get('Case').get('affiliation').Id;
                procedureRecordType.RecordTypeId = stgcomplainRT;
            }
        }else if (stgProcedureType == '4') {
            if(mapRecordTypes.get('Case').containsKey('AgentPromotionVerification')) {
                String stgcomplainRT = mapRecordTypes.get('Case').get('AgentPromotionVerification').Id;
                procedureRecordType.RecordTypeId = stgcomplainRT;
            }
        }else if (stgProcedureType == '46' || stgProcedureType == '47') {
            if(mapRecordTypes.get('Case').containsKey('editData')) {
                String stgcomplainRT = mapRecordTypes.get('Case').get('editData').Id;
                procedureRecordType.RecordTypeId = stgcomplainRT;
            }
        }else if (stgProcedureType == '3') {
            if(mapRecordTypes.get('Case').containsKey('Recertification')) {
                String stgcomplainRT = mapRecordTypes.get('Case').get('Recertification').Id;
                procedureRecordType.RecordTypeId = stgcomplainRT;
            }
        }else if (stgProcedureType == '401' || stgProcedureType == '404' || stgProcedureType == '402' || stgProcedureType == '405' ) {
            if(mapRecordTypes.get('Case').containsKey('partialWithdrawal')) {
                String stgcomplainRT = mapRecordTypes.get('Case').get('partialWithdrawal').Id;
                procedureRecordType.RecordTypeId = stgcomplainRT;
            }
        }else if (stgProcedureType == '39') {
            if(mapRecordTypes.get('Case').containsKey('totalRetreats')) {
                String stgcomplainRT = mapRecordTypes.get('Case').get('totalRetreats').Id;
                procedureRecordType.RecordTypeId = stgcomplainRT;
            }
        }
        /*****Ajuste*****
        *  Desarrollador: Luis Enrique Garcia
        *  Fecha: 23/01/2017
        *  Ajuste: Se crearon mas validaciones 
        *          para los nuevos tipos de tramite
        */
        //INICIO de Ajuste
        else if (stgProcedureType == '59') {
            if(mapRecordTypes.get('Case').containsKey('SAR92')) {
                String stgcomplainRT = mapRecordTypes.get('Case').get('SAR92').Id;
                procedureRecordType.RecordTypeId = stgcomplainRT;
            }
        }else if (stgProcedureType == '60') {
            if(mapRecordTypes.get('Case').containsKey('SAR92ISSSTE')) {
                String stgcomplainRT = mapRecordTypes.get('Case').get('SAR92ISSSTE').Id;
                procedureRecordType.RecordTypeId = stgcomplainRT;
            }
        }else if (stgProcedureType == '41') {
            if(mapRecordTypes.get('Case').containsKey('PMGRetirosProgramados')) {
                String stgcomplainRT = mapRecordTypes.get('Case').get('PMGRetirosProgramados').Id;
                procedureRecordType.RecordTypeId = stgcomplainRT;
            }
        }else if (stgProcedureType == '997') {
            if(mapRecordTypes.get('Case').containsKey('RAV')) {
                String stgcomplainRT = mapRecordTypes.get('Case').get('RAV').Id;
                procedureRecordType.RecordTypeId = stgcomplainRT;
            }
        }else if (stgProcedureType == '017') {
            if(mapRecordTypes.get('Case').containsKey('op17')) {
                String stgcomplainRT = mapRecordTypes.get('Case').get('op17').Id;
                procedureRecordType.RecordTypeId = stgcomplainRT;
            }
        }
        //FIN de ajuste
        System.debug(loggingLevel.Error, '*** procedureRecordType.RecordTypeId: ' + procedureRecordType.RecordTypeId);
    }

    /*
        Método para la asignación de tipo de registro con base al tipo.
    */

    public static void assingNumberOfPrints ( Case procedureRecordType) {

        String stgProcedureType = procedureRecordType.idServiceType__c;
        Map<String, Decimal> mapFingersByProcedure = new Map<String, Decimal>();
        String strfinger = 'SELECT '+String.join(new List<String>(SObjectType.fingerByProcedure__c.Fields.getMap().keySet()), ', ')+ ' FROM fingerByProcedure__c';
        List<fingerByProcedure__c> lstFingers = Database.query(strfinger);
        for(fingerByProcedure__c iterator: lstFingers) {
            if(!mapFingersByProcedure.containsKey(iterator.Procedure__c)) {
               mapFingersByProcedure.put(iterator.Procedure__c, iterator.Prints__c); 
            }
        }

        if(mapFingersByProcedure.containsKey(stgProcedureType)) {
            procedureRecordType.NumberOfPrints__c = mapFingersByProcedure.get(stgProcedureType);         
        }    
    }

    /** Ordenar por la etiqueta un selectOption **/
    public static list<selectOption> selectOptionSortByLabel(list<selectOption>selectOptionsToSort) {
        if(selectOptionsToSort == null || selectOptionsToSort.size() <= 1){
            return selectOptionsToSort;
        }
        List<SelectOption> lessSelectOption = new List<SelectOption>();
        List<SelectOption> greaterSelectOption = new List<SelectOption>();
        integer pivot = selectOptionsToSort.size() / 2;
        
        SelectOption pivotValue = selectOptionsToSort[pivot];
        selectOptionsToSort.remove(pivot);
        for(selectOption SO : selectOptionsToSort){
            if(SO.getValue() <= pivotValue.getValue()){
                lessSelectOption.add(SO);
            }else if(SO.getValue() > pivotValue.getValue()){
                greaterSelectOption.add(SO);   
            }
        }
        list<selectOption> sortedSelectOptions = new list<selectOption>(); 
        sortedSelectOptions.addAll(selectOptionSortByLabel(lessSelectOption));
        sortedSelectOptions.add(pivotValue);
        sortedSelectOptions.addAll(selectOptionSortByLabel(greaterSelectOption));
        return SortedSelectOptions;
    }

    public static List<Document__c> documentSortByOrder(List<Document__c> lstToOrder){
        List<Document__c> lstDocumentsOrders = new List<Document__c>();
        return lstDocumentsOrders;
    }

}