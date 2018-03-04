/****************************************************************************************
    Desarrollado por:  Avanxo México
    Autor:             Luis Enrique Garcia Sanabria
    Proyecto:          Mesa de Control Afore
    Descripción:       Clase de APEX que realiza la función de controlador perzonalizado
    para la página de visualForce AAZ_InsertComplaint_ctr en la que se realizan la busqueda
    de un tramite(Case), el trabajador(Account) y el agente promotor(Trabajador) asociado
    al mismo, ya sea en SFDC o realizando la consulta del servicio de consulta del tramite (SW0011)

    Cambios (Versiones)
    -------------------------------------
      No.      Fecha                  Autor                      Descripción
    ------  -------------  ------------------------------   ----------------------
     0.1     22-07-2017    Luis Enrique Garcia Sanabria     Creacion
     0.2     22-07-2017    Luis Enrique Garcia Sanabria     Construcción
     1.0     25-07-2017    Luis Enrique Garcia Sanabria     Finalización y documentación
     1.1     09-08-2017    Luis Enrique Garcia Sanabria     Ajustes
****************************************************************************************/

public class AAZ_InsertComplaint_ctr {
    public String            stgFolio               {set;get;}
    public Boolean           blnIsItValidToStart    {set;get;}
    public Account           relatedWorker          {set;get;}
    public Contact           relatedAgent           {set;get;}
    public Case              caseInstance           {set;get;}
    public Id                lastInteractionCreated {set;get;}
    public Boolean           blnIsInteractionCreated{set;get;}
    public String            strCaseNumber          {set;get;}
    public Boolean           blnMessasgeComplain    {set;get;}
    public List<Case>        caseToCatchQuery       {set;get;}
    public List<Document__c> lstcurrentDocs         {set;get;}
    public String            stgNss                 {set;get;}
    public String            stgCurp                {set;get;}
    public String            stgName                {set;get;}
    public String            stgFatherLastName      {set;get;}
    public String            stgMathernalName       {set;get;}

    public String            stgNss2                {set;get;}
    public String            stgCurp2               {set;get;}
    public String            stgName2               {set;get;}
    public String            stgFatherLastName2     {set;get;}
    public String            stgMathernalName2      {set;get;}

    public String            stgComplain            {set;get;}
    public Boolean           blnListNotEmpty        {set;get;}
    public String            strInsertSelected      {set;get;}
    public List<String>      lstSuccessMsgs         {set;get;}
    public List<String>      lstErrorMsgs           {set;get;}
    public string            stgOrigin              {set;get;}
    public Date              dateComplain           {set;get;}
    public Date              dateCaptureComplain    {set;get;}
    public string            stgPhoneWorker         {set;get;}
    public string            stgEmail               {set;get;}
    public string            stgStreet              {set;get;}
    public String            stgInternalNumber      {set;get;}
    public String            stgExternalNumber      {set;get;}
    public string            stgDelegation          {set;get;}
    public string            stgState               {set;get;}
    public string            stgCountry             {set;get;}
    public Integer           stgAforeNumber         {set;get;}
    public string            stgAforeToPass         {set;get;}
    public Case              objCaseQ               {set;get;}
    public Case              currentCase            = new case();
    public Case              currentProcedure       = new Case();
    public Boolean           blnServiceHadError     = false;
    public Boolean           blnServiceHadError2    = false;
    public Boolean           blnSearchWasNotOK      {set;get;}
    public Boolean           blnServiceShowPanel    {set;get;}
    public Boolean           blnServiceShowPanel2   {set;get;}
    public Boolean           blnShowBusqueda        {set;get;}
    public string            stgMessage             = '';
    public String            stgtype                = Label.AAZ_InsertComplaint_001;
    public id                idCurrentId            = UserInfo.getUserId();
    private final String strNotValidInputs1         = 'Favor de llenar el campo: Queja';
    private final String strNotValidInputs2         = 'Favor de llenar un solo campo de busqueda';
    private final String strNssValidate             = 'Favor de escribir solo números y/o los 11 números del seguro social';
    private final String strCurpValidate            = 'Favor de escribir solo los 18 digitos de la CURP';
    public id                idCurrentCase;
    public String            strOptionSelected      {set;get;}
    public Boolean           blnIsUpdateComplain    {set;get;}

