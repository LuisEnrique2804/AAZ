public class AAZ_QualitySamples_ctr
{


	/*******************************************************************************************************
		Variables de busqueda
	*/

	//fields page asignacion option
	public String strNombre {get;set;}
	public String strApaterno {get;set;}
	public String strAmaterno {get;set;}
	public String strNss {get;set;}
	public String strCurp {get;set;}
	public String strRfc {get;set;}
	public String strStatus2  {get;set;} //Estatus
	public String strRegion {get;set;}
	public String strFechaInicio {get;set;}
	public String strFechaFin {get;set;}

	public String[] strImplementador {get;set;} //implementador
	public String hiddenImplementador {get;set;}

	public String[] strAnalistaVal {get;set;} //analista
	public String hiddenAnalistaValidador {get;set;}

	public String[] strAgPromotor {get;set;}//promotor
	public String hiddenAgentePromotor {get;set;}

	public string[] strtramite {get;set;} //servicotramite
	public String hiddenTipoServicio {get;set;}

	public String[] strSubtipo {get;set;} //subservicotramite
	public String hiddenSubTipoServicio {get;set;}

	public String[] strTipoRetiro {get;set;}//retirotramite
	public String hiddenTipoRetiro {get;set;}

	public String[] strTipoSeguro {get;set;}//segurotramite
	public String hiddenTipoSeguro {get;set;}

	public String[] strTipoPension {get;set;}//pensiontramite
	public String hiddenTipoPension {get;set;}

	public String[] strTipoRegimen {get;set;}//regimetramite
	public String hiddenTipoRegimen {get;set;}

	public String[] strTerritorioG {get;set;}//divisionalgeografia
	public String hiddenTerritorio {get;set;}

	public String[] strEstadoG  {get;set;} //estadoGeografia
	public String hiddenEstadoG {get;set;}

	public String[] strMunicipio {get;set;}//municipioGeografia
	public String hiddenMunicipio {get;set;}

	public String[] strSucursal {get;set;} //sucursalgeografia
	public String hiddenSucursal {get;set;}

	public String strProrcentaje {get;set;}
	public String strNroResultados {get;set;}
	public Integer intLoop {get;set;}
	public String strDivisional {get;set;}
	//fields page muestra option
	public String[] strnumempleadoMuestra {get;set;}
	public String[] strnumapMuestra {get;set;}
	public String[] strnombreapMuestra {get;set;}
	public String strStatusMuestra  {get;set;}
	public String[] strTerritorioMuestra {get;set;}//divisionalgeografiaMuestra
	public String[] strEstadoMuestra  {get;set;} //estadoGeografiaMuestra
	public String[] strMunicipioMuestra {get;set;}//municipioGeografiaMuestra
	public String[] strSucursalMuestra {get;set;} //sucursalgeografiaMuestra
	public String[] strImplementadorMuestra {get;set;} //implementadorMuestra
	public String[] strAnalistaValMuestra {get;set;} //analistaMuestra


	//Ids do user to case
	public String[] strIDUserValidador {get;set;} //asignarValidador
	public String[] strIDColas {get;set;} //asignarColas

	//pagination
	public boolean DisableNext{get;set;}
    public boolean DisablePrevious{get;set;}
    public boolean DisableAsignar{get;set;}
    public Integer RegistrosporPaginaInt;
    public integer TotalRegistros;
    public integer Inicio;
    public integer Fim;
    public integer divisao;
    public List<wrapperQuality> lstwrapPaginacao {get;set;}

    //list to store selected cases
    public List<Case> lstwrapSelected {get;set;}



	// Variabñe de asignacion ownerID Cola o Usuario
	public String strIDUser {get;set;}
	public String strNombreBuscar {get;set;}
	public boolean habilita{get;set;}

	public Boolean displayPopup {get; set;}
	public String strMensaje {get; set;}

	public Boolean userQuelity {get;set;}
	public Boolean buttonAsignar {get;set;}

	public List<Case> lstCase {get;set;}
	public List<wrapperQuality> lstwrapQ {get;set;}

	public integer getNtot (){
        return TotalRegistros;
    }

    public integer getNini (){
        return Inicio;
    }

    public integer getnfim (){
        return Fim;
    }

	public AAZ_QualitySamples_ctr()
	{
        //Incializacion de listas
        ListTypeRetiro = new List<selectOption>();
        ListSubService = new List<selectOption>();
        ListSeguro = new List<selectOption>();
        ListPension = new List<selectOption>();
        ListRegime = new List<selectOption>();
        ListEstado = new List<selectOption>();
        ListMunicipio = new List<selectOption>();
        ListSucursal = new List<selectOption>();
        ListAgente = getAgentepStart();
        //System.debug();
		lstCase=new List<Case>();
		lstwrapQ=new List<wrapperQuality>();
		userQuelity=false;
		strStatus2=' ---  ';
		lstwrapSelected=new List<Case>();
		buttonAsignar = true;
		RegistrosporPaginaInt= 500;
		ListImplemtador=getListImplementador();
		//getAgentepStart();
    }
    	public List<SelectOption> getAgentepStart()
    {
      List<selectOption> agente = new List<selectOption>();
              List<Contact> listagente = [SELECT Id,Name,ImplementName__c, PromoterAgentNumber__c FROM Contact WHERE PromoterAgentNumber__c != null
              								order by Name asc limit 2000];
                  if(listagente.size() > 0){
                      for(Contact c : listagente){
                      	agente.add(new Selectoption(c.Name,c.PromoterAgentNumber__c+'-'+c.Name));
                      }
                  }//else return null;
              System.debug('Esta es la lista ='+ agente);
              return agente;

    }


	/*******************************************************************************************************
		* @description Metodo que realiza la consulta en el objeto case
		* @param objectName the name of the object to look up
		* @param fieldName the name of the field to look up
		*/
	public void busqueda()
	{
        strFechaInicio  = Apexpages.currentPage().getParameters().get('strFechaInicio');
		strFechaFin     = Apexpages.currentPage().getParameters().get('strFechaFin');
		strStatus2 = 	Apexpages.currentPage().getParameters().get('strStatus2');
		strNss = Apexpages.currentPage().getParameters().get('strNss');
		strNombre=Apexpages.currentPage().getParameters().get('strNombre');
		strApaterno=Apexpages.currentPage().getParameters().get('strApaterno');
		strAmaterno=Apexpages.currentPage().getParameters().get('strAmaterno');
		strCurp=Apexpages.currentPage().getParameters().get('strCurp');
		strRfc=Apexpages.currentPage().getParameters().get('strRfc');
		String strNroAgenteProm=Apexpages.currentPage().getParameters().get('strNroAgenteProm');
		String StrNroEmpleadoAP=Apexpages.currentPage().getParameters().get('StrNroEmpleadoAP');
		String strNroAnVal=Apexpages.currentPage().getParameters().get('strNroAnVal');

		// String rMuestra = Apexpages.currentPage().getParameters().get('rMuestra');
		// String rAsig    = Apexpages.currentPage().getParameters().get('rAsig');

		String sql = 'SELECT ID,FolioNSS__c, Type, SubType__c, EmployeeNumberPromoterAgent__c, employeeNumber__c, Contact.PromoterAgentNumber__c, ccImplement__c, SubSubType__c,ownerid, Owner_EmployeeNumber__c, Account.Name, Account.NSS__c, starDateComplain__c,'+
					' EndDate__c, ClosedDate, CreatedDate'+
					' FROM Case';
		String sqlwhere =' WHERE id <> null';
		String sqlCount ='Select count() from Case';
			sqlwhere+= String.isBlank(strNss)?'':' AND Account.NSS__c=\''+strNss+'\'';
			sqlwhere+= String.isBlank(strCurp)?'':' AND Account.CURP__c=\''+strCurp+'\'';
			sqlwhere+= String.isBlank(strNroEmpleadoAP)?'':' AND Contact.EmployeeNumber__c=\''+strNroEmpleadoAP+'\'';
			sqlwhere+= String.isBlank(strNroAgenteProm)?'':' AND Contact.PromoterAgentNumber__c=\''+strNroAgenteProm+'\'';
			sqlwhere+= String.isBlank(strNroAnVal)?'':' AND Owner_EmployeeNumber__c=\''+strNroAnVal+'\'';
			sqlwhere+= String.isBlank(strNombre)?'':' AND Account.FirstName=\''+strNombre+'\'';
			sqlwhere+= String.isBlank(strApaterno)?'':' AND Account.PaternalLastName__c=\''+strApaterno+'\'';
			sqlwhere+= String.isBlank(strAmaterno)?'':' AND Account.MaternalLastName__c=\''+strAmaterno+'\'';

			sqlwhere+= String.isBlank(strRfc)?'':' AND Account.RFC__c=\''+strRfc+'\'';
			sqlwhere+= strStatus2.equals('---')?' AND Status IN (\'RECHAZADO\',\'ACEPTADO\') ':' AND Status=\''+strStatus2+'\'';

			if(hiddenTipoServicio!=null && hiddenTipoServicio!='') {
				strtramite=hiddenTipoServicio.split(';');
				sqlwhere+=' AND Type in '+quoteKeySet(strtramite);
			}

			if(hiddenSubTipoServicio!=null && hiddenSubTipoServicio!=''){
				strSubtipo=hiddenSubTipoServicio.split(';');
				sqlwhere+= ' AND SubType__c in '+quoteKeySet(strSubtipo);
			}
			if(hiddenTipoRetiro!=null && hiddenTipoRetiro!=''){
				strTipoRetiro=hiddenTipoRetiro.split(';');
				sqlwhere+= ' AND NewWithdrawType__c in '+quoteKeySet(strTipoRetiro);
			}
			if(hiddenTipoSeguro!=null && hiddenTipoSeguro!=''){
				strTipoSeguro=hiddenTipoSeguro.split(';');
				sqlwhere+= ' AND NewSecurityType__c in  '+quoteKeySet(strTipoSeguro);
			}
			if(hiddenTipoPension!=null && hiddenTipoPension!=''){
				strTipoPension=hiddenTipoPension.split(';');
				sqlwhere+= ' AND NewPensionType__c in  '+quoteKeySet(strTipoPension);
			}
			if(hiddenTipoRegimen!=null && hiddenTipoRegimen!=''){
				strTipoRegimen=hiddenTipoRegimen.split(';');
				sqlwhere+= ' AND RegimeType__c in '+quoteKeySet(strTipoRegimen);
			}
			if(hiddenTerritorio!=null && hiddenTerritorio!=''){
				strTerritorioG=hiddenTerritorio.split(';');
				sqlwhere+= ' AND territorialSF__c in '+quoteKeySet(strTerritorioG);
			}
			if(hiddenSucursal!=null && hiddenSucursal!=''){
				strSucursal=hiddenSucursal.split(';');
				sqlwhere+= ' AND sucursalEconomicNumber__c in '+quoteKeySet(strSucursal);
			}
			if(hiddenImplementador!=null && hiddenImplementador!=''){
				strImplementador=hiddenImplementador.split(';');
				sqlwhere+= ' AND Contact.ReportsTo.ImplementName__c in '+quoteKeySet(strImplementador);
			}
			if(hiddenAnalistaValidador!=null && hiddenAnalistaValidador!=''){
				strAnalistaVal=hiddenAnalistaValidador.split(';');
				sqlwhere+= ' AND Owner.Name in '+quoteKeySet(strAnalistaVal);
			}
			if(hiddenAgentePromotor!=null && hiddenAgentePromotor!=''){
				strAgPromotor=hiddenAnalistaValidador.split(';');
				sqlwhere+= ' AND Contact.Name in '+quoteKeySet(strAgPromotor);
			}
		sqlwhere+= String.isBlank(strFechaInicio)&&String.isBlank(strFechaFin)?'':' AND CreatedDate > '+strFechaInicio+'T00:00:00Z AND CreatedDate < '+strFechaFin+'T23:59:59Z';
		sqlwhere += ' Limit 2000';
		System.debug(' \n\n  sql = '+ sql+sqlwhere +' \n\n');
		lstCase= Database.query(sql+sqlwhere);
		wrapperQuality wp;
		System.debug('lstCase >>> ' + lstCase);
		if(lstCase.size()>0)
		{
			System.debug('strNroResultados >>> ' + strNroResultados );
			System.debug('lstCase.size() >>> ' + lstCase.size() );
				for(Case c:lstCase)
				{
					wp=new wrapperQuality(c);
					lstwrapQ.add(wp);
				}
				lstwrapPaginacao = null;
				lstwrapPaginacao = lstwrapQ;
				TotalRegistros = lstwrapPaginacao.size();
				divisao = TotalRegistros / RegistrosporPaginaInt;
				Fim = math.mod(TotalRegistros , RegistrosporPaginaInt) > 0 ? divisao + 1 : divisao;
				Inicio = 1;
				indexListResult();
			System.debug('Total do SOQL :' +TotalRegistros);
			System.debug('RegistrosporPaginaInt :' +RegistrosporPaginaInt);
			System.debug('TotalRegistros / RegistrosporPaginaInt:' +divisao);
			System.debug('Fim :' +Fim);
			System.debug('Inicio :' +Inicio);

		}
		else
		{	displayPopUp=true;
			// strMensaje='La consulta no delvolvio ningun resultado <br> ' + sql+sqlwhere ;
			strMensaje='No se encontraron coincidencias con los criterios especificados';
		}
	}
	public PageReference Previous(){
        Inicio = Inicio - 1;
        indexListResult();
        return null;
    }
    public PageReference PreviousAsingar()
		{
			userQuelity=false;
			//lstwrapQ.clear();
			System.debug('\n\n userQuelity '+userQuelity+'lstwrapQ '+ lstwrapQ.size()+'\n\n');
			return null;
    }

    public PageReference Next(){
    	Inicio = Inicio + 1;
        indexListResult();
        return null;
    }

	public void indexListResult (){
        Integer valI = (Inicio - 1) * RegistrosporPaginaInt;
        Integer dist ;
        Integer i;
        lstwrapQ = null;
        lstwrapQ = new list<wrapperQuality>();

        if(Inicio == Fim){
            DisableNext = true;
            dist = TotalRegistros ;
            System.debug('igual :' +DisableNext);
        }else{
            DisableNext = false;
            dist = valI + RegistrosporPaginaInt;
            System.debug('diferente :' +DisableNext);
        }
        if(Inicio == 1){
            DisablePrevious = true;
            System.debug('DisablePrevious :' +DisablePrevious);
        }else if (Inicio > 1){
            DisablePrevious = false;
            System.debug('DisablePrevious2 :' +DisablePrevious);
        }
        i = valI;
        system.debug('i ' + i + ' dist '+ dist + 'Inicio' + Inicio);
        while( i < dist){
					lstwrapQ.add(lstwrapPaginacao.get(i));
            i++;
        }
        System.debug('lstwrapQ>> ' + lstwrapQ.size());
    }

	public PageReference getSelected()
    {
		lstCase.clear();
		lstwrapSelected.clear();

		for(wrapperQuality wq:lstwrapPaginacao)
		{
			if(wq.selected == true)
			{
				lstwrapSelected.add(wq.QualityCase);
			}
		}
		System.debug('lstwrapSelected>> ' + lstwrapSelected);
        return null;
    }

		public PageReference NexAsignar()
		{
			userQuelity=true;
			System.debug('\n\n  strProrcentaje '+strProrcentaje+' strNroResultados'+ strNroResultados +' \n\n');

			Integer intPor=!String.isBlank(strProrcentaje)?Integer.valueOf(strProrcentaje):0;
			Integer intNroResult=!String.isBlank(strNroResultados)?Integer.valueOf(strNroResultados):0;

			intLoop=intPor!=0?Math.round((TotalRegistros*intPor)/100):intNroResult;
			//for()
			System.debug('\n\n  intLoop '+intLoop+' TotalRegistros'+ TotalRegistros +' \n\n');
			System.debug('\n\n  lstwrapPaginacao '+lstwrapPaginacao.size()+' TotalRegistros'+ TotalRegistros +' \n\n');

			// Integer rand = Math.round(Math.random()*100);
			for(Integer i=0;i<intLoop;i++)
			{
				while ( true ) {
					Integer rand = Math.round(Math.random()*(TotalRegistros-1));
					if(lstwrapPaginacao[rand].selected==false)
					{
						lstwrapPaginacao[rand].selected=true;
						System.debug('\n\n  rand '+rand+' \n\n');
						break;
					}
				}
			}

			//buttonAsignar = false;
				return null;
    }

		public void save()
		{
		System.debug('\n\n strIDUserValidador = '+strIDUserValidador+'\n\n');
		System.debug('\n\n strIDColas = '+strIDColas+'\n\n');
		System.debug('\n\n Casos selecionados = '+lstwrapSelected.size()+'\n\n');
		// if( (strIDUserValidador.size() == 1 && strIDUserValidador.get(0).contains('---')) || strIDUserValidador == null || strIDUserValidador.size() ==0){
		lstwrapSelected.clear();
		for(wrapperQuality wq:lstwrapPaginacao)
		{
			if(wq.selected == true)
			{
				System.debug('\n\n Ingresa seleccionados \n\n');
				lstwrapSelected.add(wq.QualityCase);
			}
		}
		if(String.isBlank(strIDUser)) {
		  displayPopUp=true;
		  strMensaje='Por favor seleccione un Agente Validador o una Cola para asignar';
		}
		if(lstwrapSelected.size() == 0 || lstwrapSelected == null ){
		  displayPopUp=true;
		  strMensaje='No hay ningun regostro seleccionados.';
		}
		else{
		Integer x = 0;
		List<Case> updateCaso    = new List<Case>();
		List<String> proprietarios = new List<String>();
		List<String> owners = new List<String>();

		// proprietarios.clear();
		// owners.clear();
		// proprietarios.addAll(strIDUserValidador);
		// proprietarios.addAll(strIDColas);
		//
		// for(Integer y=0;y<proprietarios.size();y++){
		//  if(!proprietarios.get(y).contains('---')){
		//  	owners.add(proprietarios.get(y));
		//  }
		// }

		// System.debug('IDs Validador/Colas OWNER: '+ owners);
		// System.debug('IDs OWNER SIZE: '+ owners.size());

		// for(Integer z=0;z<lstwrapSelected.size();z++){
		//   wrapperQuality wra = lstwrapSelected[z];
		// 		// if( z == 0 || x == (owners.size() - 1)){ //first loop
		// 		//   x = 0;
		// 		//   System.debug('X0 ' +x);
    //     	    // }else{
    //     	    //   x = x+1;
	  //   	      // System.debug('X+ ' +x);
    //     	    // }
    //     	  //  wra.QualityCase.Id = lstwrapSelected.get(z).Id;
		// 					wra.QualityCase.OwnerId=strIDUser;
	  //   	    // ca.OwnerId = owners.get(x);
		// 				updateCaso.add(wra.QualityCase);
		//
    //     }

		for(Case ca:lstwrapSelected)
		{
			ca.OwnerId=strIDUser;
		}

		System.debug('UPDATE CASO SIZE ' +updateCaso.size());
		System.debug('UPDATE CASOX ' +updateCaso);

		Database.SaveResult[] srList = Database.update(lstwrapSelected, false);

		for (Database.SaveResult sr : srList) {
        	 if (sr.isSuccess()) {
           		System.debug('Successfully update case. Case ID: ' + sr.getId());
         	}else {
          		for(Database.Error err : sr.getErrors()) {
            		System.debug('The following error has occurred.');
            		System.debug(err.getStatusCode() + ': ' + err.getMessage());
         		}
       		}
					strMensaje='Registros Actualizados ';
					strMensaje+=' <ol class="slds-list_ordered"> ';
			displayPopUp=true;
		}
	  }
	}


	public PageReference closePopup() {
		displayPopup = false;
		PageReference pageRef = new PageReference('/apex/AAZ_QualitySamples_pag');
		pageRef.setRedirect(true);
		return pageRef;
	}

	public void showPopup() {
		displayPopup = true;
	}


	public Class wrapperQuality
	{
		public Boolean selected {get;set;}
		public Case QualityCase {get;set;}

		public wrapperQuality(Case c)
		{
		QualityCase=c;
		selected=false;
		}
	}

    /*29/09/2017: RF: INICIO METODO: Ajustar condicao IN SOQL*/
	@TestVisible private String quoteKeySet(List<String> mapKeySet)
    {
        String newSetStr = '' ;
        if(mapkeyset == null ||mapKeySet.size() ==0 ){
        	String x = '\'' +  + '\'';
            newSetStr = '(' + x + ')';
            System.debug('newSetStrNULL ============ ' + newSetStr);
            return newSetStr;
        }else{
        for(String str : mapKeySet)
            newSetStr += '\'' + str + '\',';
            newSetStr = newSetStr.lastIndexOf(',') > 0 ? '(' + newSetStr.substring(0,newSetStr.lastIndexOf(',')) + ')' : newSetStr ;
            //System.debug('quoteKeySet() :  newSetStr ============ ' + newSetStr);
        return newSetStr;
        }
   }
   /*29/09/2017: RF: FIM METODO: Ajustar condicao IN SOQL*/

   /*29/09/2017: RF: INICIO METODO:*/
   public List<selectOption> ListNumeroEmpleado{
        get{
            List<selectOption> empleado = new List<selectOption>();
            List<Contact> listimpl = [SELECT Id,Name,EmployeeNumber__c FROM Contact
            								where EmployeeNumber__c != null
            								order by EmployeeNumber__c asc limit 2000];
                if(listimpl.size() > 0){
                    for(Contact c : listimpl){
                    	empleado.add(new Selectoption(c.EmployeeNumber__c,c.EmployeeNumber__c));
                    }
                }else return null;
            return empleado;
        }
        private set;
    }

    public List<selectOption> ListNumeroAP{
        get{
            List<selectOption> empleado = new List<selectOption>();
            List<Contact> listimpl = [SELECT Id,Name,PromoterAgentNumber__c FROM Contact
            								where PromoterAgentNumber__c != null
            								order by PromoterAgentNumber__c asc limit 2000];
                if(listimpl.size() > 0){
                    for(Contact c : listimpl){
                    	empleado.add(new Selectoption(c.PromoterAgentNumber__c,c.PromoterAgentNumber__c));
                    }
                }else return null;
            return empleado;
        }
        private set;
    }

    public List<selectOption> ListNombreAP{
        get{
            List<selectOption> empleado = new List<selectOption>();
            List<Contact> listimpl = [SELECT Id,Name FROM Contact
            								where Name != null
            								order by Name asc limit 2000];
                if(listimpl.size() > 0){
                    for(Contact c : listimpl){
                    	empleado.add(new Selectoption(c.Name,c.Name));
                    }
                }else return null;
            return empleado;
        }
        private set;
    }

   public List<selectOption> ListImplemtador {get;set;}

		public static List<SelectOption> getListImplementador() {
			List<selectOption> implementador = new List<selectOption>();
            List<Contact> listimpl = [SELECT Id,Name,ImplementName__c, EmployeeNumber__c FROM Contact
            								where RecordTypeId =: Label.AAZ_RecortypeImplementador
            								order by ImplementName__c asc limit 2000];
                if(listimpl.size() > 0)
                {
                    for(Contact c : listimpl){
                    	implementador.add(new Selectoption(c.ID,c.EmployeeNumber__c +'-'+c.Name));
                    }
                }else return null;
            return implementador;
        }

    public List<selectOption> ListAgente {get;set;}

    public PageReference getAgentePromotor()
		{
			System.debug('\n\n Consulta AgentePromotor \n\n');
			hiddenImplementador = Apexpages.currentPage().getParameters().get('hiddenImplementador');
			ListAgente = getAgentep();
			// public String[] strImplementador {get;set;} //implementador
			// public String hiddenImplementador {get;set;}
			System.debug('\n\n  Despues de llenar la lista '+hiddenImplementador+' \n\n');
			return null;
    }

    public List<SelectOption> getAgentep()
    {
			strImplementador=hiddenImplementador.split(';');
      List<selectOption> agente = new List<selectOption>();
              List<Contact> listagente = [SELECT Id,Name,ImplementName__c, PromoterAgentNumber__c FROM Contact
              								where ImplementName__c in: strImplementador
              								order by Name asc limit 2000];
                  if(listagente.size() > 0){
                      for(Contact c : listagente){
                      	agente.add(new Selectoption(c.Name,c.PromoterAgentNumber__c+'-'+c.Name));
                      }
                  }//else return null;
              return agente;
    }
    public List<selectOption> ListAnalista{
        get{
            List<selectOption> analista = new List<selectOption>();
            List<User> listUser = [SELECT Id,Name FROM User
            								where Name != null
            								order by Name asc limit 100];
                if(listUser.size() > 0){
                   for(User u : listUser){
                    	analista.add(new Selectoption(u.ID,u.Name));
                    }
                }else return null;
            return analista;
        }
        private set;
    }

    public List<selectOption> ListAgenteValidador {
        get{
            List<selectOption> validador = new List<selectOption>();
            List<User> listUser = [SELECT Id,Name FROM User
            								where Name != null
            								order by Name asc limit 2000];
                if(listUser.size() > 0){
                   for(User u : listUser){
                    	validador.add(new Selectoption(u.Id,u.Name));
                    }
                }else return null;
            return validador;
        }
        private set;
    }
    /*29/09/2017: RF: FIM METODO: BUSCAR*/


	/*27/09/2017: RF: INICIO METODO: PREENCHER PICKSLIST TIPO DE TRAMITE*/
	public List<selectOption> ListSeviceType {
        get{
            List<selectOption> service = new List<selectOption>();
            List<KindOfProcedure__c> typeService = [SELECT Id,Name,Code__c FROM KindOfProcedure__c WHERE SeviceType__c = true order by Code__c asc];
                if(typeService.size() > 0){
                    for(KindOfProcedure__c k : typeService){
                    	service.add(new Selectoption(k.Name,k.Name));
                    }
                }else return null;
            return service;
        }
        private set;
    }
    public List<selectOption> ListSubService {get;set;}
		public PageReference getListSubservice()
		{
			ListSubService =new List<selectOption>();
			hiddenTipoServicio = Apexpages.currentPage().getParameters().get('hiddenTipoServicio');
			strtramite=hiddenTipoServicio.split(';');
			List<KindOfProcedure__c> subservice = [SELECT Id,Name,Code__c FROM KindOfProcedure__c
														WHERE ServiceSubType__c = true
														and Father__r.Name in: strtramite
														order by Name asc];
			if(subservice.size() > 0){
				for(KindOfProcedure__c s : subservice){
					ListSubService.add(new Selectoption(s.Name, s.Name));
				}
			}
			return null;
		}

		public List<selectOption> ListTypeRetiro {get;set;}
		public PageReference getTypeRetiro()
		{
			ListTypeRetiro = new List<selectOption>();
			hiddenSubTipoServicio= Apexpages.currentPage().getParameters().get('hiddenSubTipoServicio');
			strSubtipo=hiddenSubTipoServicio.split(';');
			List<KindOfProcedure__c> retiro = [SELECT Id,Name,Code__c FROM KindOfProcedure__c
														WHERE RetirementType__c = true
														and Father__r.Name in: strSubtipo
														order by Name asc];
			if(retiro.size() > 0)
			{
				for(KindOfProcedure__c r : retiro){
					ListTypeRetiro.add(new Selectoption(r.Name, r.Name));
				}
			}
			return null;
		}

		public List<selectOption> ListSeguro {get;set;}
		public PageReference getListSeguro()
		{
			ListSeguro=new List<selectOption>();
			hiddenTipoRetiro= Apexpages.currentPage().getParameters().get('hiddenTipoRetiro');
			strTipoRetiro=hiddenTipoRetiro.split(';');
			List<KindOfProcedure__c> seguro = [SELECT Id,Name,Code__c FROM KindOfProcedure__c
																	WHERE InsuranceType__c = true
																	and Father__r.Name in: strTipoRetiro
																	order by Name asc];
			if(seguro.size() > 0){
				for(KindOfProcedure__c s : seguro){
					ListSeguro.add(new Selectoption(s.Name, s.Name));
				}
			}
			return null;
		}

    public List<selectOption> ListPension {get;set;}
		public PageReference getTipoPension()
		{
			ListPension = new List<selectOption>();
			hiddenTipoSeguro= Apexpages.currentPage().getParameters().get('hiddenTipoSeguro');
			strTipoSeguro=hiddenTipoSeguro.split(';');
			List<KindOfProcedure__c> pension = [SELECT Id,Name,Code__c FROM KindOfProcedure__c
							WHERE PensionType__c = true
							and Father__r.Name in: strTipoSeguro
							order by Name asc];
							if(pension.size() > 0){
								for(KindOfProcedure__c p : pension){
									ListPension.add(new Selectoption(p.Name, p.Name));
								}
						}
			return null;
		}

		public List<selectOption> ListRegime {get;set;}
		public PageReference getRegimen()
		{
			ListRegime = new List<selectOption>();
			hiddenTipoPension= Apexpages.currentPage().getParameters().get('hiddenTipoPension');
			strTipoPension=hiddenTipoPension.split(';');
			List<KindOfProcedure__c> goverment = [SELECT Id,Name,Code__c FROM KindOfProcedure__c
														WHERE GovermmentType__c = true
														and Father__r.Name in: strTipoPension
														order by Name asc];
			if(goverment.size() > 0){
				for(KindOfProcedure__c g : goverment){
					ListRegime.add(new Selectoption(g.Name, g.Name));
				}
			}

			return null;
		}
    /*27/09/2017: RF: FIM METODO: PREENCHER PICKSLIST TIPO DE TRAMITE*/

    /*27/09/2017: RF: INICIO METODO: PREENCHER PICKSLIST GEOGRAFIA*/
	public List<selectOption> ListDivisional {
        get{
            List<selectOption> territorio = new List<selectOption>();
            List<Geography__c> divi = [SELECT Id,Name,Codigo__c FROM Geography__c WHERE Divisional__c = true order by Name asc];
                if(divi.size() > 0){
                	for(Geography__c d : divi){
                   	 territorio.add(new Selectoption(d.Name,d.Name));
                	}
                }else return null;
            return territorio;
        }
        private set;
    }



    public List<selectOption> ListEstado {get;set;}
		public PageReference getEstado()
		{
			ListEstado = new List<selectOption>();
			hiddenTerritorio= Apexpages.currentPage().getParameters().get('hiddenTerritorio');
			strTerritorioG=hiddenTerritorio.split(';');
			List<Geography__c> estado = [SELECT Id,Name,Codigo__c FROM Geography__c
										WHERE State__c = true
										and Padre__r.Name in: strTerritorioG
										order by Name asc];
			if(estado.size() > 0){
				for(Geography__c e : estado){
						ListEstado.add(new Selectoption(e.Name, e.Name));
					}
				}
			return null;
		}

		public List<selectOption> ListMunicipio {get;set;}
		public PageReference getMunicipio()
		{
			ListMunicipio=new List<selectOption>();
			hiddenEstadoG= Apexpages.currentPage().getParameters().get('hiddenEstadoG');
			strEstadoG=hiddenEstadoG.split(';');
			List<Geography__c> municipio = [SELECT Id,Name,Codigo__c FROM Geography__c
														WHERE City__c = true
														and Padre__r.Name in: strEstadoG
														order by Name asc];
			System.debug('\n\n hiddenEstadoG '+hiddenEstadoG);
		if(municipio.size() > 0){
			for(Geography__c m : municipio){
					ListMunicipio.add(new Selectoption(m.Name, m.Name));
			}
		}
			return null;
		}

    public List<selectOption> ListSucursal {get;set;}
		public PageReference getSucursales(){
			ListSucursal=new List<selectOption>();
			hiddenMunicipio= Apexpages.currentPage().getParameters().get('hiddenMunicipio');
			strMunicipio=hiddenMunicipio.split(';');
			System.debug('\n\n strMunicipio'+ strMunicipio +'\n\n');
			List<Geography__c> surcusal = [SELECT Id,Name,Codigo__c FROM Geography__c
														WHERE Subsidiary__c = true
														and Padre__r.Name in: strMunicipio
														order by Name asc];
			System.debug('\n\n surcusal'+ surcusal +'\n\n');
		if(surcusal.size() > 0){
				for(Geography__c s : surcusal){
					ListSucursal.add(new Selectoption(s.Name, s.Codigo__c+'-'+s.Name));
				}
		}
			return null;
		}

    /*27/09/2017: RF: FIM METODO: PREENCHER PICKSLIST GEOGRAFIA*/

}