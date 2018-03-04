/****************************************************************************************
	Desarrollado por:  Avanxo México
	Autor:             René Ayala Medina
	Proyecto:          Mesa de Control Afore Azteca
	Descripción:       Servicio Web para dar de alta un agente promotor
	Cambios (Versiones)     
	-------------------------------------     
	  No.      Fecha                  Autor                      Descripción     
	------  -------------  ------------------------------   ----------------------    
	 1.0      01-08-2017    René Ayala Medina RAM            Creacion
****************************************************************************************/

@RestResource(urlMapping = '/NewPromoterAgent/*')
global class AAZ_NewPromoterAgent_ws {
	
	@HttpPost
	global static String newPromoterAgent(AAZ_NewPromoterAgentRequest_wpr.NewAgent NewPromoterAgent_In){ 
		AAZ_NewPromoterAgentResponse_wpr strResponse = new AAZ_NewPromoterAgentResponse_wpr();
		Boolean blnWasThereAnException = false;
		String strException = 'Hubo una excepción al intentar realizar la operación. ';
		Boolean blnIsSuccessful = true;
		String strExceptionCode = '0';
		Contact contact = new Contact();
		SavePoint sp = Database.setSavePoint();
		try{contact = AAZ_NewPromoterAgentAux_cls.promoterCreation(NewPromoterAgent_In);}catch(TypeException tE){strException += tE.getMessage(); blnIsSuccessful = false; strExceptionCode = '3';}catch(NullPointerException nPE){strException += nPE.getMessage(); blnIsSuccessful = false; strExceptionCode = '3';}catch(DmlException dmlE){strException += dmlE.getMessage(); blnIsSuccessful = false; strExceptionCode = '1';}catch(Exception gE){strException += gE.getMessage(); blnIsSuccessful = false; strExceptionCode = '0';}
		strResponse.isSuccessful = blnIsSuccessful;	
		strResponse.transactionId = 'MControlNewPromoterAgent-'+Date.today().year()+'-'+Date.today().month()+'-'+Date.today().day()+' '+Datetime.now().hour()+':'+Datetime.now().minute()+':'+Datetime.now().second();		
		if(!blnIsSuccessful){
			Database.rollback(sp);
			strResponse.errorList = new List<AAZ_NewPromoterAgentResponse_wpr.Error>();
			AAZ_NewPromoterAgentResponse_wpr.Error errorInstance = new AAZ_NewPromoterAgentResponse_wpr.Error();
			errorInstance.code = strExceptionCode;
			errorInstance.description = strException;
			strResponse.errorList.add(errorInstance);
		}else{
			if(contact.Id != null){
				strResponse.result = 'Transacción exitosa: El agente promotor fue dado de alta con Id = \''+contact.Id+'\'';
				System.debug(loggingLevel.Error, '***Transacción exitosa: El agente promotor fue dado de alta con Id:' + contact.Id);
			}
		}
		Map<String,Object> mapResponse = new Map<String,Object>{
			'NewPromoterAgent_Out' => strResponse
		};
		String strResponseString = JSON.serializePretty(mapResponse);
		AppMainSetting_cs__c mainSettings = AppMainSetting_cs__c.getOrgDefaults();
		return strResponseString;   
	}

}