    /*
        Constructor
    */

    public AAZ_InsertComplaint_ctr(ApexPages.StandardController stdCtl) {
        blnShowBusqueda= true;
        blnServiceShowPanel= false;
        blnServiceShowPanel2=false;
        cleanUpMsgs();
        blnListNotEmpty = false;
        initValues();
        strOptionSelected = '';

    }

    /*
        Metodo que restablece los valores
    */

    public void initValues(){

        /***Revisión René  "Quitar comentarios de código" ****/
        blnIsItValidToStart = false;
        blnServiceHadError2 = false;
        blnListNotEmpty     = false;
        blnIsUpdateComplain = false;
        blnSearchWasNotOK   = false;
        stgNss              = '';
        stgCurp             = '';
        stgName             = '';
        stgComplain         = '';
        strInsertSelected   = 'Queja';
    }


    /*
        Metodo para realizar la busqueda del tramite, Trabajador y Agente Promotor
    */

    public PageReference searchCaseContAcc(){
        blnSearchWasNotOK = false;
        blnServiceHadError2 = false;
        blnIsItValidToStart = false;
        String strQueryOverCaseStatement = '';
        caseToCatchQuery = new List<Case>();
        blnListNotEmpty = false;
        cleanUpMsgs();

        if(!String.isBlank(stgNss)) {
            if(!String.isBlank(stgNss) && String.isBlank(stgCurp) && String.isBlank(stgName) && String.isBlank(stgFatherLastName) && String.isBlank(stgMathernalName)) {
                if(checkValidate(stgNss)) {
                    if(stgNss.length()==11){
                        strQueryOverCaseStatement = 'SELECT '+String.join(new List<String>(SObjectType.Case.Fields.getMap().keySet()), ', ')+', Account.NSS__c, RecordType.DeveloperName ';
                        strQueryOverCaseStatement+=' FROM Case WHERE Account.NSS__c = \''+stgNss+'\' ';
                        strQueryOverCaseStatement+= 'AND RecordType.DeveloperName = \''+'affiliation'+'\' limit 1';
                        //strQueryOverCaseStatement+=' limit 1 ';
                    }else{
                        lstErrorMsgs.add('Favor de llenar el campo NSS con 11 digitos');
                    }

                } else {
                    lstErrorMsgs.add('Favor de llenar el campo NSS solo con digitos');
                }
            }
        }else if(!String.isBlank(stgCurp)) {
            if(String.isBlank(stgNss) && !String.isBlank(stgCurp) && String.isBlank(stgName) && String.isBlank(stgFatherLastName) && String.isBlank(stgMathernalName)){
                if(stgCurp.length()==18) {
                    strQueryOverCaseStatement = 'SELECT '+String.join(new List<String>(SObjectType.Case.Fields.getMap().keySet()), ', ')+', Account.CURP__c ';
                    strQueryOverCaseStatement+= ' FROM Case WHERE Account.CURP__c = \''+stgCurp+'\'';
                    strQueryOverCaseStatement+= ' AND RecordType.DeveloperName = \''+'affiliation'+'\' limit 1';
                    //strQueryOverCaseStatement+= ' limit 1';
                    }else{
                                    lstErrorMsgs.add('Favor de llenar el campo CURP con 18 carácteres');
                                }

            }
        }else if(!String.isBlank(stgName)) {
                if(!String.isBlank(stgFatherLastName)){
                    if(String.isBlank(stgNss) && String.isBlank(stgCurp) && !String.isBlank(stgName) && !String.isBlank(stgFatherLastName) ) {
                    strQueryOverCaseStatement = 'SELECT '+String.join(new List<String>(SObjectType.Case.Fields.getMap().keySet()), ', ')+', Account.Name ';
                    strQueryOverCaseStatement+= ' FROM Case WHERE Account.Name LIKE  \''+'%'+stgName+'%'+'\' '+' AND Account.PaternalLastName__c LIKE \''+'%'+stgFatherLastName+'%'+'\'';
                    strQueryOverCaseStatement+= 'AND RecordType.DeveloperName = \''+'affiliation'+'\' limit 1';
                    //strQueryOverCaseStatement+= ' limit 1';
            }
            }else {
                lstErrorMsgs.add('Favor de llenar el campo de apellido paterno para completar la búsqueda por Nombre');
                }

        } else {
            lstErrorMsgs.add('Favor de llenar al menos un campo para realizar la búsqueda');
        }
        if(strQueryOverCaseStatement != '') {
            if(!String.isBlank(strQueryOverCaseStatement)) {
                try{caseToCatchQuery = Database.query(strQueryOverCaseStatement);}catch(QueryException qE){blnServiceHadError2 = true;stgMessage = qE.getMessage();}catch(Exception gE){blnServiceHadError2 = true;stgMessage = gE.getMessage(); }
                System.debug(loggingLevel.Error, '*** strQueryOverCaseStatement: ' + strQueryOverCaseStatement);
                //System.debug(loggingLevel.Error, '*** caseToCatchQuery: ' + caseToCatchQuery[0].ContactId);
                //try{caseToCatchQuery=AAZ_CaseQueryWS_cls.getCaseDetails(stgNss,stgCurp,stgName,stgFatherLastName,stgMathernalName);}catch(CalloutException qE){blnServiceHadError2 = true; stgMessage = qE.getMessage();}catch(UnexpectedException uE){blnServiceHadError2 = true;stgMessage = uE.getMessage();}catch(Exception gE){blnServiceHadError2 = true;stgMessage = gE.getMessage();}
            }
        }
        if(caseToCatchQuery.isEmpty()) {
            blnSearchWasNotOK = true;
            blnServiceShowPanel2 =true;
            blnMessasgeComplain = true;
            lstErrorMsgs.add('No se encontró ningún tramite asociado a esta búsqueda, Favor de verificarlo.');
            lstErrorMsgs.add('Usted solo puede buscar por un filtro a su vez, NNS o CURP o Nombre más apellido paterno más apellido materno.');
        }

        if(!caseToCatchQuery.isEmpty()) {
            if(caseToCatchQuery[0].id != null) {
                try {currentCase = [SELECT SubSubType__c,SubType__c,Type FROM Case WHERE Id =:caseToCatchQuery[0].id limit 1];} catch(QueryException qE){blnServiceHadError2 = true;stgMessage = qE.getMessage();}catch(Exception gE){blnServiceHadError2 = true; stgMessage = gE.getMessage();}
                blnListNotEmpty = true;
                if(caseToCatchQuery[0].Id != null){
                    blnIsItValidToStart = true;
                }
            }
        }

        if(blnIsItValidToStart) {
            blnShowBusqueda=false;
            blnServiceShowPanel=true;
            blnListNotEmpty = true;
            searchCase();
            searchCont();
            searchAcc();
        } else {
            blnIsItValidToStart = false;
            blnShowBusqueda=false;
        }
        return null;
    }


