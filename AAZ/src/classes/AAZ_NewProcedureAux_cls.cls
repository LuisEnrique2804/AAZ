/****************************************************************************************
	Desarrollado por:  Avanxo México
	Autor:             René Ayala Medina
	Proyecto:          Mesa de Control Afore Azteca
	Descripción:       Clase de APEX que se utiliza para procesar la solicitud recibida en el servicio de "Alta de Trámite"
	Cambios (Versiones)
	-------------------------------------
	  No.      Fecha                  Autor                      Descripción
	------  -------------  ------------------------------   ----------------------
	 1.0    28-07-2017     René Ayala Medina RAM             Creacion
****************************************************************************************/


global class AAZ_NewProcedureAux_cls {

	global static ProcedureAndRelatedWrapp saveRecords(AAZ_RequestNewProcedure_wpr.ProcedureData NewProcedure_In){
		Map<String,Map<String,RecordType>> mapRTsByDevName =  AAZ_Utils_cls.getRecordTypes('DeveloperName');
		Account accountInstance = new Account(
			Suburb__c                = NewProcedure_In.currentData.suburb,
			ShippingStreet           = NewProcedure_In.currentData.street,
	   		ShippingState            = NewProcedure_In.currentData.state,
			SchoolGrade__c           = NewProcedure_In.currentData.scholarship,
			RFC__c                   = NewProcedure_In.currentData.rfc,
			ShippingPostalCode       = NewProcedure_In.currentData.postalCode,
			NSS__c                   = NewProcedure_In.currentData.nss,
			MaritalStatus__c         = NewProcedure_In.currentData.maritalStatus,
			InternalNumber__c        = NewProcedure_In.currentData.internalNumber,
			ExternalNumber__c        = NewProcedure_In.currentData.externalNumber,
			EmployeeName__c          = NewProcedure_In.currentData.employment,
			Industry                 = NewProcedure_In.currentData.economicActivity,
			Delegation__c            = NewProcedure_In.currentData.delegation,
			PersonEmail              = NewProcedure_In.currentData.email,
			ProofAddress__c          = String.valueOf(NewProcedure_In.currentData.pointSupportingAddress),
			Gender__c                = NewProcedure_In.currentData.gender,
			FirstName                = NewProcedure_In.currentData.name,
			LastName                 = (NewProcedure_In.currentData.fatherLastName != null && NewProcedure_In.currentData.fatherLastName != '' && NewProcedure_In.currentData.fatherLastName != ' ')?(NewProcedure_In.currentData.motherLastName != null && NewProcedure_In.currentData.motherLastName != '' && NewProcedure_In.currentData.motherLastName != ' ')?NewProcedure_In.currentData.fatherLastName+' '+NewProcedure_In.currentData.motherLastName:NewProcedure_In.currentData.fatherLastName:'No especificado',
			PaternalLastName__c      = NewProcedure_In.currentData.fatherLastName,
			MaternalLastName__c      = NewProcedure_In.currentData.motherLastName,
			CURP__c                  = NewProcedure_In.currentData.curp,
			ReferenceData__c         = String.valueOf(NewProcedure_In.currentData.pointReferenceData),
			PersonalInformation__c   = String.valueOf(NewProcedure_In.currentData.pointPersonData),
			ShippingCountry          = NewProcedure_In.currentData.country,
			ProofMaximumAddress__c   = String.valueOf(NewProcedure_In.currentData.maxPointSupportingAddress),
			DataLocation__c 		 = String.valueOf(NewProcedure_In.currentData.pointLocalData),
			Citizenship__c 			 = NewProcedure_In.currentData.citizenship,
			PointsFile__c 			 = String.valueOf(NewProcedure_In.currentData.pointFiles),
			DataReferenceMaximum__c  = String.valueOf(NewProcedure_In.currentData.maxPointReferenceData),
			BirthState__c 			 = NewProcedure_In.currentData.birthState,
			MaxPersonalData__c       = String.valueOf(NewProcedure_In.currentData.maxPointPersonData),
			birthDate__c             =  NewProcedure_In.currentData.birthDate,
			ContactAttempt__c        = String.valueOf(NewProcedure_In.currentData.pointContactNumber),
			MaximumLocationData__c   = String.valueOf(NewProcedure_In.currentData.maxPointLocalData),
			BankClabe__c             = NewProcedure_In.currentData.bankClabe,
			MaxPointFiles__c         = String.valueOf(NewProcedure_In.currentData.maxPointFiles),
			BankAccount__c           = NewProcedure_In.currentData.bankAccount,
			Bank__c                  = NewProcedure_In.currentData.bank,
			MaximumContactAttempt__c = String.valueOf(NewProcedure_In.currentData.maxPointContactNumber),
			PhoneType2__c            = NewProcedure_In.currentData.typePhone2,
			PhoneType__c             = NewProcedure_In.currentData.typePhone1,
			StreetWork__c            = NewProcedure_In.currentData.streetWork,
			StateWork__c             = NewProcedure_In.currentData.stateWork,
			SalaryB__c               = NewProcedure_In.currentData.salaryB,
			SalaryA__c               = NewProcedure_In.currentData.salaryA,
			Resolution__c            = NewProcedure_In.currentData.resolution,
			PostalCodeWork__c        = NewProcedure_In.currentData.postalCodeWork,
			PointAPHistory__c        = String.valueOf(NewProcedure_In.currentData.pointAPHistory),
			Phone__c                 = NewProcedure_In.currentData.phoneNumber2,
			Phone                    = NewProcedure_In.currentData.phoneNumber1,
			PensionType__c           = NewProcedure_In.pensiontype,
			PendingNumber__c         = NewProcedure_In.currentData.pendingNumber,
			Option__c                = NewProcedure_In.currentData.option,
			MaxPointHistory__c       = String.valueOf(NewProcedure_In.currentData.maxPointAPHistory),
			InternalNumberWork__c    = NewProcedure_In.currentData.internalNumberWork,
			ExternalNumberWork__c    = NewProcedure_In.currentData.externalNumberWork,
			ExtensionNumber2__c      = NewProcedure_In.currentData.extensionNumber2,
			ExtensionNumber__c       = NewProcedure_In.currentData.extensionNumber1,
			DelegationWork__c        = NewProcedure_In.currentData.delegationWork,
			RecordTypeId             = (mapRTsByDevName.get('Account').containsKey('PersonAccount'))?mapRTsByDevName.get('Account').get('PersonAccount').Id:null
		);
		SObjectField f;
		if(accountInstance.NSS__c != null){
			f = Account.NSS__c;
		}else if(Account.RFC__c != null){
			f = Account.RFC__c;
		}

		Database.upsert(accountInstance,f,true);
		System.debug(loggingLevel.Error, '*** caseInstance.FolioNSS__c: ' + NewProcedure_In.folio);
		Case caseInstance = new Case(
			PointDigitalSingnature__c       = (NewProcedure_In.pointDigitalSingnature != null)?String.valueOf(NewProcedure_In.pointDigitalSingnature):null,
			RequestDate__c                  = (NewProcedure_In.requestDate != null)?Date.valueOf(NewProcedure_In.requestDate):null,
			Origin                          = NewProcedure_In.origin,
			EmployeeNumber__c               = NewProcedure_In.employeeNumber,
			Subsidiary__c                   = NewProcedure_In.subsidiary,
			Status                          = NewProcedure_In.status,
			idServiceType__c                = NewProcedure_In.serviceType,
			DeadLineDate__c                 = NewProcedure_In.deadLineDate,
			PointRiskLevel__c               = (NewProcedure_In.pointRiskLevel != null) ? String.valueOf(NewProcedure_In.pointRiskLevel): null,
			FolioNSS__c                     = NewProcedure_In.folio,
			MaxPointRiskLevel__c            =  (NewProcedure_In.maxPointRiskLevel != null ) ?String.valueOf(NewProcedure_In.maxPointRiskLevel): null,
			PointBioSingnature__c           = (NewProcedure_In.pointBioSingnature != null )? String.valueOf(NewProcedure_In.pointBioSingnature):null,
			Authentication__c               =  (NewProcedure_In.pointAutentification != null)? String.valueOf(NewProcedure_In.pointAutentification): null,
			MaxPointDigitalSingnature__c    = (NewProcedure_In.maxPointDigitalSingnature != null)? String.valueOf(NewProcedure_In.maxPointDigitalSingnature):null,
			MaxPointBioSingnature__c        = (NewProcedure_In.maxPointBioSingnature != null)?String.valueOf(NewProcedure_In.maxPointBioSingnature):null,
			MaxPointAutentification__c      = (NewProcedure_In.maxPointAutentification != null)?String.valueOf(NewProcedure_In.maxPointAutentification): null,
			//RegimeType__c                   = NewProcedure_In.regimeType,
			idRegimeType__c                 = NewProcedure_In.RegimeType,
			PhoneSalesman__c                = NewProcedure_In.phoneSalesman,
			PhoneRegional__c                = NewProcedure_In.phoneRegional,
			PensionDate__c                  = NewProcedure_In.pensionDate,
			EmployeeNumberPromoterAgent__c  = NewProcedure_In.employeeNumberSalesman,
			EmployeeNumberRegional__c       = NewProcedure_In.employeeNumberRegional,
			EconomyNumberSalesman__c        = NewProcedure_In.economyNumberSalesman,
			NumberOfPrints__c               = NewProcedure_In.numberPrints,
			CallMade__c                     = (NewProcedure_In.phoneCallPerformed == null)? false :NewProcedure_In.phoneCallPerformed,
			IdWithdrawtype__c               = NewProcedure_In.Withdrawtype,
			IdPensiontype__c                = NewProcedure_In.Pensiontype,
			IdSecuritytype__c               = NewProcedure_In.Securitytype,
			IdBenefitType__c                = NewProcedure_In.BenefitType,
			procedureIsBeneficary__c        = (NewProcedure_In.procedureIsBeneficary != null)? Boolean.valueOf(NewProcedure_In.procedureIsBeneficary): false,
			hadBeenProcecesd__c             = (NewProcedure_In.hadBeenProcecesd != null)? Boolean.valueOf(NewProcedure_In.hadBeenProcecesd) :false,
			processFingerIssue__c           = (NewProcedure_In.processFingerIssue != null)?Boolean.valueOf(NewProcedure_In.processFingerIssue):false,
			state__c                        = NewProcedure_In.state,
			candidate__c                    = NewProcedure_In.candidate,
			SarTicket1__c                   = NewProcedure_In.SarTicket1,
			SarTicket2__c                   = NewProcedure_In.SarTicket2,
			IsPosibleReverse__c             = (NewProcedure_In.IsPosibleReverse != null)? Boolean.valueOf(NewProcedure_In.IsPosibleReverse): false,
			ImplicationVerified__c          = NewProcedure_In.folioConstancy,
			folioCus__c                     = NewProcedure_In.folioCus,
			constancyDate__c                = NewProcedure_In.constancyDate,
			ciafore__c                      = NewProcedure_In.ciafore,
			pointAPHistory__c               = (NewProcedure_In.pointAPHistory != null)?String.valueOf(NewProcedure_In.pointAPHistory):null,
			pointMaxAPHistory__c            = (NewProcedure_In.maxPointAPHistory != null)?String.valueOf(NewProcedure_In.maxPointAPHistory):null,
			AccountId                       = accountInstance.Id
		);
		System.debug(loggingLevel.Error, '*** caseInstance: ' + caseInstance);
		System.debug(loggingLevel.Error, '*** caseInstance.FolioNSS__c: ' + NewProcedure_In.folio);
		if(NewProcedure_In.isUpdate){
			caseInstance.NewSuburb__c                    = NewProcedure_In.newData.newSuburb;
			caseInstance.NewStreet__c                    = NewProcedure_In.newData.newStreet;
			caseInstance.NewState__c                     = NewProcedure_In.newData.newState;
			caseInstance.NewScholarship__c               = NewProcedure_In.newData.newScholarship;
			caseInstance.NewRFC__c                       = NewProcedure_In.newData.newRfc;
			caseInstance.NewPostalCode__c                = NewProcedure_In.newData.newPostalCode;
			caseInstance.NewNSS__c                       = NewProcedure_In.newData.newNss;
			caseInstance.NewMaritalStatus__c             = NewProcedure_In.newData.newMaritalStatus;
			caseInstance.NewInternalNumber__c            = NewProcedure_In.newData.newInternalNumber;
			caseInstance.NewExternalNumber__c            = NewProcedure_In.newData.newExternalNumber;
			caseInstance.NewEmployment__c                = NewProcedure_In.newData.newEmployment;
			caseInstance.NewEconomicActivity__c          = NewProcedure_In.newData.newEconomicActivity;
			caseInstance.NewDelegation__c                = NewProcedure_In.newData.newDelegation;
			caseInstance.NewEmail__c                     = NewProcedure_In.newData.newEmail;
			caseInstance.NewPointSupportingAddress__c    = String.valueOf(NewProcedure_In.newData.newPointSupportingAddress);
			caseInstance.NewGender__c                    = NewProcedure_In.newData.newGender;
			caseInstance.NewName__c                      = NewProcedure_In.newData.newName;
			caseInstance.NewFatherLastName__c            = NewProcedure_In.newData.newFatherLastName;
			caseInstance.NewMotherLastName__c            = NewProcedure_In.newData.newMotherLastName;
			caseInstance.NewCurp__c                      = NewProcedure_In.newData.newCurp;
			caseInstance.NewPointReferenceData__c        = String.valueOf(NewProcedure_In.newData.newPointReferenceData);
			caseInstance.NewPointPersonData__c           = String.valueOf(NewProcedure_In.newData.newPointPersonData);
			caseInstance.NewCountry__c                   = NewProcedure_In.newData.newCountry;
			caseInstance.NewMaxPointSupportingAddress__c = String.valueOf(NewProcedure_In.newData.newMaxPointSupportingAddress);
			caseInstance.NewPointLocalData__c            = String.valueOf(NewProcedure_In.newData.newPointLocalData);
			caseInstance.NewCitizenship__c               = NewProcedure_In.newData.newCitizenship;
			caseInstance.NewPointFiles__c                = String.valueOf(NewProcedure_In.newData.newPointFiles);
			caseInstance.NewMaxPointReferenceData__c     = String.valueOf(NewProcedure_In.newData.newMaxPointReferenceData);
			caseInstance.NewBirthState__c                = NewProcedure_In.newData.newBirthState;
			caseInstance.NewMaxPointPersonData__c        = String.valueOf(NewProcedure_In.newData.newMaxPointPersonData);
			caseInstance.NewBirthDate__c                 = (NewProcedure_In.newData.newBirthDate != null)?Date.valueOf(NewProcedure_In.newData.newBirthDate):null;
			caseInstance.NewPointContactNumber__c        = String.valueOf(NewProcedure_In.newData.newPointContactNumber);
			caseInstance.NewMaxPointLocalData__c         = String.valueOf(NewProcedure_In.newData.newMaxPointLocalData);
			caseInstance.NewBankClabe__c                 = NewProcedure_In.newData.newBankClabe;
			caseInstance.NewMaxPointFiles__c             = String.valueOf(NewProcedure_In.newData.newMaxPointFiles);
			caseInstance.NewBankAccount__c               = NewProcedure_In.newData.newBankAccount;
			caseInstance.NewBank__c                      = NewProcedure_In.newData.newBank;
			caseInstance.NewMaxPointContactNumber__c     = String.valueOf(NewProcedure_In.newData.newMaxPointContactNumber);
			caseInstance.NewTypePhone2__c                = NewProcedure_In.newData.newTypePhone2;
			caseInstance.NewTypePhone1__c                = NewProcedure_In.newData.newTypePhone1;
			caseInstance.NewStreetWork__c                = NewProcedure_In.newData.newStreetWork;
			caseInstance.NewStatework__c                 = NewProcedure_In.newData.newStateWork;
			caseInstance.NewSalaryB__c                   = NewProcedure_In.newData.newSalaryB;
			caseInstance.NewSalaryA__c                   = NewProcedure_In.newData.newSalaryA;
			caseInstance.NewResolution__c                = NewProcedure_In.newData.newResolution;
			//NewResolutionDate
			caseInstance.NewPostalCodeWork__c            = NewProcedure_In.newData.newPostalCodeWork;
			caseInstance.NewPointAPHistory__c            = String.valueOf(NewProcedure_In.newData.newPointAPHistory);
			caseInstance.NewPhoneNumber2__c              = NewProcedure_In.newData.newPhoneNumber2;
			caseInstance.NewPhoneNumber1__c              = NewProcedure_In.newData.newPhoneNumber1;
			caseInstance.NewPensionType__c               = NewProcedure_In.newData.newPensionType;
			caseInstance.NewPendingNumber__c             = NewProcedure_In.newData.newPendingNumber;
			caseInstance.NewOption__c                    = NewProcedure_In.newData.newOption;
			caseInstance.NewMaxPointAPHistory__c         = String.valueOf(NewProcedure_In.newData.newMaxPointAPHistory);
			caseInstance.NewInternalNumberWork__c        = NewProcedure_In.newData.newInternalNumberWork;
			caseInstance.NewExternalNumberWork__c        = NewProcedure_In.newData.newExternalNumberWork;
			caseInstance.NewExtensionNumber2__c          = NewProcedure_In.newData.newExtensionNumber2;
			caseInstance.NewExtensionNumber1__c          = NewProcedure_In.newData.newExtensionNumber1;
			caseInstance.NewDelegationWork__c            = NewProcedure_In.newData.newDelegationWork;
			//colonyWork
			//institute

		}
		AAZ_Utils_cls.assingRecorType(caseInstance);
		//AAZ_Utils_cls.assingNumberOfPrints(caseInstance);
		System.debug(loggingLevel.Error, '*** caseInstance.RecordTypeId: ' + caseInstance.RecordTypeId);
		SObjectField cf = Case.FolioNSS__c;
		System.debug(loggingLevel.Error, '*** caseInstance.FolioNSS__c: ' + NewProcedure_In.folio);
		System.debug(loggingLevel.Error, '*** cf: ' + cf);
		Database.upsert(caseInstance,cf,true);
		ProcedureAndRelatedWrapp procedureAndRelatedInstance = new ProcedureAndRelatedWrapp();
		procedureAndRelatedInstance.accInstance = accountInstance;
		procedureAndRelatedInstance.caseInst = caseInstance;
		return procedureAndRelatedInstance;
	}

	global class ProcedureAndRelatedWrapp{
		global Account accInstance;
		global Case caseInst;
	}
}