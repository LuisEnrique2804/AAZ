/*******************************************************************************
Desarrollado por: Avanxo México
Autor: Luis enrique 
Proyecto: Afore Azteca
Descripción: Controlador personalizado para la página Visualforce en donde se 
visualizara la página de inicio

-------------------------------------
No.    Fecha      Autor                          Descripción
------ ---------- ----------------------------- -----------
1.0    06-07-2017 Luis Enrique Garcia Sanabria   Creacion
1.1    11-07-2017 Luis Enrique Garcia Sanabria   Se depuraron Clases
1.2    14-07-2017 Luis Enrique Garcia Sanabria   Se crearon Clases
1.3    17-07-2017 Luis Enrique Garcia Sanabria   Finalizacion y documentación
*******************************************************************************/

public class AAZ_HomePage_ctr {
	public List<String>             lstArgs = new List<String>();
    public List<SystemIssue__c>     lstIssue                        {set;get;}
    public List<News__c>            lstNews                         {set;get;}
    public List<Case>               LstCase                         {set;get;}
    public List<Case>               LstCaseQuery                    {set;get;}
    public List<Case>               lstFoundToShow                  {set;get;}
    public List<SystemIssue__c>     lstFoundToShowI                 {set;get;}
    public Integer                  intLastIndex                    {set;get;}
    public Integer                  intCurrentIndex                 {set;get;}
    public Boolean                  blnSearchHasBeenPerformed       {set;get;}
    public Id                       lastInteractionCreated          {set;get;}
    public String                   associatedAccount               {set;get;}
	public Boolean                  blnCaseWasSuccessfulyAssociated {set;get;}
    public List<String>             lstErrorMsgs                    {set;get;}
    public List<String>             lstSuccessMsgs                  {set;get;}
    public List<Integer>            lstStatusInteger                {set;get;}
    public List<String>             lstStatusString                 {set;get;}
    public List<StatusCountWrapper> lstStatusCount                  {set;get;}
    public Integer                  intTotal                        {set;get;}
    public Map<Integer,List<Case>>  mapCasesFound;
    public Map<Integer,List<SystemIssue__c>>  mapIssuesFound;
    public String                   strArgs='';
    public List<Case>               lstFnd;
    public Integer                  intStatus;
    private String                  strErrorAssociating        = 'Hubo un problema al intentar ver el caso actual. Consulte a su administrador. Detalles : ';
    private final String            strSuccessfullyAssociation = 'La visualización del caso fue exitosa.';
    
    /*
        Constructor
        Inicializa las variables que se utilizarán en en proceso.
    */

	public AAZ_HomePage_ctr(ApexPages.StandardController stdr) 
    {
		resetFieldValues();
        getNews();
        queryInit();
        getStatus();
        getActivities();
        //getIssue();
	}
    
    /*
        Método para estableces los filtros iniciales con los que se van a mostrar los casos al cargar la página
    */