    public boolean checkValidate(String Nss){
        Pattern MyPattern = Pattern.compile('^[0-9]*$');
        Matcher MyMatcher = MyPattern.matcher(Nss);
        System.debug(loggingLevel.Error, '*** MyMatcher.matches(): ' + MyMatcher.matches());
        return MyMatcher.matches();
    }

    public List<Schema.FieldSetMember> getFieldSetFieldsCase(){
        blnServiceHadError = false;
        List<Schema.FieldSetMember> lstFieldSetMemberCase = new List<Schema.FieldSetMember>();
        try {lstFieldSetMemberCase = AAZ_Utils_cls.getFieldSetMembers('Case', String.valueOf(currentCase.Type), String.valueOf(currentCase.SubType__c), String.valueOf(currentCase.SubSubType__c));} catch(NullpointerException nE) {blnServiceHadError = true;stgMessage = nE.getMessage();}catch(UnexpectedException uE) {blnServiceHadError = true;stgMessage = uE.getMessage();}catch(Exception e) {blnServiceHadError = true;stgMessage = e.getMessage();}
        //if(blnServiceHadError) {
        //    AAZ_Utils_cls.insertIncidence(stgMessage,stgtype,idCurrentCase,idCurrentId);
        //}
        return lstFieldSetMemberCase;
    }

