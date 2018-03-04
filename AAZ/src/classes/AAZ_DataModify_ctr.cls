/*******************************************************************************
Desarrollado por: Avanxo México
Autor: Luis enrique 
Proyecto: Afore Azteca
Descripción: Controlador personalizado para la página Visualforce en donde se 
visualizara los valores que se van a comparar para el tramite de modificacion de datos

-------------------------------------
No.    Fecha      Autor                          Descripción
------ ---------- ----------------------------- -----------
1.0    06-07-2017 Luis Enrique Garcia Sanabria   Creacion
1.1    11-07-2017 Luis Enrique Garcia Sanabria   Se depuraron Clases
1.2    14-07-2017 Luis Enrique Garcia Sanabria   Se crearon Clases
1.3    17-07-2017 Luis Enrique Garcia Sanabria   Finalizacion y documentación
2.0    02-10-2017 Andrés Morales                 Construcción
*******************************************************************************/
public with sharing class AAZ_DataModify_ctr {
	public Case caseInstance{set;get;}
    public Account accountInstance{set;get;}
	public Id caseId{set;get;}
	public Boolean           blnServiceHadError = false;
    public string            stgMessage = '';
    public String            stgtype = Label.AAZ_InsertComplaint_001;
    public String strCaseIdentifier{get;set;}
    public id                idCurrentCase;
    public id                idCurrentId = UserInfo.getUserId();
	public AAZ_DataModify_ctr(ApexPages.StandardController stdCtl) {
		caseId = stdCtl.getId();
        strCaseIdentifier = stdCtl.getId();
        
        Boolean blnServiceHadError = false;
        string stgMessage = '';
        String stgtype = 'Desarrollo';
        id idCurrentCase = caseId;
        id idCurrentId = UserInfo.getUserId();

        System.debug(loggingLevel.Error, '*** caseId: ' + caseId);

        String strQueryOverCasesStatement = 'SELECT '+String.join(new List<String>(SObjectType.Case.Fields.getMap().keySet()),', ')+', RecordType.DeveloperName FROM Case WHERE Id = \''+caseId+'\' limit 1';
        try{caseInstance = Database.query(strQueryOverCasesStatement);}catch(QueryException qE){blnServiceHadError = true; stgMessage = qE.getMessage();}catch(Exception gE){blnServiceHadError = true; stgMessage = gE.getMessage();}

        System.debug(loggingLevel.Error, '*** caseInstance: ' + caseInstance);

        //Am INI
        //Account data by Id
        if (caseInstance != null){
            id accountId = caseInstance.AccountId;

            String strQueryOverAccsStmnt = 'SELECT '+String.join(new List<String>(SObjectType.Account.Fields.getMap().keySet()),', ')+', RecordType.DeveloperName FROM Account WHERE Id = \''+accountId+'\' limit 1';
            try{accountInstance = Database.query(strQueryOverAccsStmnt);}
            catch(QueryException qE){blnServiceHadError = true;}
            catch(Exception gE){blnServiceHadError = true;}
        }
        
        //AM FIN        

        //if(blnServiceHadError == true) {
        //    AAZ_Utils_cls.insertIncidence(stgMessage,stgtype,idCurrentCase,idCurrentId);
        //}
    }

    public List<Schema.FieldSetMember> getFieldSetFieldsAcc(){
        List<Schema.FieldSetMember> lstFieldSetMemberCase = new List<Schema.FieldSetMember>();
        List<Schema.FieldSetMember> lstFieldSetMemberAcc = new List<Schema.FieldSetMember>();
        List<Schema.FieldSetMember> lstFieldSetMemberAccDef = new List<Schema.FieldSetMember>();

        lstFieldSetMemberAcc = AAZ_Utils_cls.getFieldSetMembers('Account', 'Modificacion de Datos Tramite', '', '');
        lstFieldSetMemberCase = AAZ_Utils_cls.getFieldSetMembers('Case', 'Modificacion de Datos Tramite', '', '');

        //Only Show fields with values
        if(!lstFieldSetMemberCase.isEmpty() && caseInstance != null){
            Integer intCnt = 0;
            for(Schema.FieldSetMember iterator:lstFieldSetMemberCase) {
                if (caseInstance.get(iterator.getFieldPath()) != null && caseInstance.get(iterator.getFieldPath()) != ''){
                        //System.debug('*** intCnt: ' + intCnt + ', size: ' + lstFieldSetMemberAcc.size());
                        //Se utiliza el orde de los campos
                        if(intCnt < lstFieldSetMemberAcc.size()){
                            lstFieldSetMemberAccDef.add(lstFieldSetMemberAcc.get(intCnt));                        
                        }
                }
                intCnt += 1;
            }
        }
        
        return lstFieldSetMemberAccDef;        
    }

    public List<Schema.FieldSetMember> getFieldSetFieldsCase(){
        List<Schema.FieldSetMember> lstFieldSetMemberCase = new List<Schema.FieldSetMember>();
        List<Schema.FieldSetMember> lstFieldSetMemberCaseDef = new List<Schema.FieldSetMember>();

        lstFieldSetMemberCase = AAZ_Utils_cls.getFieldSetMembers('Case', 'Modificacion de Datos Tramite', '', '');

        //Only Show fields with values
        if(!lstFieldSetMemberCase.isEmpty() && caseInstance != null){
            for(Schema.FieldSetMember iterator:lstFieldSetMemberCase) {
                if (caseInstance.get(iterator.getFieldPath()) != null && caseInstance.get(iterator.getFieldPath()) != ''){
                        lstFieldSetMemberCaseDef.add(iterator);
                }
            }
        }       

        //System.debug(loggingLevel.Error, '*** lstFieldSetMemberCase: ' + lstFieldSetMemberCase);
        //System.debug(loggingLevel.Error, '*** lstFieldSetMemberCaseDef: ' + lstFieldSetMemberCaseDef);

        return lstFieldSetMemberCaseDef;
    }    
}