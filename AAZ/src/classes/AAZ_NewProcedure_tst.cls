/*******************************************************************************
Desarrollado por: Avanxo México
Correo: ineria@avanxo.com
Autor: Iván Neria
Proyecto: Afore Azteca
Descripción: Clase de prueba para los servicios web de la clase 'AAZ_NewProcedure_ws'

------ ---------- -------------------------- -----------------------------------
No.    Fecha      Autor                      Descripción
------ ---------- -------------------------- -----------------------------------
1.0    04/10/2017 Iván Neria                 Clase creada
1.2    08/11/2017 Samuel Galindo             Modificación
*******************************************************************************/
@isTest
private class AAZ_NewProcedure_tst {

		@isTest static void testNewProcedure(){
				RestRequest req = new RestRequest();
				RestResponse res = new RestResponse();
				AAZ_RequestNewProcedure_wpr.ProcedureData NewProcedure_In = new AAZ_RequestNewProcedure_wpr.ProcedureData();

				NewProcedure_In.pointDigitalSingnature= 12345;
				NewProcedure_In.requestDate='Date';
				NewProcedure_In.origin='origin';
				NewProcedure_In.employeeNumber='33333';
				NewProcedure_In.status='New';
				NewProcedure_In.serviceType='Service';
				NewProcedure_In.isUpdate=True;
				NewProcedure_In.deadLineDate=Date.newInstance(2000, 5, 5) ;
				NewProcedure_In.pointRiskLevel= 1122;
				NewProcedure_In.folio='folio';
				NewProcedure_In.maxPointRiskLevel=1;
				NewProcedure_In.pointBioSingnature=1;
				NewProcedure_In.pointAutentification=1;
				NewProcedure_In.maxPointDigitalSingnature=1;
				NewProcedure_In.maxPointBioSingnature=12345;
				NewProcedure_In.maxPointAutentification=123;
				NewProcedure_In.salesman='Salesman';
				NewProcedure_In.regionalName='Region';
				NewProcedure_In.regimeType='Regimen';
				NewProcedure_In.phoneSalesman='3344555';
				NewProcedure_In.phoneRegional='556677';
				NewProcedure_In.pensionDate=Date.newInstance(2000, 5, 5);
				NewProcedure_In.employeeNumberSalesman='7802';
				NewProcedure_In.employeeNumberRegional='7809';
				NewProcedure_In.economyNumberSalesman='1234';
				NewProcedure_In.numberPrints=23;
				NewProcedure_In.subsidiary='3';
				/*
				NewProcedure_In.idRegimeType='12';
				NewProcedure_In.idWithdrawtype='13';
				NewProcedure_In.idPensiontype='14';
				NewProcedure_In.idSecuritytype='15';
				NewProcedure_In.idBenefitType='16';
				*/
				NewProcedure_In.procedureIsBeneficary=true;
				NewProcedure_In.processFingerIssue=true;
				NewProcedure_In.state='CA';
				NewProcedure_In.phoneCallPerformed=true;
				NewProcedure_In.hadBeenProcecesd=true;
				NewProcedure_In.candidate='Candidate';
				NewProcedure_In.SarTicket1='Ticket1';
				NewProcedure_In.SarTicket2='Ticket2';
				NewProcedure_In.pensiontype='PensionType';

				Case cas = new Case(
						Subject = 'Prueba',
						employeeNumber__c='teste'
				);
				insert cas;

				AAZ_NewProcedureAux_cls.ProcedureAndRelatedWrapp procedureAndRelatedsInstance = new AAZ_NewProcedureAux_cls.ProcedureAndRelatedWrapp();
				procedureAndRelatedsInstance.caseInst= cas;

				Test.startTest();
						AAZ_NewProcedure_ws.newProcedure(NewProcedure_In);
				Test.stopTest();
		}
}