    public List<Schema.FieldSetMember> getFieldSetFieldsAcc(){
        blnServiceHadError = false;
        List<Schema.FieldSetMember> lstFieldSetMemberAcc = new List<Schema.FieldSetMember>();
        try {lstFieldSetMemberAcc = AAZ_Utils_cls.getFieldSetMembers('Account', String.valueOf(currentCase.Type), String.valueOf(currentCase.SubType__c), String.valueOf(currentCase.SubSubType__c));} catch(NullpointerException nE) {blnServiceHadError = true;stgMessage = nE.getMessage();}catch(UnexpectedException uE) {blnServiceHadError = true;stgMessage = uE.getMessage();}catch(Exception e) {blnServiceHadError = true;stgMessage = e.getMessage();}
        //if(blnServiceHadError) {
        //    AAZ_Utils_cls.insertIncidence(stgMessage,stgtype,idCurrentCase,idCurrentId);
        //}
        return lstFieldSetMemberAcc;
    }

    public List<Schema.FieldSetMember> getFieldSetFieldsCont(){
        blnServiceHadError = false;
        List<Schema.FieldSetMember> lstFieldSetMemberCont = new List<Schema.FieldSetMember>();
        try {lstFieldSetMemberCont = AAZ_Utils_cls.getFieldSetMembers('Contact', String.valueOf(currentCase.Type), String.valueOf(currentCase.SubType__c), String.valueOf(currentCase.SubSubType__c));} catch(NullpointerException nE) {blnServiceHadError = true;stgMessage = nE.getMessage();}catch(UnexpectedException uE) {blnServiceHadError = true;stgMessage = uE.getMessage();}catch(Exception e) {blnServiceHadError = true;stgMessage = e.getMessage();}
        //if(blnServiceHadError) {
        //    AAZ_Utils_cls.insertIncidence(stgMessage,stgtype,idCurrentCase,idCurrentId);
        //}
        return lstFieldSetMemberCont;
    }

    /*
        Metodo que registra un caso de tipo queja.
    */

    public void newCase(){
        blnServiceHadError = false;
        blnIsInteractionCreated = false;
        Boolean blnSuccesfulProcess = false;
        Map<String,Map<String,RecordType>> mapRTsByDevName = AAZ_Utils_cls.getRecordTypes('DeveloperName');
        String stgcomplainRT = mapRTsByDevName.get('Case').get('Complain').Id;
        Id stgOwnerId = null;
        cleanUpMsgs();
        try {
            stgOwnerId = [SELECT Id FROM Group WHERE DeveloperName = 'consultant'].Id;
        } catch(QueryException qE){blnServiceHadError = true;stgMessage = qE.getMessage();}catch(Exception gE){blnServiceHadError = true; stgMessage = gE.getMessage();}

        if(stgOwnerId != null) {

            if(strInsertSelected == 'Queja') {
                objCaseQ = new case(
                    RecordTypeId       = stgcomplainRT,
                    Priority           = 'Media',
                    AccountId          = caseToCatchQuery[0].AccountId,
                    ComplainContact__c = caseToCatchQuery[0].ContactId,
                    ParentId           = caseToCatchQuery[0].Id,
                    OwnerId            = stgOwnerId,
                    NewNSS__c          = stgNss
                );
            }else if (strInsertSelected == 'Traspaso Indebido') {
                objCaseQ = new case(
                    RecordTypeId       = stgcomplainRT,
                    Priority           = 'Media',
                    AccountId          = caseToCatchQuery[0].AccountId,
                    insertTI__c        = caseToCatchQuery[0].ContactId,
                    ParentId           = caseToCatchQuery[0].Id,
                    OwnerId            = stgOwnerId,
                    NewNSS__c          = stgNss
                );
            }
            SavePoint sp = Database.setSavePoint();

            Database.SaveResult sr = Database.Insert(objCaseQ,false);
            if(sr.isSuccess()) {
                strCaseNumber = objCaseQ.CaseNumber;
                lastInteractionCreated = objCaseQ.Id;
                blnIsInteractionCreated = true;
                Casecomment ojbCaseComm = new Casecomment (
                    ParentId = objCaseQ.Id,
                    CommentBody = stgComplain
                );
                Database.SaveResult sr1 = Database.Insert(ojbCaseComm,false);
                if(sr1.isSuccess()) {
                    blnSuccesfulProcess = true;
                }
                else {
                    stgMessage = sr1.getErrors()[0].getMessage();
                }
            }
            else {
                stgMessage = sr.getErrors()[0].getMessage();
            }
        }
        stgComplain = '';

    }

