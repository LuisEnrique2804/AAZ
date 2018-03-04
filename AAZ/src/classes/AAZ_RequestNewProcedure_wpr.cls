/****************************************************************************************
	Desarrollado por:  Avanxo México
	Autor:             René Ayala Medina
	Proyecto:          Mesa de Control Afore Azteca
	Descripción:       Clase de APEX que se utiliza para deserializar la solicitud en el servicio "Alta de trámite"
	Cambios (Versiones)
	-------------------------------------
	  No.      Fecha                  Autor                      Descripción
	------  -------------  ------------------------------   ----------------------
	 1.0      28-07-2017    René Ayala Medina RAM            Creacion
****************************************************************************************/

global class AAZ_RequestNewProcedure_wpr {

	/*
		Clase / Estructura que almacena los datos del trámite
	*/

	global class ProcedureData{
		global Integer pointDigitalSingnature;
		global String requestDate;
		global String origin;
		global String employeeNumber;
		global String status;
		global String serviceType;
		global Boolean isUpdate;
		global Date deadLineDate;
		global Integer pointRiskLevel;
		global String folio;
		global Integer maxPointRiskLevel;
		global Integer pointBioSingnature;
		global Integer pointAutentification;
		global Integer maxPointDigitalSingnature;
		global Integer maxPointBioSingnature;
		global Integer maxPointAutentification;
		global String salesman;
		global String regionalName;
		global String regimeType;
		global String phoneSalesman;
		global String phoneRegional;
		global Date pensionDate;
		global String employeeNumberSalesman;
		global String employeeNumberRegional;
		global String economyNumberSalesman;
		global Integer numberPrints;
		global String subsidiary;
		//global String RegimeType;
		global String Withdrawtype;
		//global String Pensiontype;
		global String Securitytype;
		global String BenefitType;
		global Boolean procedureIsBeneficary;
		global Boolean processFingerIssue;
		global String state;
		global Boolean phoneCallPerformed;
		global Boolean hadBeenProcecesd;
		global String candidate;
		global String SarTicket1;
		global String SarTicket2;
		global String pensiontype;
		global String IsPosibleReverse;
		global String folioConstancy;
		global String folioCus;
		global Date constancyDate;
		global String ciafore;
		global String ImplicationVerified;
		global CurrentCustomerData currentData;
		global NewCustomerData newData;
		global Integer pointAPHistory;
		global Integer maxPointAPHistory;
	}

	/*
		Clase / Estructura que almacena los datos vigentes del trabajador
	*/

	global class CurrentCustomerData{
		global String suburb;
		global String street;
		global String state;
		global String scholarship;
		global String rfc;
		global String postalCode;
		global String nss;
		global String maritalStatus;
		global String internalNumber;
		global String externalNumber;
		global String employment;
		global String economicActivity;
		global String delegation;
		global String email;
		global Integer pointSupportingAddress;
		global String gender;
		global String name;
		global String fatherLastName;
		global String curp;
		global Integer pointReferenceData;
		global String motherLastName;
		global Integer pointPersonData;
		global String country;
		global Integer maxPointSupportingAddress;
		global Integer pointLocalData;
		global String citizenship;
		global Integer pointFiles;
		global Integer maxPointReferenceData;
		global String birthState;
		global Integer maxPointPersonData;
		global Date birthDate;
		global Integer pointContactNumber;
		global Integer maxPointLocalData;
		global String bankClabe;
		global Integer maxPointFiles;
		global String bankAccount;
		global String bank;
		global Integer maxPointContactNumber;
		global String withdrawType;
		global String typePhone2;
		global String typePhone1;
		global String streetWork;
		global String stateWork;
		global String securityType;
		global Double salaryB;
		global Double salaryA;
		global String resolution;
		global String postalCodeWork;
		global Integer pointAPHistory;
		global String phoneNumber2;
		global String phoneNumber1;
		global String pensiontype;
		global Integer pendingNumber;
		global String option;
		global Integer maxPointAPHistory;
		global String internalNumberWork;
		global String externalNumberWork;
		global String extensionNumber2;
		global String extensionNumber1;
		global String delegationWork;
		global String colonyWork;
	}

	/*
		Clase / Estructura que almacena los datos a actualizar del trabajador (si aplica)
	*/

	global class NewCustomerData{
		global String newSuburb;
		global String newStreet;
		global String newState;
		global String newScholarship;
		global String newRfc;
		global String newPostalCode;
		global String newNss;
		global String newMaritalStatus;
		global String newInternalNumber;
		global String newExternalNumber;
		global String newEmployment;
		global String newEconomicActivity;
		global String newDelegation;
		global String newEmail;
		global Integer newPointSupportingAddress;
		global String newGender;
		global String newName;
		global String newFatherLastName;
		global String newCurp;
		global Integer newPointReferenceData;
		global String newMotherLastName;
		global Integer newPointPersonData;
		global String newCountry;
		global Integer newMaxPointSupportingAddress;
		global Integer newPointLocalData;
		global String newCitizenship;
		global Integer newPointFiles;
		global Integer newMaxPointReferenceData;
		global String newBirthState;
		global Integer newMaxPointPersonData;
		global Date newBirthDate;
		global Integer newPointContactNumber;
		global Integer newMaxPointLocalData;
		global String newBankClabe;
		global Integer newMaxPointFiles;
		global String newBankAccount;
		global String newBank;
		global Integer newMaxPointContactNumber;
		global String newWithdrawType;
		global String newTypePhone2;
		global String newTypePhone1;
		global String newStreetWork;
		global String newStateWork;
		global String newSecurityType;
		global Double newSalaryB;
		global Double newSalaryA;
		global String newResolution;
		global String newPostalCodeWork;
		global Integer newPointAPHistory;
		global String newPhoneNumber2;
		global String newPhoneNumber1;
		global String newPensionType;
		global Integer newPendingNumber;
		global String newOption;
		global Integer newMaxPointAPHistory;
		global String newInternalNumberWork;
		global String newExternalNumberWork;
		global String newExtensionNumber2;
		global String newExtensionNumber1;
		global String newDelegationWork;
		global String newColonyWork;
	}



}