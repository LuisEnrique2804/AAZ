/****************************************************************************************
    Desarrollado por:  Avanxo México
    Autor:             Luis Enrique Garcia Sanabria 
    Proyecto:          Mesa de Control Afore
    Descripción:       Clase de APEX que realiza la función de controlador perzonalizado 
    para la página de visualForce AAZ_CustomCaseDetail_pag, la cual tiene como objetivo, 
    mostrar la informacion del tramite.
     
    Cambios (Versiones)     
    -------------------------------------     
      No.      Fecha                  Autor                      Descripción     
    ------  -------------  ------------------------------   ----------------------    
     0.1     18-07-2017    Luis Enrique Garcia Sanabria     Creacion
     0.2     18-07-2017    Luis Enrique Garcia Sanabria     Construcción
     1.0     18-07-2017    Luis Enrique Garcia Sanabria     Finalización y documentación
****************************************************************************************/
public class AAZ_CustomCaseDetail_ctr {
	public Case caseInstance{set;get;}
	public Id caseId;

    public AAZ_CustomCaseDetail_ctr(ApexPages.StandardController stdCtl){
        caseId = stdCtl.getId();
        start();
    }

    public void start(){
        Boolean blnServiceHadError = false;
        string stgMessage = '';
        String stgtype = 'Desarrollo';
        id idCurrentCase = caseId;
        id idCurrentId = UserInfo.getUserId();
        String strQueryOverAccsStmnt = 'SELECT '+String.join(new List<String>(SObjectType.Case.Fields.getMap().keySet()),', ')+', Parent.caseNumber, Account.PaternalLastName__c, Account.MaternalLastName__c FROM Case WHERE Id = \''+caseId+'\' limit 1';
        try{caseInstance = Database.query(strQueryOverAccsStmnt);}catch(QueryException qE){blnServiceHadError = true; stgMessage = qE.getMessage();}catch(Exception gE){blnServiceHadError = true; stgMessage = gE.getMessage();}
        if(blnServiceHadError == true) {
            //AAZ_Utils_cls.insertIncidence(stgMessage,stgtype,idCurrentCase,idCurrentId);
        }
    }

    public List<Schema.FieldSetMember> getFieldSetFields(){
        String strRecordDevName = String.valueOf([SELECT DeveloperName FROM RecordType WHERE Id =:caseInstance.recordTypeId limit 1].DeveloperName);
        return AAZ_Utils_cls.getFieldSetMembers('Case', caseInstance.Type, caseInstance.SubType__c, caseInstance.SubSubType__c);
    }
}