    /*
        Método para poner un caso en pendiente
    */

    public PageReference procedurePending(){
        blnServiceHadError = false;
        blnIsInteractionCreated = false;
        Boolean blnSuccesfulProcess = false;
        Case objCaseQ ;
        Map<String,Map<String,RecordType>> mapRTsByDevName = AAZ_Utils_cls.getRecordTypes('DeveloperName');
        String stgcomplainRT = mapRTsByDevName.get('Case').get('Complain').Id;
        Id stgOwnerId = null;
        cleanUpMsgs();
        System.debug(loggingLevel.Error, '*** 1: ');
        if(!blnSearchWasNotOK) {
            if(checkValidate(stgPhoneWorker) && checkValidate(stgInternalNumber) && checkValidate(stgExternalNumber)) {
                System.debug(loggingLevel.Error, '*** 2: ');
                try {stgOwnerId = [SELECT Id FROM Group WHERE DeveloperName = 'consultant'].Id;} catch(QueryException qE){blnServiceHadError = true;stgMessage = qE.getMessage();}catch(Exception gE){blnServiceHadError = true; stgMessage = gE.getMessage();}
                objCaseQ = new case(
                    RecordTypeId              = stgcomplainRT,
                    Priority                  = 'Media',
                    AccountId                 = caseToCatchQuery[0].AccountId,
                    complaintsAndTrades__c    = caseToCatchQuery[0].ContactId,
                    ParentId                  = caseToCatchQuery[0].Id,
                    OwnerId                   = stgOwnerId,
                    NewNSS__c                 = stgNss,
                    Origin                    = stgOrigin,
                    ComplainDate__c           = dateComplain,
                    Description               = stgComplain,
                    starDateComplain__c       = dateCaptureComplain,
                    WorkersPhone__c           = stgPhoneWorker,
                    SuppliedEmail             = stgEmail,
                    ComplainStreet__c         = stgStreet,
                    CompalinInternalNumber__c = Integer.valueOf(stgInternalNumber),
                    ComplainExternalNumber__c = Integer.valueOf(stgExternalNumber),
                    ComplainDelegation__c     = stgDelegation,
                    ComplainState__c          = stgState,
                    ComplainCountry__c        = stgCountry,
                    NumberAc__c               = stgAforeNumber,
                    AforeCedente__c           = stgAforeToPass
                );
                SavePoint sp = Database.setSavePoint();
                caseToCatchQuery[0].IsUpdateC__c = true;
                Schema.SObjectField f = Case.Fields.FolioNSS__c;
                Database.UpsertResult [] rS = Database.Upsert(caseToCatchQuery, f,false); //tramite
                Database.SaveResult sr = Database.Insert(objCaseQ,false); //queja

                if(sr.isSuccess()) {
                    strCaseNumber = objCaseQ.CaseNumber;
                    lastInteractionCreated = objCaseQ.Id;
                    blnIsInteractionCreated = true;
                    Casecomment ojbCaseComm = new Casecomment (
                        ParentId = objCaseQ.Id,
                        CommentBody = stgComplain
                    );
                    Database.SaveResult sr1 = Database.Insert(ojbCaseComm,false);
                    if(sr1.isSuccess()) {
                        blnSuccesfulProcess = true;
                    }
                    else {
                        stgMessage = sr1.getErrors()[0].getMessage();
                        Database.rollback(sp);
                    }
                }
            } else {
                System.debug(loggingLevel.Error, '*** 3: ');
                lstErrorMsgs.add('Test');
            }
        }
        else {
            try {stgOwnerId = [SELECT Id FROM Group WHERE DeveloperName = 'consultant'].Id;} catch(QueryException qE){blnServiceHadError = true;stgMessage = qE.getMessage();}catch(Exception gE){blnServiceHadError = true; stgMessage = gE.getMessage();}
            Map<String,Map<String,RecordType>> mapRTsByDevNameWithOutAP =  AAZ_Utils_cls.getRecordTypes('DeveloperName');

            Account accWOAP = new Account(
                NSS__c       = stgNss2,
                CURP__c      = stgCurp2,
                FirstName    = stgName2,
                LastName     = stgFatherLastName2+' '+stgMathernalName2,
                RecordTypeId = (mapRTsByDevNameWithOutAP.get('Account').containsKey('PersonAccount'))?mapRTsByDevNameWithOutAP.get('Account').get('PersonAccount').Id:null
            );


            Contact genericContact = new Contact(
                FirstName = 'Agente',
                LastName = 'Generico',
                Status__c = 'unlock',
                RecordTypeId = (mapRTsByDevNameWithOutAP.get('Contact').containsKey('AgentePromotor'))?mapRTsByDevNameWithOutAP.get('Contact').get('AgentePromotor').Id:null
            );

            Database.UpsertResult uR = Database.Upsert(accWOAP,false);
            Database.UpsertResult uRC = Database.Upsert(genericContact,false);

            objCaseQ = new case(
                RecordTypeId              = stgcomplainRT,
                AccountId                 = accWOAP.Id,
                complaintsAndTrades__c    = genericContact.Id,
                Priority                  = 'High',
                OwnerId                   = stgOwnerId,
                NewNSS__c                 = stgNss2,
                Origin                    = stgOrigin,
                ComplainDate__c           = dateComplain,
                starDateComplain__c       = dateCaptureComplain,
                Description               = stgComplain,
                WorkersPhone__c           = stgPhoneWorker,
                SuppliedEmail             = stgEmail,
                ComplainStreet__c         = stgStreet,
                CompalinInternalNumber__c = Integer.valueOf(stgInternalNumber),
                ComplainExternalNumber__c = Integer.valueOf(stgExternalNumber),
                ComplainDelegation__c     = stgDelegation,
                ComplainState__c          = stgState,
                ComplainCountry__c        = stgCountry,
                NumberAc__c               = stgAforeNumber,
                AforeCedente__c           = stgAforeToPass
            );
            SavePoint sp = Database.setSavePoint();
            Database.SaveResult[] rS = Database.Update(caseToCatchQuery,false);
            Database.SaveResult sr = Database.Insert(objCaseQ,false);

            if(sr.isSuccess()) {
                strCaseNumber = objCaseQ.CaseNumber;
                lastInteractionCreated = objCaseQ.Id;
                blnIsInteractionCreated = true;
                Casecomment ojbCaseComm = new Casecomment (
                    ParentId = objCaseQ.Id,
                    CommentBody = stgComplain
                );
                Database.SaveResult sr1 = Database.Insert(ojbCaseComm,false);
                if(sr1.isSuccess()) {
                    blnSuccesfulProcess = true;
                }
                else {
                    stgMessage = sr1.getErrors()[0].getMessage();
                    Database.rollback(sp);
                }
            }
        }
        stgComplain = '';

        return null;
    }



