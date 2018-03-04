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
	 0.1     04-08-2017    Luis Enrique Garcia Sanabria     Creacion
	 0.2     04-08-2017    Luis Enrique Garcia Sanabria     Construcción
	 1.0     09-08-2017    Luis Enrique Garcia Sanabria     Finalización y documentación
****************************************************************************************/
public class AAZ_RiskLevel_ctr {
 
	public Case caseInstance{set;get;}
	public Id   caseId;
	public Case objCasePoint;
	public Case objCasePointMax;
	public PointWrapper pwRiskLevel {get; set;}
	public List<PointWrapper> lstPointsCase {get; set;}
	public List<Case> lstcurrentCase {get; set;}
	public List<Account> lstcurrentAcc {get; set;}
	public List<Contact> lstcurrentCont {get; set;}
	public List<Schema.FieldSetMember> lstAccountFields {get; set;}
	public List<Schema.FieldSetMember> lstContactFields {get; set;}
	public List<Schema.FieldSetMember> lstContactFieldsM {get; set;}
	public List<Schema.FieldSetMember> lstCaseFields {get; set;}
	public List<Schema.FieldSetMember> lstCaseFieldsM {get; set;}
	
	/*
        Constructor 
    */

	public AAZ_RiskLevel_ctr(ApexPages.StandardController stdr) {
		caseId = stdr.getId();
		lstAccountFields = AAZ_Utils_cls.getFieldSetMembers('Account','Risk','Level','AccMax');
		lstContactFields = AAZ_Utils_cls.getFieldSetMembers('Contact','Risk','Level','Contact');
		lstContactFieldsM= AAZ_Utils_cls.getFieldSetMembers('Contact','Risk','Level','ContactMax');
		lstCaseFields = AAZ_Utils_cls.getFieldSetMembers('Case','Risk','Level','Case');
		lstCaseFieldsM = AAZ_Utils_cls.getFieldSetMembers('Case','Risk','Level','CaseMax');
		initVariaables();
		riskLevelValues();		
	}

	/*
        Clase para inicializar las varizables
    */

	public void initVariaables(){
		caseInstance    = new case();
		objCasePoint    = null;
		objCasePointMax = null;
	}

	/*
        Clase para obtener los campos y los valores del nivel de riesgo en caso, cuenta y contacto
    */
    
	public void riskLevelValues(){
		Boolean blnServiceHadError = false;
        string stgMessage          = '';
        String stgtype             = Label.AAZ_RiskLevel_001;
        id idCurrentCase           = caseId;
        id idCurrentId             = UserInfo.getUserId();
		lstcurrentCase = new List<Case>();
		lstcurrentAcc = new List<Account>();
		lstcurrentCont = new List<Contact>();
		pwRiskLevel = new PointWrapper();
		String strQueryCase ='SELECT '+String.join(new List<String>(SObjectType.Case.Fields.getMap().keySet()), ', ')+' FROM Case WHERE Id =\''+caseId+'\' LIMIT 1';
        try{lstcurrentCase = Database.query(strQueryCase);}catch(QueryException qE){stgMessage = qE.getMessage();}catch(Exception gE){stgMessage = gE.getMessage();}
		if(!lstcurrentCase.isEmpty()) {
			String strQueryAcc  ='SELECT '+String.join(new List<String>(SObjectType.Account.Fields.getMap().keySet()), ', ')+' FROM Account WHERE Id =\''+lstcurrentCase[0].AccountId+'\' LIMIT 1';
			try{lstcurrentAcc = Database.query(strQueryAcc);}catch(QueryException qE){stgMessage = qE.getMessage();}catch(Exception gE){stgMessage = gE.getMessage();}
			String strQueryCont ='SELECT '+String.join(new List<String>(SObjectType.Contact.Fields.getMap().keySet()), ', ')+' FROM Contact WHERE Id =\''+lstcurrentCase[0].ContactId+'\' LIMIT 1';
			try{lstcurrentCont = Database.query(strQueryCont);}catch(QueryException qE){stgMessage = qE.getMessage();}catch(Exception gE){stgMessage = gE.getMessage();}
		}

        if(!lstcurrentCase.isEmpty()) {
        	System.debug(lstcurrentAcc);
  			if(!lstcurrentAcc.isEmpty()) {
  				if(!lstcurrentCont.isEmpty()) {
  					blnServiceHadError = true;
			        pwRiskLevel = new PointWrapper(
			        	lstcurrentCase[0],
			        	lstcurrentAcc[0],
			        	lstcurrentCont[0]
			        );
  				}
  			}
        }
		//if(!blnServiceHadError) {
  //          AAZ_Utils_cls.insertIncidence(stgMessage,stgtype,idCurrentCase,idCurrentId);
  //      }
	}

	/*
        Clase wrapper para almacenar el puntaje del nivel de riesgo 
    */

    public class PointWrapper 
    {
        public Case objCasePoints    {get; set;}
        public Account objAccPoints  {get; set;}
        public Contact objContPoints {get; set;}
        public PointWrapper(){}
        public PointWrapper(Case caseRiskLevel, Account accRiskLevel, Contact contRiskLevel)
        {
            objCasePoints = caseRiskLevel;
            objAccPoints  = accRiskLevel;
            objContPoints = contRiskLevel;
        }
    }
}