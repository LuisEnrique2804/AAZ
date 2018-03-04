/****************************************************************************************
	Desarrollado por:  Avanxo México
	Autor:             René Ayala Medina
	Proyecto:          Mesa de Control Afore Azteca
	Descripción:       Servicio Web para dar de alta un trámite
	Cambios (Versiones)
	-------------------------------------
	  No.      Fecha                  Autor                      Descripción
	------  -------------  ------------------------------   ----------------------
	 1.0    28-07-2017     René Ayala Medina RAM             Creacion
****************************************************************************************/

@RestResource(urlMapping = '/NewProcedure/*')
global class AAZ_NewProcedure_ws {

	@HttpPost
	global static String newProcedure(AAZ_RequestNewProcedure_wpr.ProcedureData NewProcedure_In){
		SavePoint sp = Database.setSavePoint();
		System.debug('\n\n NewProcedure_In '+NewProcedure_In+'\n\n');
		AAZ_ResponseNewProcedure_wpr strResponse = new AAZ_ResponseNewProcedure_wpr();
		String strException = 'Hubo una excepción al intentar realizar la operación. ';
		Boolean blnIsSuccessful = true;
		String strExceptionCode = '0';
		AAZ_NewProcedureAux_cls.ProcedureAndRelatedWrapp procedureAndRelatedsInstance = new AAZ_NewProcedureAux_cls.ProcedureAndRelatedWrapp();
		System.debug(loggingLevel.Error, '*** NewProcedure_In: ' + NewProcedure_In);
		try{
			procedureAndRelatedsInstance = AAZ_NewProcedureAux_cls.saveRecords(NewProcedure_In);
		}catch(TypeException tE){
				strException += tE.getMessage(); blnIsSuccessful = false; strExceptionCode = '3';}catch(NullPointerException nPE){strException += nPE.getMessage(); blnIsSuccessful = false; strExceptionCode = '3';}catch(DmlException dmlE){strException += dmlE.getMessage(); blnIsSuccessful = false; strExceptionCode = '1';}catch(Exception gE){strException += gE.getMessage(); blnIsSuccessful = false; strExceptionCode = '0';
			}
		strResponse.isSuccessful = blnIsSuccessful;
		strResponse.transactionId = 'MControlNewProcedure-'+Date.today().year()+'-'+Date.today().month()+'-'+Date.today().day()+' '+Datetime.now().hour()+':'+Datetime.now().minute()+':'+Datetime.now().second();
		System.debug('\n\n NewProcedure_In '+NewProcedure_In+'\n\n');
		if(!blnIsSuccessful){
			Database.rollback(sp);
			strResponse.errorList = new List<AAZ_ResponseNewProcedure_wpr.Error>();
			AAZ_ResponseNewProcedure_wpr.Error errorInstance = new AAZ_ResponseNewProcedure_wpr.Error();
			errorInstance.code = strExceptionCode;
			errorInstance.description = strException;
			strResponse.errorList.add(errorInstance);
		}else{
			if(procedureAndRelatedsInstance.caseInst.Id != null){
				String strCaseNumber = [SELECT CaseNumber FROM Case WHERE Id =: procedureAndRelatedsInstance.caseInst.Id].CaseNumber;
				strResponse.result = 'El trámite/validación/caso ha sido dado de alta -exitosamente- con el número : '+strCaseNumber;
				System.debug(loggingLevel.Error, '*** strResponse: ' + strResponse);
			}
		}
		Map<String,Object> mapResponse = new Map<String,Object>{
			'NewProcedure_Out' => strResponse
		};
		String strResponseString = JSON.serializePretty(mapResponse);
		AppMainSetting_cs__c mainSettings = AppMainSetting_cs__c.getOrgDefaults();
		return strResponseString;
	}

}