    public List<SelectOption> getInsertOptions(){
        return new List<SelectOption>{
            new SelectOption('Queja','Queja No Procedente'),
            new SelectOption('Traspaso Indebido','Traspaso Indebido')
        };
    }

    public void cleanUpMsgs()
    {
        lstSuccessMsgs = new List<String>();
        lstErrorMsgs = new List<String>();
    }


    public void searchCase(){

        blnIsItValidToStart = false;
        Boolean blnServiceHadError = false;
        string stgMessage = '';
        String stgtype = 'Otro';
        id idCurrentCase;
        id idCurrentId = UserInfo.getUserId();
        String strQueryOverAccsStmnt = 'SELECT '+String.join(new List<String>(SObjectType.Case.Fields.getMap().keySet()),', ')+', Parent.caseNumber, Account.PaternalLastName__c, Account.MaternalLastName__c FROM Case WHERE id = \''+caseToCatchQuery[0].id+'\' limit 1';
        try{caseInstance = Database.query(strQueryOverAccsStmnt);}catch(QueryException qE){blnServiceHadError = true; stgMessage = qE.getMessage();}catch(Exception gE){blnServiceHadError = true; stgMessage = gE.getMessage();}
        //if(blnServiceHadError == true) {
        //    AAZ_Utils_cls.insertIncidence(stgMessage,stgtype,idCurrentCase,idCurrentId);
        //}
        if(caseInstance.Id != null){
            blnIsItValidToStart = true;
        }
    }