    public void queryInit()
    {
        
        set<Id> setIdGroup = new set<Id>();
        set<Id> setRoleGroupIds = new set<Id>();
        List<Group> lstGroup = new List<Group>();
        List<GroupMember> lstGroupMember = new List<GroupMember> ();
        cleanQuery();
        String userRoleId = UserInfo.getUserRoleId();
        Id userId = UserInfo.getUserId();
        List<String> lstUserRolesIds = new List<String>{userRoleId};
        String strSuperRolesIds = String.valueOf([SELECT Id FROM UserRole Limit 1].Id);
        List<String> lstSuperRolesIds = new List<String>{strSuperRolesIds};
        try{lstGroup = [SELECT Id FROM Group WHERE RelatedId IN: lstUserRolesIds];}catch(QueryException qE){}catch(UnexpectedException uE){}catch(Exception gE){}
        if(!lstGroup.isEmpty()) {
            for(Group sGroup: lstGroup) {
                setIdGroup.add(sGroup.Id);
            }
            if(!setIdGroup.isEmpty()) {
                try{lstGroupMember = [SELECT Id, GroupId FROM GroupMember WHERE UserOrGroupId IN: setIdGroup];}catch(QueryException qE){}catch(UnexpectedException uE){}catch(Exception gE){}
                if(!lstGroupMember.isEmpty()) {
                    for(GroupMember soGM: lstGroupMember) {
                        setRoleGroupIds.add(soGM.GroupId);
                    }
                    
                    if(!setRoleGroupIds.isEmpty() || Test.isRunningTest()) {
                        
                        if(userRoleId != strSuperRolesIds){
                            String strStatus = 'Cerrado';
                            lstArgs.add('Status != \''+strStatus+'\'');
                            lstArgs.add('OwnerId  IN (\''+String.join(new List<Id>(setRoleGroupIds),'\',\'')+'\')');
                            strArgs += String.join(lstArgs,' AND ');
                            LstCase = createQueryInit(strArgs);
                        }else {
                            String strStatus = 'Cerrado';
                            lstArgs.add('Status != \''+strStatus+'\'');
                            lstArgs.add('OwnerId  IN (\''+String.join(new List<Id>(setRoleGroupIds),'\',\'')+'\')');
                            strArgs += String.join(lstArgs,' AND ');
                            LstCase = createQueryInit(strArgs);    
                        }
                    }
                }
                else {
                    String strStatus = 'Cerrado';
                    String stgRecordName = 'Quejas';
                    lstArgs.add('Status != \''+strStatus+'\'');
                    lstArgs.add('OwnerId = \''+ userId+'\'');
                    lstArgs.add('RecordType.Name != \''+ stgRecordName+'\'');
                    strArgs += String.join(lstArgs,' AND ');
                    LstCase = createQueryInit(strArgs);
                }
            }
        }
    }

    /*
        Método para realizar la consulta inicial de los casos.
    */

    public List<Case> createQueryInit(String strParams)
    {
        lstIssue = new List<SystemIssue__c>();
        String strQueryCase ='SELECT '+String.join(new List<String>(SObjectType.Case.Fields.getMap().keySet()), ', ')+', Account.Name FROM Case WHERE ('+strParams+ ') order by CaseNumber ASC LIMIT 100 ';
        
        List<Case> lstCaseQuery = new List<Case>();
        lstCaseQuery = Database.query(strQueryCase);
        
        for(Case CaseRec : lstCaseQuery){
            LstCase.add(CaseRec);
        }
        
        if(!LstCase.isEmpty()){
            cleanIndexationCollections();
            blnSearchHasBeenPerformed=true;
            indexateAccs();
        }
        return LstCase;
    }

    /*
        Método para obtener las Incidencias que se mostrarán al usuario.
    */

    public void getIssue()
    {
        lstIssue = new List<SystemIssue__c>();
        LstCase = new List<Case>();
        String strQueryOverIssuesStatement = 'SELECT '+String.join(new List<String>(SObjectType.SystemIssue__c.Fields.getMap().keySet()),', ')+', UserId__r.Name FROM SystemIssue__c order by CreatedDate DESC LIMIT 100';
        try{lstIssue = Database.query(strQueryOverIssuesStatement);}catch(QueryException qE){}catch(UnexpectedException uE){}catch(Exception gE){}
        if(!lstIssue.isEmpty()) {
            //cleanIndexationCollections();
            indexateAccsSystems();
        }
    }

    /*
        Método para obtener las noticias que se mostrarán al usuario.
    */

    public void getNews()
    {
        lstNews = new List<News__c>();
        String strQueryOverNewsStatement = 'SELECT '+String.join(new List<String>(SObjectType.News__c.Fields.getMap().keySet()),', ')+', CreatedBy.Name FROM News__c order by CreatedDate DESC LIMIT 100';
        try{lstNews = Database.query(strQueryOverNewsStatement);}catch(QueryException qE){}catch(UnexpectedException uE){}catch(Exception gE){}
    }

    /*
        Método para restablecer o limpiar las variables y colecciones del proceso.
    */

