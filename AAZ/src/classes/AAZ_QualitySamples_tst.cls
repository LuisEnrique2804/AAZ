/*******************************************************************************
Desarrollado por: Avanxo México
Autor: Samuel Galindo
Proyecto: Afore Azteca
Descripción: Clase pruebas para la clase AAZ_QualitySamples_ctr
-------------------------------------
No.    Fecha      Autor                          Descripción
------ ---------- ----------------------------- -----------
1.2    03-11-2017 Samuel Galindo                 Modificación
*******************************************************************************/
@isTest
private class AAZ_QualitySamples_tst {

		@TestSetup static void setup() {
				Contact conSupervisor = new Contact(
						LastName = 'Supervisor',
						ImplementName__c = 'test'
				);
				insert conSupervisor;

				List<SObject> lstSObjects = new List<SObject>();
				Id idThisUserProfile = UserInfo.getProfileId();

				User thisUser = new User(
						Alias             = 'usrtest',
						Email             = 'email@email.com',
						EmailEncodingKey  = 'UTF-8',
						LastName          = 'userLastName',
						LanguageLocaleKey = 'es_MX',
						LocaleSidKey      = 'es_MX',
						ProfileId         = idThisUserProfile,
						TimeZoneSidKey    = 'America/Mexico_City',
						UserName          = 'testazteca@azteca.com',
						EmployeeNumber	  = '555115'
				);
				lstSObjects.add ( thisUser );

				Account thisAccount = new Account (
						LastName = 'TESTE X',
						NSS__c = '210792591',
						RFC__c = 'testezxd',
						RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cuenta personal').getRecordTypeId(),
						Type = 'Analyst',
						CURP__c = '0987654321'
				);
				lstSObjects.add ( thisAccount );

				Contact thisContact = new Contact(
						LastName = 'Contact Lastname',
						PromoterAgentNumber__c = '210792591',
						EmployeeNumber__c = '210792591',
						ImplementName__c = 'test',
						ReportsToId = conSupervisor.Id
				);
				lstSObjects.add ( thisContact );
				insert lstSObjects;

				Case thisCase = new Case(
						Subject = 'Prueba',
						employeeNumber__c='teste',
						ContactId = thisContact.Id,
						AccountId = thisAccount.Id,
						OwnerId = thisUser.Id,
						FolioNss__c = '1234567890',
						territorialSF__c = 'Sul',
						Status = 'Nuevo',
						Type = 'Afiliación',
						SubType__c = 'Afore',
						NewWithdrawType__c = 'test',
						NewSecurityType__c = 'test',
						NewPensionType__c = 'test',
						RegimeType__c = 'test',
						sucursalEconomicNumber__c = '1234567'
				);
				insert thisCase;
		}