    public void searchAcc(){
        blnIsItValidToStart = false;
        Boolean blnServiceHadError = false;
        string stgMessage = '';
        String stgtype = 'Otro';
        id idCurrentCase;
        id idCurrentId = UserInfo.getUserId();
        if(caseToCatchQuery[0].Id != null){
            if(caseToCatchQuery[0].AccountId != null){
                relatedWorker = new Account();
                String strQueryOverAccsStmnt = 'SELECT '+String.join(new List<String>(SObjectType.Account.Fields.getMap().keySet()),', ')+' FROM Account WHERE Id = \''+caseToCatchQuery[0].AccountId+'\' limit 1';
                try{relatedWorker = Database.query(strQueryOverAccsStmnt);}catch(QueryException qE){blnServiceHadError = true; stgMessage = qE.getMessage();}catch(Exception gE){blnServiceHadError = true; stgMessage = gE.getMessage();}
                //if(blnServiceHadError == true) {
                //    AAZ_Utils_cls.insertIncidence(stgMessage,stgtype,idCurrentCase,idCurrentId);
                //}
                if(relatedWorker.Id != null){
                    blnIsItValidToStart = true;
                }
            }
        }
    }

    public void searchCont(){
        blnIsItValidToStart = false;
        Boolean blnServiceHadError = false;
        string stgMessage = '';
        String stgtype = 'Otro';
        id idCurrentCase;
        id idCurrentId = UserInfo.getUserId();
        if(caseToCatchQuery[0].Id != null){
            if(caseToCatchQuery[0].ContactId != null){
                relatedAgent = new Contact();
                String strQueryOverContactStmnt = 'SELECT '+String.join(new List<String>(SObjectType.Contact.Fields.getMap().keySet()),', ')+' FROM Contact WHERE Id = \''+caseToCatchQuery[0].ContactId+'\' limit 1';
                try{relatedAgent = Database.query(strQueryOverContactStmnt);}catch(QueryException qE){blnServiceHadError = true; stgMessage = qE.getMessage();}catch(Exception gE){blnServiceHadError = true; stgMessage = gE.getMessage();}
                //if(blnServiceHadError == true) {
                //    AAZ_Utils_cls.insertIncidence(stgMessage,stgtype,idCurrentCase,idCurrentId);
                //}
                if(relatedAgent.Id != null){
                    blnIsItValidToStart = true;
                }
            }
        }
    }

    public void LockUnlockAP2(){
        //relatedAgent.isLock__c = true;
        blnMessasgeComplain = true;
        Boolean blnAgenLockUnlock = false;
        Boolean isItValidToStart = false;
        Contact currentCase = new Contact();
        Contact contactQuerry = new Contact();
        System.debug(loggingLevel.Error, '*** relatedAgent.Id: ' + relatedAgent.Id);
        String stgContactInfo = 'SELECT '+String.join(new List<String>(SObjectType.Contact.Fields.getMap().keySet()),', ')+' FROM Contact WHERE Id = \''+relatedAgent.Id+'\'Limit 1';
        System.debug(loggingLevel.Error, '*** stgContactInfo: ' + stgContactInfo);
        try {contactQuerry = Database.query(stgContactInfo);} catch(Exception e) {}
        List<Contact> lstContact = new List<Contact>{contactQuerry};
        try{currentCase = AAZ_LockUnLockAgent_cls.getLockUnlockAPList(lstContact ,new Map<String,Object>());}catch(CalloutException qE){blnServiceHadError = true;stgMessage = qE.getMessage();}catch(UnexpectedException uE){blnServiceHadError = true; stgMessage = uE.getMessage();}catch(Exception gE){blnServiceHadError = true;stgMessage = gE.getMessage();}

        if(currentCase.Status__c != null || !String.isBlank(currentCase.Status__c)) {
            relatedAgent.Status__c = currentCase.Status__c;
            Database.SaveResult sr = Database.update(relatedAgent, true);
            if(sr.isSuccess()) {
                blnAgenLockUnlock = true;
                blnMessasgeComplain = true;
                lstSuccessMsgs.add('Agente Bloqueado con exito');
            }
            isItValidToStart = true;
        }
        else{
            blnMessasgeComplain = true;
            lstErrorMsgs.add('El Agente no se pudo bloquear, favor de contactar a su administrador');
        }
    }
}