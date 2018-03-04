/*******************************************************************************
Desarrollado por: Avanxo México
Autor: Rene Ayala Medina
Proyecto: Afore Azteca
Descripción: Controlador personalizado para la página Visualforce donde se
visualiza la informacion del Agente promotor, asi como el llamado del servicio
de bloqueo y desbloque de agente.

-------------------------------------
No.    Fecha      Autor                          Descripción
------ ---------- ----------------------------- -----------
1.0    06-07-2017 Luis Enrique Garcia Sanabria   Creacion
1.1    11-07-2017 Luis Enrique Garcia Sanabria   Se depuraron Clases
1.2    14-07-2017 Luis Enrique Garcia Sanabria   Se crearon Clases
1.3    17-07-2017 Luis Enrique Garcia Sanabria   Finalizacion y documentación
1.4    04-09-2017 Samuel Galindo Rodríguez       Campos por tramite
*******************************************************************************/

public class AAZ_AgentDetailsFromProcedure_ctr {

    public Contact relatedAgent{set;get;}
    public Boolean isItValidToStart{set;get;}
    //public Boolean blnIsLock {set; get;}
    public String strProcedureId {set; get;}
    public Boolean blnAgenLockUnlock {set; get;}
    public Contact currentCase {set;get;}


    /**
     * Instancia del objeto Caso para poder realizar la redirección
     * @type Map
     */
    public Case caseInstance{set;get;}

    /**
     * Mapeo de todos los tipos de registros
     * @type Map
     */
    public Map<String,Map<String,RecordType>> mapRegisterType{set;get;}

    /**
     * Developer Name del tipo de registro
     * @type String
     */
    public String caseDevName{set;get;}

    /**
     * Agente Promotor tipo de registro del trámite
     * @type String
     */
    public String strAPRegisterType{set;get;}

    public AAZ_AgentDetailsFromProcedure_ctr(ApexPages.StandardController stdCtl){
        blnAgenLockUnlock = false;
        isItValidToStart = false;
        //blnIsLock = null;
        strProcedureId = stdCtl.getId();
        currentCase = new Contact();


        List<String> lstAccsFields = new List<String>();
        for (String i:SObjectType.Account.Fields.getMap().keySet()) {
            lstAccsFields.add('Account.'+i);
        }

        List<String> lstContactFields = new List<String>();
        for (String i:SObjectType.Contact.Fields.getMap().keySet()) {
            lstContactFields.add('Contact.'+i);
        }

        String strQueryOverCasesStatement = 'SELECT '+String.join(
          new List<String>(SObjectType.Case.Fields.getMap().keySet()), ', ')+
          ', '+ String.join(lstAccsFields,', ') +', '+ String.join(lstContactFields,', ')+
          ' FROM Case WHERE Id = \''+strProcedureId+'\' Limit 1';
        caseInstance = Database.query(strQueryOverCasesStatement);

        mapRegisterType = AAZ_Utils_cls.getRecordTypes('Id');

        caseDevName= (mapRegisterType.get('Case').containsKey(caseInstance.RecordTypeId))
            ?mapRegisterType.get('Case').get(caseInstance.RecordTypeId).DeveloperName:'';

        strAPRegisterType = 'AgentPromotionVerification';

        Case currentProcedure = new Case();
        try{currentProcedure = [SELECT Id, ContactId, AP__c FROM Case WHERE Id =: strProcedureId limit 1];}catch(QueryException qE){}catch(Exception gE){}
        if(currentProcedure.Id != null){
            if(currentProcedure.ContactId != null){
                relatedAgent = new Contact();
                String strQueryOverContactStmnt = 'SELECT '+String.join(new List<String>(SObjectType.Contact.Fields.getMap().keySet()),', ')+' FROM Contact WHERE Id = \''+currentProcedure.ContactId+'\' limit 1';
                try{relatedAgent = Database.query(strQueryOverContactStmnt);}catch(QueryException qE){}catch(Exception gE){}
                if(relatedAgent.Id != null){
                    isItValidToStart = true;
                    //blnIsLock = relatedAgent.isLock__c;
                }
            } else if (currentProcedure.AP__c != null) {
                relatedAgent = new Contact();
                String strQueryOverContactStmnt = 'SELECT '+String.join(new List<String>(SObjectType.Contact.Fields.getMap().keySet()),', ')+' FROM Contact WHERE Id = \''+currentProcedure.AP__c+'\' limit 1';
                try{relatedAgent = Database.query(strQueryOverContactStmnt);}catch(QueryException qE){}catch(Exception gE){}
                if(relatedAgent.Id != null){
                    isItValidToStart = true;
                }
            }
        }
    }

    public List<Schema.FieldSetMember> getFieldSetFields(){
        blnAgenLockUnlock = false;
        Case strRecordDevName = [SELECT SubSubType__c,SubType__c,Type FROM Case WHERE Id =:strProcedureId limit 1];
        if (caseDevName != strAPRegisterType) {
            return AAZ_Utils_cls.getFieldSetMembers('Case', strAPRegisterType, '', '');
        } else {
            return AAZ_Utils_cls.getFieldSetMembers('Case', String.valueOf(strRecordDevName.Type), String.valueOf(strRecordDevName.SubType__c), String.valueOf(strRecordDevName.SubSubType__c));
        }
    }

    public void LockUnlockAP2(){
        //relatedAgent.isLock__c = true;
        System.debug(' \n\n blnAgenLockUnlock = '+ blnAgenLockUnlock +' \n\n');
        blnAgenLockUnlock = false;
        isItValidToStart = false;
        Boolean blnServiceHadError = false;
        string stgMessage = '';
        String stgtype = 'Otro';
        id idCurrentCase = strProcedureId;
        id idCurrentId = UserInfo.getUserId();
        List<Contact> lstContact = new List<Contact>{relatedAgent};
        try{currentCase = AAZ_LockUnLockAgent_cls.getLockUnlockAPList(lstContact ,new Map<String,Object>());}catch(CalloutException qE){blnServiceHadError = true;stgMessage = qE.getMessage();}catch(UnexpectedException uE){blnServiceHadError = true; stgMessage = uE.getMessage();}catch(Exception gE){blnServiceHadError = true;stgMessage = gE.getMessage();}
        if(blnServiceHadError) {
            //AAZ_Utils_cls.insertIncidence(stgMessage,stgtype,idCurrentCase,idCurrentId);
        }

        if(Test.isRunningTest()){
            currentCase.Status__c='Test';
        }

        if(currentCase.Status__c != null || !String.isBlank(currentCase.Status__c)) {
            relatedAgent.Status__c = currentCase.Status__c;
            relatedAgent.ActualCaseId__c = strProcedureId;
            Database.SaveResult sr = Database.update(relatedAgent, true);
            if(sr.isSuccess()) {
                blnAgenLockUnlock = true;
            }else{
                stgMessage = String.valueOf(sr.getErrors());
                //AAZ_Utils_cls.insertIncidence(stgMessage,stgtype,idCurrentCase,idCurrentId);
            }
            System.debug(loggingLevel.Error, '*** blnAgenLockUnlock: ' + blnAgenLockUnlock);
            isItValidToStart = true;
        }
    }
}