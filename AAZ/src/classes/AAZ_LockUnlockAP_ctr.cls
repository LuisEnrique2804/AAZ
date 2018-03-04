public with sharing class AAZ_LockUnlockAP_ctr {

    public String stgNumAp     {get; set;}
    public String stgNumEmpAp  {get; set;}
    public String stgNssWorker {get; set;}
    public String            stgFolio               {set;get;}
    public String            stgCurp                {set;get;}
    public String            stgName                {set;get;}
    public String            stgNss                 {set;get;}
    public Boolean           blnIsItValidToStart    {set;get;}
    public Account           relatedWorker          {set;get;}
    public Contact           relatedAgent           {set;get;}
    public Case              caseInstance           {set;get;}
    public Id                lastInteractionCreated {set;get;}
    public Case              caseToCatchQuery       {set;get;}
    public List<Document__c> lstcurrentDocs         {set;get;}
    public String            stgComplain            {set;get;}
    public Boolean           blnListNotEmpty        {set;get;}
    public String            strInsertSelected      {set;get;}
    public List<String>      lstSuccessMsgs         {set;get;}
    public List<String>      lstErrorMsgs           {set;get;}
    public Boolean           blnAgenLockUnlock      {set;get;}
    public Boolean           isItValidToStart       {set;get;}
    public String            strAPLock              {set;get;}
    public Case              currentCase = new case();
    public Case              currentProcedure = new Case();
    public Boolean           blnServiceHadError = false;
    public Boolean           blnServiceHadError2 = false;
    public string            stgMessage = '';
    public String            stgtype = Label.AAZ_InsertComplaint_001;
    public id                idCurrentCase;
    public id                idCurrentId = UserInfo.getUserId();
    private final String strNotValidInputs1 = 'Favor de llenar el campo: Queja';

    public AAZ_LockUnlockAP_ctr(ApexPages.StandardController stdController) {
        cleanUpMsgs();
        blnListNotEmpty = false;
        startValues();
    }

    /*
        Método para inicializar las variables 
    */
    public void startValues() {
        stgNumAp     = '';
        stgNumEmpAp  = '';
        stgNssWorker = '';
    }

    /*
        Metodo para realizar la busqueda del tramite, Trabajador y Agente Promotor
    */

    public void searchCaseContAcc(){
        blnServiceHadError2 = false;
        blnIsItValidToStart = false;
        String strQueryOverCaseStatement = '';
        caseToCatchQuery = new Case();
        blnListNotEmpty = false;
        if(stgNssWorker != '' || !String.isBlank(stgNssWorker)) {
            strQueryOverCaseStatement = 'SELECT '+String.join(new List<String>(SObjectType.Case.Fields.getMap().keySet()), ', ')+', Account.NSS__c FROM Case WHERE Account.NSS__c = \''+stgNssWorker+'\' limit 1';
        }else if(stgNumEmpAp != '' || !String.isBlank(stgNumEmpAp)) {
            strQueryOverCaseStatement = 'SELECT '+String.join(new List<String>(SObjectType.Case.Fields.getMap().keySet()), ', ')+', Contact.PromoterAgentNumber__c FROM Case WHERE Contact.PromoterAgentNumber__c = \''+stgNumAp+'\' limit 1';
        }else if(stgNssWorker != '' || !String.isBlank(stgNssWorker)) {
            strQueryOverCaseStatement = 'SELECT '+String.join(new List<String>(SObjectType.Case.Fields.getMap().keySet()), ', ')+', Contact.EmployeeNumber__c FROM Case WHERE Contact.EmployeeNumber__c = \''+stgNumEmpAp+'\' limit 1';
        }
        System.debug(loggingLevel.Error, '*** blnServiceHadError2: ' + blnServiceHadError2);
        if(strQueryOverCaseStatement != '' || !String.isBlank(strQueryOverCaseStatement)) {
            //caseToCatchQuery = Database.query(strQueryOverCaseStatement);
            try{
                caseToCatchQuery = Database.query(strQueryOverCaseStatement);
                System.debug(loggingLevel.Error, '***Entro a try***');
            }catch(QueryException qE){
                blnServiceHadError2 = true;
                stgMessage = qE.getMessage();
                System.debug(loggingLevel.Error, '*** stgMessage: ' + stgMessage);
                System.debug(loggingLevel.Error, '***Entro a 1***');
            }catch(Exception gE){
                blnServiceHadError2 = true; 
                stgMessage = gE.getMessage();
                System.debug(loggingLevel.Error, '***Entro a 2***');
            }

            if(blnServiceHadError2) {
                System.debug(loggingLevel.Error, '***Entro***');
                //AAZ_Utils_cls.insertIncidence(stgMessage,stgtype,idCurrentCase,idCurrentId);
            }
        }
        if(blnServiceHadError2) {
            try{
                //caseToCatchQuery=AAZ_CaseQueryWS_cls.getCaseDetails(stgFolio); 
                System.debug(loggingLevel.Error, '***Entro a try.1***');
            }catch(CalloutException qE){
                blnServiceHadError2 = true;
                stgMessage = qE.getMessage();
                System.debug(loggingLevel.Error, '***Entro a 0.1***');
            }catch(UnexpectedException uE){
                blnServiceHadError2 = true; 
                stgMessage = uE.getMessage();
                System.debug(loggingLevel.Error, '***Entro a 1.1***');
            }catch(Exception gE){
                blnServiceHadError2 = true;
                stgMessage = gE.getMessage();
                System.debug(loggingLevel.Error, '***Entro a 2.1***');
            }

            if(blnServiceHadError2) {
                System.debug(loggingLevel.Error, '***Entro2***');
                //AAZ_Utils_cls.insertIncidence(stgMessage,stgtype,idCurrentCase,idCurrentId);
            }
        }
        System.debug(loggingLevel.Error, '*** blnServiceHadError2: ' + blnServiceHadError2);
        System.debug(loggingLevel.Error, '*** caseToCatchQuery.id: ' + caseToCatchQuery.id);
        if(caseToCatchQuery.id != null) {
            try {currentCase = [SELECT SubSubType__c,SubType__c,Type FROM Case WHERE Id =:caseToCatchQuery.id limit 1];} catch(QueryException qE){blnServiceHadError2 = true;stgMessage = qE.getMessage();}catch(Exception gE){blnServiceHadError2 = true; stgMessage = gE.getMessage();}
            blnListNotEmpty = true;
            if(caseToCatchQuery.Id != null){
                blnIsItValidToStart = true;
            }
            if(blnServiceHadError2) {
                System.debug(loggingLevel.Error, '***Entro3***');
                //AAZ_Utils_cls.insertIncidence(stgMessage,stgtype,idCurrentCase,idCurrentId);
            }
        }
        System.debug(loggingLevel.Error, '*** blnServiceHadError2: ' + blnServiceHadError2);
        
        if(blnIsItValidToStart) {
            blnListNotEmpty = true;
            searchCase();
            searchCont();
            searchAcc();
        } else {
            blnIsItValidToStart = false;
        }
        stgNumAp     = '';
        stgNumEmpAp  = '';
        stgNssWorker = '';
        stgComplain = '';
    }

    public List<Schema.FieldSetMember> getFieldSetFieldsCase(){
        blnServiceHadError = false;
        List<Schema.FieldSetMember> lstFieldSetMemberCase = new List<Schema.FieldSetMember>();
        try {lstFieldSetMemberCase = AAZ_Utils_cls.getFieldSetMembers('Case', String.valueOf(currentCase.Type), String.valueOf(currentCase.SubType__c), String.valueOf(currentCase.SubSubType__c));} catch(NullpointerException nE) {blnServiceHadError = true;stgMessage = nE.getMessage();}catch(UnexpectedException uE) {blnServiceHadError = true;stgMessage = uE.getMessage();}catch(Exception e) {blnServiceHadError = true;stgMessage = e.getMessage();}
        if(blnServiceHadError) {
            //AAZ_Utils_cls.insertIncidence(stgMessage,stgtype,idCurrentCase,idCurrentId);
        }
        return lstFieldSetMemberCase;
    }

    public List<Schema.FieldSetMember> getFieldSetFieldsAcc(){
        blnServiceHadError = false;
        List<Schema.FieldSetMember> lstFieldSetMemberAcc = new List<Schema.FieldSetMember>();
        try {lstFieldSetMemberAcc = AAZ_Utils_cls.getFieldSetMembers('Account', String.valueOf(currentCase.Type), String.valueOf(currentCase.SubType__c), String.valueOf(currentCase.SubSubType__c));} catch(NullpointerException nE) {blnServiceHadError = true;stgMessage = nE.getMessage();}catch(UnexpectedException uE) {blnServiceHadError = true;stgMessage = uE.getMessage();}catch(Exception e) {blnServiceHadError = true;stgMessage = e.getMessage();}
        if(blnServiceHadError) {
            //AAZ_Utils_cls.insertIncidence(stgMessage,stgtype,idCurrentCase,idCurrentId);
        }
        return lstFieldSetMemberAcc;
    }

    public List<Schema.FieldSetMember> getFieldSetFieldsCont(){
        blnServiceHadError = false;
        List<Schema.FieldSetMember> lstFieldSetMemberCont = new List<Schema.FieldSetMember>();
        try {lstFieldSetMemberCont = AAZ_Utils_cls.getFieldSetMembers('Contact', String.valueOf(currentCase.Type), String.valueOf(currentCase.SubType__c), String.valueOf(currentCase.SubSubType__c));} catch(NullpointerException nE) {blnServiceHadError = true;stgMessage = nE.getMessage();}catch(UnexpectedException uE) {blnServiceHadError = true;stgMessage = uE.getMessage();}catch(Exception e) {blnServiceHadError = true;stgMessage = e.getMessage();}
        if(blnServiceHadError) {
            //AAZ_Utils_cls.insertIncidence(stgMessage,stgtype,idCurrentCase,idCurrentId);
        }
        return lstFieldSetMemberCont;
    }

    public void cleanUpMsgs()
    {
        lstSuccessMsgs = new List<String>();
        lstErrorMsgs = new List<String>();
    }

    public Boolean validateInputs()
    {
        Boolean blnEverythingWentFine = true;
        System.debug(loggingLevel.Error, '*** stgComplain: ' + stgComplain);
        if(String.isBlank(stgComplain) || stgComplain == '')
        {
            System.debug(loggingLevel.Error, '*** entro: ');
            blnEverythingWentFine = false;
            lstErrorMsgs.add(strNotValidInputs1);
            System.debug(loggingLevel.Error, '*** lstErrorMsgs: ' + lstErrorMsgs);
        }
        System.debug(loggingLevel.Error, '*** blnEverythingWentFine: ' + blnEverythingWentFine);
        return blnEverythingWentFine;
    }

    public void searchCase(){
        
        blnIsItValidToStart = false;
        Boolean blnServiceHadError = false;
        string stgMessage = '';
        String stgtype = 'Otro';
        id idCurrentCase;
        id idCurrentId = UserInfo.getUserId();
        String strQueryOverAccsStmnt = 'SELECT '+String.join(new List<String>(SObjectType.Case.Fields.getMap().keySet()),', ')+', Parent.caseNumber, Account.PaternalLastName__c, Account.MaternalLastName__c FROM Case WHERE id = \''+caseToCatchQuery.id+'\' limit 1';
        try{caseInstance = Database.query(strQueryOverAccsStmnt);}catch(QueryException qE){blnServiceHadError = true; stgMessage = qE.getMessage();}catch(Exception gE){blnServiceHadError = true; stgMessage = gE.getMessage();}
        if(blnServiceHadError == true) {
            //AAZ_Utils_cls.insertIncidence(stgMessage,stgtype,idCurrentCase,idCurrentId);
        }
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
        if(caseToCatchQuery.Id != null){
            if(caseToCatchQuery.AccountId != null){
                relatedWorker = new Account();
                String strQueryOverAccsStmnt = 'SELECT '+String.join(new List<String>(SObjectType.Account.Fields.getMap().keySet()),', ')+' FROM Account WHERE Id = \''+caseToCatchQuery.AccountId+'\' limit 1';
                try{relatedWorker = Database.query(strQueryOverAccsStmnt);}catch(QueryException qE){blnServiceHadError = true; stgMessage = qE.getMessage();}catch(Exception gE){blnServiceHadError = true; stgMessage = gE.getMessage();}
                if(blnServiceHadError == true) {
                    //AAZ_Utils_cls.insertIncidence(stgMessage,stgtype,idCurrentCase,idCurrentId);
                }
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
        if(caseToCatchQuery.Id != null){
            if(caseToCatchQuery.ContactId != null){
                relatedAgent = new Contact();
                String strQueryOverContactStmnt = 'SELECT '+String.join(new List<String>(SObjectType.Contact.Fields.getMap().keySet()),', ')+' FROM Contact WHERE Id = \''+caseToCatchQuery.ContactId+'\' limit 1';
                try{relatedAgent = Database.query(strQueryOverContactStmnt);}catch(QueryException qE){blnServiceHadError = true; stgMessage = qE.getMessage();}catch(Exception gE){blnServiceHadError = true; stgMessage = gE.getMessage();}
                if(blnServiceHadError == true) {
                    //AAZ_Utils_cls.insertIncidence(stgMessage,stgtype,idCurrentCase,idCurrentId);
                }
                if(relatedAgent.Id != null){
                    blnIsItValidToStart = true;
                }    
            }
        }
    }

    public void LockUnlock(){
        System.debug(' \n\n blnAgenLockUnlock = '+ blnAgenLockUnlock +' \n\n');
        blnAgenLockUnlock = false;
        isItValidToStart = false;
        Boolean blnServiceHadError = false;
        string stgMessage = '';
        String stgtype = 'Otro';
        id idCurrentCase;
        id idCurrentId = UserInfo.getUserId();
        Contact currentCase = new Contact();
        List<Contact> lstContact = new List<Contact>{relatedAgent};
        relatedAgent.BlockReasons__c = stgComplain;
        try{currentCase = AAZ_LockUnLockAgent_cls.getLockUnlockAPList(lstContact ,new Map<String,Object>());}catch(CalloutException qE){blnServiceHadError = true;stgMessage = qE.getMessage();}catch(UnexpectedException uE){blnServiceHadError = true; stgMessage = uE.getMessage();}catch(Exception gE){blnServiceHadError = true;stgMessage = gE.getMessage();}
        if(blnServiceHadError) {
            //AAZ_Utils_cls.insertIncidence(stgMessage,stgtype,idCurrentCase,idCurrentId);
        }
        if(currentCase.Status__c != null || !String.isBlank(currentCase.Status__c)) {
            relatedAgent.Status__c = currentCase.Status__c;
            Database.SaveResult sr = Database.update(relatedAgent, true);
            if(sr.isSuccess()) {
                blnAgenLockUnlock = true;
                strAPLock = relatedAgent.Status__c;
            }else{
                stgMessage = String.valueOf(sr.getErrors());
                //AAZ_Utils_cls.insertIncidence(stgMessage,stgtype,idCurrentCase,idCurrentId);
            }
            System.debug(loggingLevel.Error, '*** blnAgenLockUnlock: ' + blnAgenLockUnlock);
            isItValidToStart = true;
        }
    }
}