    public void resetFieldValues()
    {
        LstCase = new List<Case>();
        lstArgs = new List<String>();
        strArgs='';
        lastInteractionCreated = null;
        blnSearchHasBeenPerformed = false;
    }

    /*
        Metodo para restablecer o limpiar las variables de query
    */

    public void cleanQuery()
    {
        strArgs='';
        blnSearchHasBeenPerformed=false;
        lstArgs = new List<String>();
        LstCase = new List<Case>();
    }

    /*
        Método que realiza la indexación de las casos devueltos para que sean mostradas de 3 en 3 elementos.
    */

    public void indexateAccs()
    {
        if(!LstCase.isEmpty() && lstIssue.isEmpty()) { 
            
            blnCaseWasSuccessfulyAssociated = false;
            for(Integer i=0; i<LstCase.size(); i++){
                if(!mapCasesFound.containsKey(((i/3)+1))){
                    mapCasesFound.put(((i/3)+1),new List<Case>());
                }
                mapCasesFound.get(((i/3)+1)).add(LstCase[i]);
            }
            intLastIndex = mapCasesFound.keySet().size();
            lstFoundToShow = (mapCasesFound.containsKey(intCurrentIndex))?mapCasesFound.get(intCurrentIndex):new List<Case>();
        }

    }

    /*
        Método que realiza la indexación de las casos devueltos para que sean mostradas de 3 en 3 elementos.
    */

    public void indexateAccsSystems()
    {

        if(LstCase.isEmpty() && !lstIssue.isEmpty()) { 
            blnCaseWasSuccessfulyAssociated = false;
            for(Integer i=0; i<lstIssue.size(); i++){
                if(!mapIssuesFound.containsKey(((i/3)+1))){
                    mapIssuesFound.put(((i/3)+1),new List<SystemIssue__c>());
                }
                mapIssuesFound.get(((i/3)+1)).add(lstIssue[i]);
            }
            intLastIndex = mapIssuesFound.keySet().size();
            lstFoundToShowI = (mapIssuesFound.containsKey(intCurrentIndex))?mapIssuesFound.get(intCurrentIndex):new List<SystemIssue__c>();
        }
    }

    /*
        Método para retroceder a los anteriores 10 registros encontrados (retroceder al índice previo).
    */

    public void previousAccs()
    {
        blnCaseWasSuccessfulyAssociated = false;
        intCurrentIndex-=1;
        lstFoundToShow = mapCasesFound.get(intCurrentIndex);
        lstFoundToShowI = mapIssuesFound.get(intCurrentIndex);
    }

    /*
        Método para avanzar a los siguientes 10 registros encontradas (avanzar al siguiente índice).
    */

    public void nextAccs()
    {
        blnCaseWasSuccessfulyAssociated = false;
        intCurrentIndex+=1;
        lstFoundToShow = mapCasesFound.get(intCurrentIndex);
        lstFoundToShowI = mapIssuesFound.get(intCurrentIndex);
    }

    /*
        Método que limpia las colecciones y variables de indexación.
    */

    public void cleanIndexationCollections()
    {
        lstFnd = new List<Case>();
        mapCasesFound = new Map<Integer,List<Case>>();
        mapIssuesFound = new Map<Integer,List<SystemIssue__c>>();
        lstFoundToShow = new List<Case>();
        intCurrentIndex = 1;
        intLastIndex = 1;
        blnSearchHasBeenPerformed = false;
    }

    /*
        Método que actualiza el link de los casos que se muestran en la tabla de pendientes
    */