		@isTest static void testMethodOne(){

				List<Case> lstCases = [ SELECT Id, Owner_EmployeeNumber__c, createdDate FROM Case  WHERE employeenumber__c='teste'];
				User objUser = [SELECT Id, Name, EmployeeNumber FROM User WHERE LastName='userLastName'];
				System.debug('User es =' +objUser);
				Contact objCon = [SELECT Id, Name, LastName FROM Contact WHERE PromoterAgentNumber__c = '210792591'];
				System.debug('Caso es =' +lstCases);
				String strContactName = [ SELECT Name FROM Contact LIMIT 1].Name;
				DateTime dT = lstCases[0].createdDate;
				Date myDate = date.newinstance(dT.year(), dT.month(), dT.day());

				String strOwnerName = [ SELECT Name FROM User LIMIT 1].Name;
				PageReference pageRef = Page.AAZ_QualitySamples_pag;
				pageRef.getParameters().put('strFechaInicio',String.valueOf(myDate));
				pageRef.getParameters().put('strStatus2','Nuevo' );
				pageRef.getParameters().put('strRfc','testezxd' );
				pageRef.getParameters().put('strFechaFin',String.valueOf(myDate) );
				pageRef.getParameters().put('strNss','210792591' );
				pageRef.getParameters().put('strCurp','0987654321' );
				pageRef.getParameters().put('strNroAgenteProm','210792591' );
				pageRef.getParameters().put('StrNroEmpleadoAP','210792591' );
				pageRef.getParameters().put('strNroAnVal','555115' );

				Test.startTest();
						Test.setCurrentPage(pageRef);
						AAZ_QualitySamples_ctr controller = new AAZ_QualitySamples_ctr();

						controller.strNss = '210792591';
						controller.strCurp = '0987654321';
						controller.strRfc = 'abcdef';
						controller.strStatus2 = 'Nuevo';
						controller.strtramite = new List<String>{'test'};
						controller.strSubtipo = new List<String>{''};
						controller.strTipoRetiro = new List<String>{'test'};
						controller.strTipoSeguro = new List<String>{'test'};
						controller.strTipoPension = new List<String>{'test'};
						controller.strTipoRegimen = new List<String>{'test'};
						controller.strSucursal = new List<String>{'12345657'};
						controller.strTerritorioG = new List<String>{'Sul'};

						controller.strnumempleadoMuestra = new String []{'210792591'};
						controller.strnumapMuestra = new String []{'210792591'};
						controller.strnombreapMuestra = new String []{'1234567'};
						controller.strTerritorioMuestra = new List<String>{'Sul'};
						controller.strImplementadorMuestra = new List<String>{'test'};
						controller.strAnalistaValMuestra= new List<String>{strOwnerName};

						controller.strRegion = 'Sul';
						controller.strFechaInicio = 'T00:00:00Z';
						controller.strFechaFin = 'T00:00:00Z';
						controller.strDivisional = 'Division';
						controller.strStatusMuestra = 'strStatusMuestra';
						controller.strIDUser = UserInfo.getUserId();
						controller.DisableAsignar = true;
						controller.displayPopup  = true;
						controller.DisableNext = true;
						controller.DisablePrevious  = true;
						controller.habilita  = true;
						controller.RegistrosporPaginaInt = 1;
						controller.TotalRegistros = 1;
						controller.hiddenTipoServicio='Afiliación';
						controller.hiddenSubTipoServicio='Afore';
						controller.hiddenTipoRetiro='test';
						controller.hiddenTipoSeguro='test';
						controller.hiddenTipoPension='test';
						controller.hiddenTipoRegimen='test';
						controller.hiddenTerritorio='Sul';
						controller.hiddenSucursal='1234567';
						controller.hiddenImplementador='test';
						controller.hiddenAnalistaValidador= strOwnerName;
						controller.hiddenAgentePromotor= strContactName;
						controller.strEstadoG = new List<String>{'São Paulo'};
						controller.strEstadoMuestra = new List<String>{'São Paulo'};
						controller.strMunicipio = new List<String>{'São Paulo'};
						controller.strMunicipioMuestra = new List<String>{'São Paulo'};
						controller.strSucursalMuestra = new List<String>{'test'};
						controller.strImplementador = new List<String>{'test'};
						controller.strAnalistaVal = new List<String>{'test'};
						controller.strAgPromotor = new List<String>{'test'};
						controller.strIDUserValidador = new List<String>{'test'};
						controller.strIDColas = new List<String>{'test'};
						controller.strIDColas = new List<String>{'test'};
						controller.strNroResultados = '1';
						controller.busqueda();
						AAZ_QualitySamples_ctr.wrapperQuality wrp=new AAZ_QualitySamples_ctr.wrapperQuality(lstCases[0]);
						controller.lstwrapPaginacao =new List<AAZ_QualitySamples_ctr.wrapperQuality>();
						controller.lstwrapPaginacao.add(wrp);
						// controller.lstwrapPaginacao =new List<AAZ_QualitySamples_ctr.wrapperQuality>();

						controller.Inicio=0;
						controller.getSelected();
						// controller.Previous();
						controller.PreviousAsingar();
						controller.Next();
						controller.NexAsignar();
						controller.closePopup();
						controller.showPopup();
						controller.save();
						List<String> mapKeySet=new List<String>();
						controller.quoteKeySet(mapKeySet);
						List<selectOption> lstEm=controller.ListNumeroEmpleado;
						List<selectOption> lstEm2=controller.ListNumeroAP;
						List<selectOption> lstEm3=controller.ListNombreAP;
						List<selectOption> lstEm4=controller.ListAnalista;
						List<selectOption> lstEm5=controller.ListAgenteValidador;
						List<selectOption> lstEm6=controller.ListSeviceType;

						KindOfProcedure__c kop1=new KindOfProcedure__c();
						kop1.Name='test';
						kop1.SeviceType__c=true;
						insert kop1;
						List<selectOption> lstEm7=controller.ListSeviceType;
						Apexpages.currentPage().getParameters().put('hiddenTipoServicio','val');
						controller.getListSubservice();
						KindOfProcedure__c kop2=new KindOfProcedure__c();
						kop2.Name='test';
						kop2.ServiceSubType__c=true;
						kop2.Father__c=kop1.id;
						insert kop2;
						Apexpages.currentPage().getParameters().put('hiddenTipoServicio','test');
						controller.getListSubservice();

						Apexpages.currentPage().getParameters().put('hiddenSubTipoServicio','test');
						controller.getTypeRetiro();

						KindOfProcedure__c kop3=new KindOfProcedure__c();
						kop3.Name='test';
						kop3.RetirementType__c=true;
						kop3.Father__c=kop2.id;
						insert kop3;
						Apexpages.currentPage().getParameters().put('hiddenSubTipoServicio','test');
						controller.getTypeRetiro();

						Apexpages.currentPage().getParameters().put('hiddenTipoRetiro','test');
						controller.getListSeguro();

						KindOfProcedure__c kop4=new KindOfProcedure__c();
						kop4.Name='test';
						kop4.InsuranceType__c=true;
						kop4.Father__c=kop3.id;
						insert kop4;
						Apexpages.currentPage().getParameters().put('hiddenTipoRetiro','test');
						controller.getListSeguro();

						Apexpages.currentPage().getParameters().put('hiddenTipoSeguro','test');
						controller.getTipoPension();
						KindOfProcedure__c kop5=new KindOfProcedure__c();
						kop5.Name='test';
						kop5.PensionType__c=true;
						kop5.Father__c=kop4.id;
						insert kop5;
						Apexpages.currentPage().getParameters().put('hiddenTipoSeguro','test');
						controller.getTipoPension();

						Apexpages.currentPage().getParameters().put('hiddenTipoPension','test');
						controller.getRegimen();
						KindOfProcedure__c kop6=new KindOfProcedure__c();
						kop6.Name='test';
						kop6.GovermmentType__c=true;
						kop6.Father__c=kop5.id;
						insert kop6;
						Apexpages.currentPage().getParameters().put('hiddenTipoPension','test');
						controller.getRegimen();

						List<selectOption> lstdiv=controller.ListDivisional;
						Geography__c geo1=new Geography__c();
						geo1.Name='Test';
						geo1.Divisional__c=true;
						insert geo1;
						List<selectOption> lstdiv2=controller.ListDivisional;

						Apexpages.currentPage().getParameters().put('hiddenTerritorio','Test');
						controller.getEstado();
						Geography__c geo2=new Geography__c();
						geo2.Name='Test';
						geo2.State__c=true;
						geo2.Padre__c=geo1.id;
						insert geo2;
						controller.getEstado();

						Apexpages.currentPage().getParameters().put('hiddenEstadoG','Test');
						controller.getMunicipio();
						Geography__c geo3=new Geography__c();
						geo3.Name='Test';
						geo3.City__c=true;
						geo3.Padre__c=geo2.id;
						insert geo3;
						controller.getMunicipio();

						Apexpages.currentPage().getParameters().put('hiddenMunicipio','Test');
						controller.getSucursales();
						Geography__c geo4=new Geography__c();
						geo4.Name='Test';
						geo4.Subsidiary__c=true;
						geo4.Padre__c=geo3.id;
						insert geo4;
						controller.getSucursales();

				Test.stopTest();
		}

