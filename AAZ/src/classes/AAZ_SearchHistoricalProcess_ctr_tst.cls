/*******************************************************************************
Desarrollado por: Avanxo México
Autor: William Dorado

-------------------------------------
No.    Fecha      Autor                          Descripción
------ ---------- ----------------------------- -----------
1.0    28-10-2017 william dorado               Creación
*******************************************************************************/
@isTest private class AAZ_SearchHistoricalProcess_ctr_tst {
    @TestSetup static void setup() {

    List<SObject> lstSObjects = new List<SObject>();
    
        
        Case parentCase = new Case (
          Status = 'Nueva',
            Origin = 'Phone',
            employeeNumber__c = '33234',
            SubType__c = 'Subtype B'
        );

        lstSObjects.add ( parentCase );

        insert lstSObjects;

        lstSObjects = new List<SObject>();

        Case caseOne = new Case(
            Status = 'Nueva',
            Origin = 'Phone',
            employeeNumber__c = '11233',
            ParentId = parentCase.Id,
            NumberOfPrints__c = 1,
            Type =  'Afiliación',
            SubType__c = 'Traspaso'   
        );
        
        lstSObjects.add ( caseOne );

        Case caseTwo = new Case(
            Status = 'Nueva',
            Origin = 'Phone',
            employeeNumber__c = '11233',
            ParentId = parentCase.Id,
            NumberOfPrints__c = 2,
            Type =  'Retiros Parciales',
            SubType__c = 'Retiros Parciales'  
        );
        
        lstSObjects.add ( caseTwo );

        insert lstSObjects;
        
        SearchHistoricalProcess_cnf__c objConfig=new SearchHistoricalProcess_cnf__c();
        objConfig.Name='Historial';
        objConfig.SolicitudId__c='';
        insert objConfig;

  }
    @isTest static void methodOne(){
                
        Test.startTest();
        
        AAZ_SearchHistoricalProcess_ctr objControl=new AAZ_SearchHistoricalProcess_ctr();
        objControl.getNtot();
        objControl.getNini();
        objControl.getnfim();
        objControl.verdatos();
        
        objControl.verconsulta();
        objControl.busqueda();
        ApexPages.currentPage().getParameters().put('rMuestraOp', 'true'); 
        ApexPages.currentPage().getParameters().put('rAsigOp', 'true'); 
        ApexPages.currentPage().getParameters().put('hiddenImplementador', 'true'); 
        ApexPages.currentPage().getParameters().put('hiddenTipoRetiro', 'true'); 
        ApexPages.currentPage().getParameters().put('hiddenTipoSeguro', 'true'); 
        ApexPages.currentPage().getParameters().put('hiddenTipoPension', 'true'); 
        ApexPages.currentPage().getParameters().put('hiddenTerritorio', 'true'); 
        ApexPages.currentPage().getParameters().put('hiddenEstadoG', 'true'); 
        ApexPages.currentPage().getParameters().put('hiddenMunicipio', 'true'); 
        ApexPages.currentPage().getParameters().put('hiddenTipoServicio', 'true'); 
        
        
        ApexPages.currentPage().getParameters().put('hiddenSubTipoServicio', 'true'); 
        
        
        
        
        
        
        objControl.Options();
        
        
        objControl.closePopup();
        objControl.showPopup();
        Boolean v1=objControl.hasMessages;
        String vars='';
        vars=objControl.alertType;
        //objControl.alertType='';
        List<selectOption> l1=objControl.ListNumeroEmpleado;
        
        List<selectOption> lst1=objControl.ListNumeroAP;
        lst1= objControl.ListNombreAP;
        lst1=objControl.ListImplemtador;
        
        //objControl.listimpl();
        objControl.getAgentePromotor();
        objControl.getAgentep();
        
        
        lst1= objControl.ListAnalista;
        lst1= objControl.ListAgenteValidador;
        lst1= objControl.ListSeviceType;
        
        
        lst1= objControl.ListSubService;
        lst1= objControl.ListSeguro;
        objControl.getListSeguro();
        
        objControl.getTipoPension();
        lst1= objControl.ListSucursal;
        objControl.getSucursales();
        
        lst1= objControl.ListDivisionalMuestra;
        lst1= objControl.ListEstadoMuestra;
        lst1= objControl.ListMunicipioMuestra;
        
        objControl.getCasos();
        objControl.Beginning();
        objControl.Previous();
        
        objControl.Next();
        objControl.End();
        objControl.getDisablePrevious();
                
        
        objControl.getDisableNext();
        objControl.getTotal_size();
        objControl.getPageNumber();
        objControl.getTotalPages();
            
        List<String> ls=new List<String>();
        ls.Add('hola');
        objControl.strProrcentaje =ls[0];
        objControl.strNroResultados =ls[0];
        objControl.strDivisional =ls[0];
        //fields page muestra option
        objControl.strnumempleadoMuestra=ls;
        objControl.strnumapMuestra=ls;
        objControl.strnombreapMuestra=ls;
        objControl.strStatusMuestra=ls[0];
        objControl.strTerritorioMuestra =ls;
        objControl.strEstadoMuestra  =ls;
        objControl.strMunicipioMuestra =ls;
        objControl.strSucursalMuestra =ls;
        objControl.strImplementadorMuestra =ls;
        objControl.strAnalistaValMuestra =ls;

        
        objControl.strRegion=ls[0];
        objControl.hiddenEstadoG=ls[0];
        objControl.strIDUserValidador=ls;
        objControl.strIDColas=ls;
        objControl.DisableNext=true;
        objControl.DisablePrevious=true;
        objControl.DisableAsignar=true;
        objControl.strIDUser =ls[0];
        objControl.strNombreBuscar =ls[0];
        objControl.habilita=true;
        objControl.strMensaje =ls[0];
        lst1= objControl.ListSubService;
        objControl.getListSubservice();
        lst1= objControl.ListTypeRetiro;
        objControl.getTypeRetiro();
        lst1= objControl.ListRegime;
        objControl.getRegimen();
        lst1= objControl.ListDivisional;
        lst1= objControl.ListEstado;
        objControl.getEstado();
        lst1= objControl.ListMunicipio;
        objControl.getMunicipio();
        
        LogHistoricalProcess__c obj=new LogHistoricalProcess__c();
        
        obj.Status__c='EN PROCESO';
        obj.Email__c='H@GMAI.COM';
        obj.ProgrammedBy__c=UserInfo.getUserId();
        insert obj;
        
        AAZ_SearchHistoricalProcess_ctr objControl2=new AAZ_SearchHistoricalProcess_ctr();
    
    
        
        
        
        Test.stopTest();
    }

}