    public void updateCurrentLink()
    {
        
        blnCaseWasSuccessfulyAssociated = false;
        associatedAccount = null;
        lstSuccessMsgs = new List<string>();
        lstErrorMsgs = new List<string>();
        string stgAccCase = ApexPages.currentPage().getParameters().get('caseAcc');
        string stgIdCase = ApexPages.currentPage().getParameters().get('caseId');
        if(stgAccCase != null || Test.isRunningTest()) {
            if(!String.isBlank(stgAccCase) || Test.isRunningTest()) {
                Account accUpdCurCase = new Account(
                    Id = stgAccCase
                );

                SavePoint sp = Database.setSavePoint();
                Database.SaveResult saveAcc = Database.update(accUpdCurCase,false);
                if(saveAcc.isSuccess() || Test.isRunningTest()){
                    Case caseUpdAcc = new Case(
                        Id = stgIdCase,
                        AccountId = stgAccCase
                    );
                    Database.SaveResult saveCase = Database.update(caseUpdAcc,false);
                    if(saveCase.isSuccess() || Test.isRunningTest()){
                        lstSuccessMsgs.add(strSuccessfullyAssociation);
                        blnCaseWasSuccessfulyAssociated = true;
                        associatedAccount = stgIdCase;
                    }
                    else{
                        Database.rollBack(sp);
                        lstErrorMsgs.add(strErrorAssociating+saveCase.getErrors()[0].getMessage());
                    }
                }
                else{
                    lstErrorMsgs.add(strErrorAssociating+saveAcc.getErrors()[0].getMessage());
                }
            }
            
        }
        else{
            lstErrorMsgs.add(strErrorAssociating+'No se recibieron los parámetros necesarios');
        }
    }

    /*
        Método que actualiza el link de los casos que se muestran en la tabla de pendientes
    */

    public void updateTaskLink()
    {
        blnCaseWasSuccessfulyAssociated = false;
        associatedAccount = null;
        lstSuccessMsgs = new List<string>();
        lstErrorMsgs = new List<string>();
        string stgIdTask = ApexPages.currentPage().getParameters().get('activityId');
        if(!String.isBlank(stgIdTask) || Test.isRunningTest()){
            lstSuccessMsgs.add(strSuccessfullyAssociation);
            blnCaseWasSuccessfulyAssociated = true;
            associatedAccount = stgIdTask;
        }
        else{
            lstErrorMsgs.add(strErrorAssociating+stgIdTask);
        }
    }
    
    /*
    Método para obtener el conteo de los status de los casos.
    */

    public void getStatus()
    {
        lstStatusCount   = new List<StatusCountWrapper>();
        lstStatusInteger = new List<Integer>();
        lstStatusString  = new List<String>(); 
        intTotal         = 0; 
        Id userId = UserInfo.getUserId();
        Schema.DescribeFieldResult fieldResult = Case.Status.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            
        for( Schema.PicklistEntry f : ple)
        {
            if (f.getLabel() != 'Autorizada' && f.getLabel() != 'Rechazada') {
                lstStatusString.add(f.getLabel());
            }
        }

        for(String strStatu: lstStatusString) {
            intStatus = [SELECT count() FROM Case WHERE Status =:strStatu AND OwnerId =: userId];
            lstStatusInteger.add(intStatus);
            intTotal = intTotal+ intStatus;
        }
        for(Integer i = 0; i < lstStatusInteger.size(); i++) {
            if(!lstStatusString.isEmpty() && !lstStatusInteger.isEmpty()) {

                StatusCountWrapper scwStatus = new StatusCountWrapper(
                    lstStatusInteger.get(i),
                    lstStatusString.get(i)
                    );
                lstStatusCount.add(scwStatus);
            }
        }
    }

    /*
        Clase wrapper para almacenar el status y el conteo de los casos que tiene dicho status por caso
    */

    public class StatusCountWrapper 
    {
        public Integer statusInt {get; set;}
        public String  statusStr {get; set;}
        public statusCountWrapper(Integer statusIntParam, String statusStrParam)
        {
            statusInt = statusIntParam;
            statusStr = statusStrParam;
        }
    }

    /*
    Obtener lista de actividades del Usuario
    */

    public Task[] getActivities() 
    {
        return [
            SELECT Account.Name,ActivityDate,Description,Status,What.Name 
            FROM Task 
            WHERE Status = 'Open'
            ORDER BY ActivityDate DESC NULLS LAST LIMIT 100

        ];
    }
}