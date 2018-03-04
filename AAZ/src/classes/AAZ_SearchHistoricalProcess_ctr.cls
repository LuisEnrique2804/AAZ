public class AAZ_SearchHistoricalProcess_ctr {
    // Cargar los mainsettings para las clases de prueba
    public static AppMainSetting_cs__c mainSettings = Test.isRunningTest()?
        AAZ_TestUtils_tst.getMainSettings() : AppMainSetting_cs__c.getOrgDefaults();



       /*******************************************************************************************************
        Variables de busqueda
    */
    // PAGINACION
    private integer counter=0;  //keeps track of the offset
    private integer list_size=100; //sets the page size or number of rows
    public integer total_size=0; //used to show user the total size of the list

    //fields page asignacion option
    public String StrNss {get;set;}
    public String strCurp {get;set;}
    public String strRfc {get;set;}
    public String strStatus2  {get;set;} //Estatus
    public String strRegion {get;set;}
    public String strFechaInicio {get;set;}
    public String strFechaFin {get;set;}
    public String strEmail {get;set;}
    public String strNombUsuario {get;set;}
    public String strIdUsuario{get;set;}
    public String strFecha {get;set;}
    
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


    //options
    public Boolean optionMuestra    {get;set;}
    public Boolean optionAsignacion {get;set;}
    public Boolean optionConsultoHistoricoWS {get;set;}
    //Ids do user to case
    public String[] strIDUserValidador {get;set;} //asignarValidador
    public String[] strIDColas {get;set;} //asignarColas
    public boolean  verdatos{get;set;}
    //pagination
    public boolean DisableNext{get;set;}
    public boolean DisablePrevious{get;set;}
    public boolean DisableAsignar{get;set;}
    public Integer RegistrosporPaginaInt;
    public integer TotalRegistros;
    public integer Inicio;
    public integer Fim;
    public integer divisao;
    public String  strSolicitud='';
   
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
    
    public integer getNtot (){
        return TotalRegistros;
    }

    public integer getNini (){
        return Inicio;
    }

    public integer getnfim (){
        return Fim;
    }

    public AAZ_SearchHistoricalProcess_ctr()
    {
        lstCase=new List<Case>();
        
        userQuelity=false;
        strStatus2=' ---  ';
        lstwrapSelected=new List<Case>();
        buttonAsignar = true;
        RegistrosporPaginaInt= 20;
        verdatos=false;
        
        //consulta el ultimo historial
        
        List<LogHistoricalProcess__c> lstHistorial=[select id,Status__c,Email__c,ProgrammedBy__c,CreatedDate from LogHistoricalProcess__c order by createdDate desc limit 1 ];
        
        
        
        optionMuestra = false;
        optionAsignacion = true;
        ListImplemtador=getListImplementador();
        optionConsultoHistoricoWS=false;
        strSolicitud='';
        if(lstHistorial.size()==0||(lstHistorial.size()>0&&(lstHistorial[0].Status__c=='REGISTRADO'||lstHistorial[0].Status__c=='FINALIZADO')))
        {
            
            if(lstHistorial.size()>0)strSolicitud=lstHistorial[0].id;
            
            User objUser=[select id,Email,Name from User  where id=:UserInfo.getUserId()];
            strIdUsuario=objUser.id;
            strEmail=objUser.Email;
            strNombUsuario=objUser.Name;
            strFecha=String.ValueOf(Date.today());
            
        }else if(lstHistorial.size()>0&&lstHistorial[0].Status__c=='EN PROCESO')
        {
            
            
            User objUser=[select id,Email,Name from User  where id=:lstHistorial[0].ProgrammedBy__c];
            strIdUsuario=objUser.id;
            optionConsultoHistoricoWS=true;
            strEmail=objUser.Email;
            strNombUsuario=objUser.Name;
            strFecha=String.ValueOf(lstHistorial[0].CreatedDate);
            
        }
        
        getCasos();
    
    }
    
    /*******************************************************************************************************
        * @description Metodo que realiza la consulta en el objeto case
        * @param objectName the name of the object to look up
        * @param fieldName the name of the field to look up
        */
    public void verdatos()
    {
        
        verdatos=true;
    }
    /*******************************************************************************************************
        * @description Metodo que realiza la consulta en el objeto case
        * @param objectName the name of the object to look up
        * @param fieldName the name of the field to look up
        */
    public void verconsulta()
    {
        verdatos=false;
        
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
        strStatus2 =    Apexpages.currentPage().getParameters().get('strStatus2');
        StrNss = Apexpages.currentPage().getParameters().get('StrNss');
        strCurp=Apexpages.currentPage().getParameters().get('strCurp');
        strRfc=Apexpages.currentPage().getParameters().get('strRfc');
        String strNroAgenteProm=Apexpages.currentPage().getParameters().get('strNroAgenteProm');
        String StrNroEmpleadoAP=Apexpages.currentPage().getParameters().get('StrNroEmpleadoAP');
        strNroResultados=Apexpages.currentPage().getParameters().get('strNroResultadosin');
        hiddenTipoRegimen=Apexpages.currentPage().getParameters().get('strTipoRegimenin');
        hiddenAnalistaValidador=Apexpages.currentPage().getParameters().get('strAnalistaValin');
        hiddenSucursal=Apexpages.currentPage().getParameters().get('strSucursalin');
        
        hiddenImplementador=Apexpages.currentPage().getParameters().get('strImplementadorin');
        hiddenAgentePromotor=Apexpages.currentPage().getParameters().get('strPromotorin');
        strEmail=Apexpages.currentPage().getParameters().get('strEmailin');
        
        
            if(hiddenTipoServicio!=null && hiddenTipoServicio!='') {
                strtramite=hiddenTipoServicio.split(';');
            }
            
            System.debug('hiddenSucursal=====================: ' +hiddenSucursal);
            

            if(hiddenSubTipoServicio!=null && hiddenSubTipoServicio!=''){
                strSubtipo=hiddenSubTipoServicio.split(';');
            }
            if(hiddenTipoRetiro!=null && hiddenTipoRetiro!=''){
                strTipoRetiro=hiddenTipoRetiro.split(';');
            }
            if(hiddenTipoSeguro!=null && hiddenTipoSeguro!=''){
                strTipoSeguro=hiddenTipoSeguro.split(';');
            }
            if(hiddenTipoPension!=null && hiddenTipoPension!=''){
                strTipoPension=hiddenTipoPension.split(';');
            }
            if(hiddenTipoRegimen!=null && hiddenTipoRegimen!=''){
                strTipoRegimen=hiddenTipoRegimen.split(';');
            }
            if(hiddenTerritorio!=null && hiddenTerritorio!=''){
                strTerritorioG=hiddenTerritorio.split(';');
            }
            if(hiddenSucursal!=null && hiddenSucursal!=''){
                strSucursal=hiddenSucursal.split(';');
            }
            if(hiddenImplementador!=null && hiddenImplementador!=''){
                strImplementador=hiddenImplementador.split(';');
            }
            if(hiddenAnalistaValidador!=null && hiddenAnalistaValidador!=''){
                strAnalistaVal=hiddenAnalistaValidador.split(';');
            }
            if(hiddenAgentePromotor!=null && hiddenAgentePromotor!=''){
                //strAgPromotor=hiddenAnalistaValidador.split(';');
                strAgPromotor=hiddenAgentePromotor.split(';');
            }


            //llamada al servicio

            LogHistoricalProcess__c objLogHistorial=new LogHistoricalProcess__c();
            objLogHistorial.ProgrammedBy__c=strIdUsuario;
            objLogHistorial.Email__c=strEmail;
            //insert objLogHistorial;
            Database.SaveResult sr = Database.insert(objLogHistorial, true);
            if(sr.isSuccess()){
                optionConsultoHistoricoWS = true;
                HistoryWS(sr.getId(), strFechaInicio, strFechaFin, StrNss, strCurp, strRfc, strStatus2, strtramite, strSubtipo, strTipoRetiro, strTipoSeguro, strTipoPension, strTipoRegimen, strTerritorioG, strEstadoG, strMunicipio, strSucursal, strImplementador, strAgPromotor, strAnalistaVal, strNroResultados);
            }
        
      
    }
   
   @future (callout=true)
   public static void HistoryWS(String idHistory, String strFechaInicio,String strFechaFin,String StrNss,String strCurp,String strRfc,String strStatus2,
    List<String> strtramite,List<String> strSubtipo,List<String> strTipoRetiro,List<String> strTipoSeguro,List<String> strTipoPension,List<String> strTipoRegimen,List<String> strTerritorioG,List<String> strEstadoG,
    List<String> strMunicipio,List<String> strSucursal,List<String> strImplementador,List<String> strAgPromotor,List<String> strAnalistaVal,String strNroResultados ){
        AAZ_SearchHistoricalProcess_callout.SearchObject objRequest=new AAZ_SearchHistoricalProcess_callout.SearchObject();
            Boolean optionConsultoHistoricoWS = true;
            Boolean displayPopUp = false;
            String strMensaje = '';
                AAZ_SearchHistoricalProcess_callout.ResponseWrapper objResponse=new AAZ_SearchHistoricalProcess_callout.ResponseWrapper();
                objRequest.startDate=strFechaInicio; 
                objRequest.endDate =strFechaFin;
                objRequest.nss =StrNss; 
                objRequest.curp =strCurp; 
                objRequest.rfc =strRfc; 
                objRequest.status =strStatus2; 
                objRequest.serviceType =String.ValueOf(strtramite); //validar por que se esta mapeando una lista
                objRequest.serviceSubType =String.ValueOf(strSubtipo); 
                objRequest.withdrawtype =String.ValueOf(strTipoRetiro);
                objRequest.securitytype =String.ValueOf(strTipoSeguro);
                objRequest.pensiontype =String.ValueOf(strTipoPension);
                objRequest.regimeType =String.ValueOf(strTipoRegimen);
                objRequest.divisional =String.ValueOf(strTerritorioG);
                objRequest.estate =String.ValueOf(strEstadoG);
                objRequest.municipality =String.ValueOf(strMunicipio); //validar
                objRequest.regional =String.ValueOf(strSucursal);//validar
                objRequest.implement =String.ValueOf(strImplementador);
                objRequest.promoterAgent =String.ValueOf(strAgPromotor);
                objRequest.analistValidate =String.ValueOf(strAnalistaVal);
                objRequest.apNumber =strNroResultados;//validar
                //objRequest.idSearch = objLogHistorial.id; 
                objRequest.idSearch = idHistory; 
                
                system.debug('================'+objRequest);
                //displayPopUp=true;
                
                
                    optionConsultoHistoricoWS=true;
        if(Test.isRunningTest()){
            System.debug(loggingLevel.Error, '*** objResponse: ' + objResponse);
            objResponse=AAZ_SearchHistoricalProcess_callout_tst.Wresponse();
            System.debug(loggingLevel.Error, '*** objResponse: ' + objResponse);
        }else {
            objResponse=AAZ_SearchHistoricalProcess_callout.callOut(objRequest);
                System.debug(loggingLevel.Error, '*** objResponse: ' + objResponse);
        }
System.debug(loggingLevel.Error, '*** objResponse: ' + objResponse);
                

                //analiza la consulta del servicio
                if(objResponse.Out_ConsultaHistoricos.isSucessful==true)
                {
                    System.debug(loggingLevel.Error, '*** 1');
                    optionConsultoHistoricoWS=true;
                
                    List<SearchHistoricalProcess_cnf__c> cnfHistorial=[select id,name,Min_Date__c from SearchHistoricalProcess_cnf__c where name='Historial'];
                    if(cnfHistorial.size()>0)
                    {
                        System.debug(loggingLevel.Error, '*** 2');
                         cnfHistorial[0].SolicitudId__c=idHistory;
                         update cnfHistorial;
                    }else
                    {
                        System.debug(loggingLevel.Error, '*** 3');
                        SearchHistoricalProcess_cnf__c objConfig=new SearchHistoricalProcess_cnf__c();
                        objConfig.Name='Historial';
                        objConfig.SolicitudId__c=idHistory;
                        insert objConfig;
                    }
            
                }else
                {
                    displayPopUp=true;
                    strMensaje='Error WS: Señor usuario comuniquese con el administrador o intentelo de nuevo.';
           
                }

   }
    
    public PageReference Options()
    {
         Boolean rMuestra = Apexpages.currentPage().getParameters().get('rMuestraOp').equals('true') ? true: false;
         Boolean rAsig    = Apexpages.currentPage().getParameters().get('rAsigOp').equals('true') ? true: false;
         optionMuestra    =  rMuestra;
         optionAsignacion = rAsig;
         //strStatus = '';
         System.debug('Cliquei optionAsignacionM>> ' +optionMuestra+ ' optionMuestraM ' +optionAsignacion);
         return null;
    }


      
    public PageReference closePopup() {
        displayPopup = false;
        //PageReference pageRef = new PageReference('/apex/AAZ_QualitySamples_pag');
        PageReference pageRef = new PageReference('/apex/AAZ_SearchHistoricalProcess_pag');
        pageRef.setRedirect(true);
        return pageRef;
    }

    public void showPopup() {
        displayPopup = true;
    }

    public boolean hasMessages {
        get {
                return ApexPages.hasMessages();
            }
        }

    public string alertType {
             get {
                     if (hasMessages) {
                             return ApexPages.getMessages()[0].getSeverity() == ApexPages.Severity.CONFIRM ? 'success' : 'error';
                     }

                     return 'error';
             }
             private set;
     }
    //
    //  public void createError(ApexPages.Severity s, String message) {
    //       ApexPages.addMessage(
    //                       New ApexPages.Message(
    //                                       s, string.escapeSingleQuotes(message.escapeJava())
    //                       )
    //       );
    //
    //  }
    //
    //  /**@description The custom error message */
    //  public String errorMessage {
    //       get {
    //               if (hasMessages) {
    //                       return ApexPages.getMessages()[0].getDetail();
    //               }
    //
    //               return null;
    //       }
    //  }

    

    
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
            List<Contact> listimpl = [SELECT Id,Name,ImplementName__c FROM Contact
                                            where RecordTypeId =: Label.AAZ_RecortypeImplementador
                                            order by ImplementName__c asc limit 2000];
                if(listimpl.size() > 0)
                {
                    for(Contact c : listimpl){
                        implementador.add(new Selectoption(c.ID,c.Name));
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
              List<Contact> listagente = [SELECT Id,Name,ImplementName__c FROM Contact
                                            where ImplementName__c in: strImplementador
                                            order by Name asc limit 2000];
                  if(listagente.size() > 0){
                      for(Contact c : listagente){
                        agente.add(new Selectoption(c.Name,c.Name));
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
                    ListSucursal.add(new Selectoption(s.Name, s.Name));
                }
        }
            return null;
        }

    /*27/09/2017: RF: FIM METODO: PREENCHER PICKSLIST GEOGRAFIA*/
    public List<selectOption> ListDivisionalMuestra {get;set;} /*{

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
    }*/

     public List<selectOption> ListEstadoMuestra {get;set;} /*{
      get{
        System.debug('ID DIVISIONAL Muestra' + strTerritorioMuestra);
        List<selectOption> auxr = new List<selectOption>();

        if(strTerritorioMuestra == null){
           auxr.add(new Selectoption('---','---'));
        }
        else
        if(strTerritorioMuestra.size() == 1 && strTerritorioMuestra.get(0).contains('---')){
          auxr.add(new Selectoption('---','---'));
        }else
        if(strTerritorioMuestra != null){
            List<Geography__c> estado = [SELECT Id,Name,Codigo__c FROM Geography__c
                                                    WHERE State__c = true
                                                    and Padre__r.Name in: strTerritorioMuestra
                                                    order by Name asc];
          if(estado.size() > 0){
            for(Geography__c e : estado){
                auxr.add(new Selectoption(e.Name, e.Name));
            }
          }else{
           auxr.add(new Selectoption('---','---'));
          }
        }
       return auxr;
      }
      private set;
    }*/

    public List<selectOption> ListMunicipioMuestra {get;set;} /*{
      get{
        System.debug('ID ESTADO Muestra' + strEstadoMuestra);
        List<selectOption> auxr = new List<selectOption>();

        if(strEstadoMuestra == null){
           auxr.add(new Selectoption('---','---'));
        }
        else
        if(strEstadoMuestra.size() == 1 && strEstadoMuestra.get(0).contains('---')){
          auxr.add(new Selectoption('---','---'));
        }else
        if(strEstadoMuestra != null){
            List<Geography__c> municipio = [SELECT Id,Name,Codigo__c FROM Geography__c
                                                    WHERE City__c = true
                                                    and Padre__r.Name in: strEstadoMuestra
                                                order by Name asc];
          if(municipio.size() > 0){
            for(Geography__c m : municipio){
                auxr.add(new Selectoption(m.Name, m.Name));
            }
          }else{
            auxr.add(new Selectoption('---','---'));
          }
        }
       return auxr;
      }
      private set;
    }*/

    public List<selectOption> ListSucursalMuestra {get;set;} /*{
       get{
        System.debug('ID MUNICIPIO Muestra' + strMunicipioMuestra);
        List<selectOption> auxr = new List<selectOption>();

        if(strMunicipioMuestra == null){
           auxr.add(new Selectoption('---','---'));
        }
        else
        if(strMunicipioMuestra.size() == 1 && strMunicipioMuestra.get(0).contains('---')){
          auxr.add(new Selectoption('---','---'));
        }else
        if(strMunicipioMuestra != null){
            List<Geography__c> surcusal = [SELECT Id,Name,Codigo__c FROM Geography__c
                                                    WHERE Subsidiary__c = true
                                                    and Padre__r.Name in: strMunicipioMuestra
                                                    order by Name asc];
          if(surcusal.size() > 0){
              for(Geography__c s : surcusal){
                auxr.add(new Selectoption(s.Name, s.Name));
              }
          }else{
           auxr.add(new Selectoption('---','---'));
          }
        }
       return auxr;
      }
      private set;
    }*/

    
    
    
    /////////////////////////////////////////////////////   PAGINACION /////////////////////////////////////////////////////
    

   public void getCasos() 
   {
      try
      {
         //consultar los casos para esta solicitud strSolicitud
         lstCase=[select id,FolioNSS__c,Account.NSS__c,Account.Name,Type,SubType__c,CreatedDate,ClosedDate,SubSubType__c from case  limit :list_size offset :counter] ;
        

      } catch (QueryException e) {
         ApexPages.addMessages(e);  
         
      }
   }

   public PageReference Beginning() { //user clicked beginning
      counter = 0;
      getCasos();
      return null;
   }

   public PageReference Previous() 
   { //user clicked previous button
      
      counter -= list_size;
      getCasos();
      return null;
   }
 
   public PageReference Next() { //user clicked next button
      
      counter += list_size;
      getCasos();
      return null;
   }

   public PageReference End() { //user clicked end
      counter = total_size - math.mod(total_size, list_size);
      getCasos();
      return null;
   }
   public Boolean getDisablePrevious() {
      //this will disable the previous and beginning buttons
      if (counter>0) return false; else return true;
   }
   public Boolean getDisableNext() { //this will disable the next and end buttons
      if (counter + list_size < total_size) return false; else return true;
   }
   public Integer getTotal_size() {
      return total_size;
   }
   public Integer getPageNumber() {
      if(total_size==0)return 0;
      return counter/list_size + 1;
     
   }
   public Integer getTotalPages() {
     
     if (math.mod(total_size, list_size) > 0) {
         return total_size/list_size + 1;
      } else {
         return (total_size/list_size);
      }
      
   }
    
    
    
    
    
}