		public static testmethod void testMethodTwo(){

				List<Case> lstCases = [ SELECT Id FROM Case ];
				String strContactName = [ SELECT Name FROM Contact LIMIT 1].Name;
				String strOwnerName = [ SELECT Name FROM User LIMIT 1].Name;

				Test.startTest();

						AAZ_QualitySamples_ctr controller = new AAZ_QualitySamples_ctr();

						controller.strNss = '210792591';
						controller.strCurp = '0987654321';
						controller.strRfc = 'testezxd';
						controller.strStatus2 = 'Nuevo';
						controller.strtramite = new List<String>{'test'};
						controller.strSubtipo = new List<String>{''};
						controller.strTipoRetiro = new List<String>{'test'};
						controller.strTipoSeguro = new List<String>{'test'};
						controller.strTipoPension = new List<String>{'test'};
						controller.strTipoRegimen = new List<String>{'test'};
						controller.strSucursal = new List<String>{'12345657'};
						controller.strTerritorioG = new List<String>{'Sul'};

						controller.strnumempleadoMuestra = new String []{'210792591'};
						controller.strnumapMuestra = new String []{'210792591'};
						controller.strnombreapMuestra = new String []{'1234567'};
						controller.strTerritorioMuestra = new List<String>{'Sul'};
						controller.strImplementadorMuestra = new List<String>{'test'};
						controller.strAnalistaValMuestra= new List<String>{strOwnerName};

						controller.strRegion = 'Sul';
						controller.strFechaInicio = 'T00:00:00Z';
						controller.strFechaFin = 'T00:00:00Z';
						controller.strDivisional = 'Division';
						controller.strStatusMuestra = 'strStatusMuestra';
						controller.strIDUser = UserInfo.getUserId();

						controller.DisableAsignar = true;
						controller.displayPopup  = true;

						controller.DisableNext = true;
						controller.DisablePrevious  = true;

						controller.habilita  = true;

						controller.RegistrosporPaginaInt = 1;
						controller.TotalRegistros = 1;

						controller.strEstadoG = new List<String>{'São Paulo'};
						controller.strEstadoMuestra = new List<String>{'São Paulo'};
						controller.strMunicipio = new List<String>{'São Paulo'};
						controller.strMunicipioMuestra = new List<String>{'São Paulo'};
						controller.strSucursalMuestra = new List<String>{'test'};
						controller.strImplementador = new List<String>{'test'};
						controller.strAnalistaVal = new List<String>{'test'};
						controller.strAgPromotor = new List<String>{'test'};
						controller.strIDUserValidador = new List<String>{'test'};
						controller.strIDColas = new List<String>{'test'};
						controller.strIDColas = new List<String>{'test'};
						controller.strNroResultados = '99';

						PageReference pageRef = Page.AAZ_QualitySamples_pag;
						pageRef.getParameters().put('rAsig', 'false');
						pageRef.getParameters().put('rMuestra', 'false');
						pageRef.getParameters().put('hiddenImplementador', 'test');
						Test.setCurrentPage(pageRef);

						controller.getAgentePromotor();
						controller.getNtot();
						controller.getNini();
						controller.getnfim();

				Test.stopTest();
		}
}