/****************************************************************************************
	Desarrollado por:  Avanxo México
	Autor:             René Ayala Medina
	Proyecto:          Mesa de Control Afore Azteca
	Descripción:       Clase de APEX que se utiliza para procesar la solicitud recibida en el servicio de "Alta de Agente Promotor"
	Cambios (Versiones)     
	-------------------------------------     
	  No.      Fecha                  Autor                      Descripción     
	------  -------------  ------------------------------   ----------------------    
	 1.0      01-08-2017    René Ayala Medina RAM            Creacion
****************************************************************************************/

global class AAZ_NewPromoterAgentAux_cls {
	
	global static Contact promoterCreation(AAZ_NewPromoterAgentRequest_wpr.NewAgent NewPromoterAgent_In){
		Map<String,Map<String,RecordType>> mapRTsByDevName =  AAZ_Utils_cls.getRecordTypes('DeveloperName');
		Contact promoterAgent = new Contact  (
			EmployeeNumber__c = NewPromoterAgent_In.employeeNumber,
			NSS__c = NewPromoterAgent_In.nss,
			FirstName = NewPromoterAgent_In.firstName,
			LastName = (NewPromoterAgent_In.paternalLastName != null && NewPromoterAgent_In.paternalLastName != '' && NewPromoterAgent_In.paternalLastName != ' ')?(NewPromoterAgent_In.maternalLastName != null && NewPromoterAgent_In.maternalLastName != '' && NewPromoterAgent_In.maternalLastName != ' ')?NewPromoterAgent_In.paternalLastName+' '+NewPromoterAgent_In.maternalLastName:NewPromoterAgent_In.paternalLastName:'No especificado',
			PaternalLastName__c = NewPromoterAgent_In.paternalLastName,
			MaternalLastName__c =  NewPromoterAgent_In.maternalLastName,
			AdmitionDate__c =	NewPromoterAgent_In.admitionDate,
			LevelStudy__c = NewPromoterAgent_In.schoolGrade,
			Birthdate = NewPromoterAgent_In.birthDate,
			ShopNumber__c = NewPromoterAgent_In.shopNumber,
			ShopName__c = NewPromoterAgent_In.shopName,
			Zone__c = NewPromoterAgent_In.zone,
			State__c = NewPromoterAgent_In.state
		);
		SObjectField f = Contact.EmployeeNumber__c;
		Database.upsert(promoterAgent,f,true);
		
        Case caseInstance = new Case(
		EmployeeNumber__c = NewPromoterAgent_In.employeeNumber,
		Description = 'Validación de agente promotor',
		Origin = 'Sistemas Afore Azteca',
		APValidationContact__c = promoterAgent.Id,
		Status = 'En Validacion',
		Subject = 'Validación Agente Promotor',
		idServiceType__c = '4',
	 //Si el estatus es en validacion se crea el caso
		RecordTypeId = (mapRTsByDevName.get('Case').containsKey('AgentPromotionVerification'))?mapRTsByDevName.get('Case').get('AgentPromotionVerification').Id:null
		);
		Database.insert(caseInstance,true);
		System.debug(loggingLevel.Error, '*** caseInstance: ' + caseInstance);
		return promoterAgent;
	}

}