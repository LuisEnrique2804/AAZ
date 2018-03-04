/*******************************************************************************
Desarrollado por: Avanxo México
Autor: Samuel Galindo
Proyecto: Afore Azteca
Descripción: Clase test para la clase AAZ_NewProcedureAux_cls
-------------------------------------------------
No.    Fecha      Autor              Descripción
------ ---------- ------------------------------
1.2    08-11-2017 Samuel Galindo 	   Modificación
*******************************************************************************/
@isTest
private class AAZ_NewProcedureAux_tst {

    @isTest static void testMethodSaveRecord() {

        Test.startTest();
            AAZ_RequestNewProcedure_wpr.ProcedureData requestWrapper  = new    AAZ_RequestNewProcedure_wpr.ProcedureData ();
            requestWrapper.currentData = new AAZ_RequestNewProcedure_wpr.CurrentCustomerData();
            requestWrapper.currentData.suburb = 'test';
            requestWrapper.currentData.street= 'test';
            requestWrapper.currentData.state = 'test';
            requestWrapper.currentData.scholarship= 'test';
            requestWrapper.currentData.rfc= 'test';
            requestWrapper.currentData.postalCode= 'test';
            requestWrapper.currentData.nss= 'test';
            requestWrapper.currentData.maritalStatus= 'test';
            requestWrapper.currentData.internalNumber= 'test';
            requestWrapper.currentData.externalNumber= 'test';
            requestWrapper.currentData.employment= 'test';
            requestWrapper.currentData.economicActivity= 'test';
            requestWrapper.currentData.delegation= 'test';
            requestWrapper.currentData.email= 'test@teste.com';
            requestWrapper.currentData.pointSupportingAddress= 1;
            requestWrapper.currentData.gender= 'test';
            requestWrapper.currentData.name= 'test';
            requestWrapper.currentData.fatherLastName = 'test';
            requestWrapper.currentData.motherLastName= 'test';
            requestWrapper.currentData.curp= 'test';
            requestWrapper.currentData.pointReferenceData= 1;
            requestWrapper.currentData.pointPersonData= 1;
            requestWrapper.currentData.country= 'test';
            requestWrapper.currentData.maxPointSupportingAddress= 1;
            requestWrapper.currentData.pointLocalData=1;
            requestWrapper.currentData.citizenship= 'test';
            requestWrapper.currentData.pointFiles= 1;
            requestWrapper.currentData.maxPointReferenceData= 1;
            requestWrapper.currentData.birthState= 'test';
            requestWrapper.currentData.maxPointPersonData= 1;
            requestWrapper.currentData.birthDate= Date.today();
            requestWrapper.currentData.pointContactNumber= 1;
            requestWrapper.currentData.maxPointLocalData= 1;
            requestWrapper.currentData.bankClabe= 'test';
            requestWrapper.currentData.maxPointFiles= 1;
            requestWrapper.currentData.bankAccount= 'test';
            requestWrapper.currentData.bank= 'test';
            requestWrapper.currentData.maxPointContactNumber= 1;
            requestWrapper.currentData.typePhone2= 'test';
            requestWrapper.currentData.typePhone1= 'test';
            requestWrapper.currentData.streetWork= 'test';
            requestWrapper.currentData.stateWork= 'test';
            requestWrapper.currentData.salaryB= 102.20;
            requestWrapper.currentData.salaryA= 102.20;
            requestWrapper.currentData.resolution= 'test';
            requestWrapper.currentData.postalCodeWork= 'test';
            requestWrapper.currentData.pointAPHistory= 1;
            requestWrapper.currentData.phoneNumber2= 'test';
            requestWrapper.currentData.phoneNumber1= 'test';
            requestWrapper.currentData.pendingNumber= 1;
            requestWrapper.currentData.option= 'test';
            requestWrapper.currentData.maxPointAPHistory= 1;
            requestWrapper.currentData.internalNumberWork= 'test';
            requestWrapper.currentData.externalNumberWork= 'test';
            requestWrapper.currentData.extensionNumber2= 'test';
            requestWrapper.currentData.extensionNumber1= 'test';
            requestWrapper.currentData.delegationWork= 'test';

            AAZ_RequestNewProcedure_wpr.ProcedureData NewProcedure_In  = new    AAZ_RequestNewProcedure_wpr.ProcedureData ();
            NewProcedure_In.pointDigitalSingnature = 1;
            NewProcedure_In.requestDate='Date.today()';
            requestWrapper.pointDigitalSingnature=1;
            requestWrapper.origin='origin';
            requestWrapper.employeeNumber='employeeNumber';
            requestWrapper.status='status';
            requestWrapper.serviceType='serviceType';
            requestWrapper.isUpdate=true;
            requestWrapper.deadLineDate = Date.today();
            requestWrapper.pointRiskLevel =1;
            requestWrapper.folio='teste';
            requestWrapper.maxPointRiskLevel=1;
            requestWrapper.pointBioSingnature=1;
            requestWrapper.pointAutentification=1;
            requestWrapper.maxPointDigitalSingnature=1;
            requestWrapper.maxPointBioSingnature=1;
            requestWrapper.maxPointAutentification=1;
            requestWrapper.salesman='salesman';
            requestWrapper.regionalName='regionalName';
            requestWrapper.regimeType='regimeType';
            requestWrapper.phoneSalesman='phoneSalesman';
            requestWrapper.phoneRegional='phoneRegional';
            requestWrapper.pensionDate=Date.today();
            requestWrapper.employeeNumberSalesman='employeeNumberSalesman=';
            requestWrapper.employeeNumberRegional='employeeNumberRegional';
            requestWrapper.economyNumberSalesman='economyNumberSalesman=';
            requestWrapper.numberPrints=1;
            requestWrapper.subsidiary='subsidiary';
            requestWrapper.procedureIsBeneficary=true;
            requestWrapper.processFingerIssue=true;
            requestWrapper.state='state';
            requestWrapper.phoneCallPerformed=true;
            requestWrapper.hadBeenProcecesd=true;
            requestWrapper.candidate='candidate';
            requestWrapper.SarTicket1='SarTicket1';
            requestWrapper.SarTicket2='SarTicket2';
            requestWrapper.pensiontype='pensiontype';

            requestWrapper.newData = new AAZ_RequestNewProcedure_wpr.NewCustomerData();
            requestWrapper.newData.newSuburb='test';
            requestWrapper.newData.newStreet='test';
            requestWrapper.newData.newState='test';
            requestWrapper.newData.newScholarship='test';
            requestWrapper.newData.newRfc='test';
            requestWrapper.newData.newPostalCode='test';
            requestWrapper.newData.newNss='test';
            requestWrapper.newData.newMaritalStatus='test';
            requestWrapper.newData.newInternalNumber='test';
            requestWrapper.newData.newExternalNumber='test';
            requestWrapper.newData.newEmployment='test';
            requestWrapper.newData.newEconomicActivity='test';
            requestWrapper.newData.newDelegation='test';
            requestWrapper.newData.newEmail='test';
            requestWrapper.newData.newPointSupportingAddress=1;
            requestWrapper.newData.newGender='test';
            requestWrapper.newData.newName='test';
            requestWrapper.newData.newFatherLastName='test';
            requestWrapper.newData.newCurp='test';
            requestWrapper.newData.newPointReferenceData=1;
            requestWrapper.newData.newMotherLastName='test';
            requestWrapper.newData.newPointPersonData=1;
            requestWrapper.newData.newCountry='test';
            requestWrapper.newData.newMaxPointSupportingAddress=1;
            requestWrapper.newData.newPointLocalData=1;
            requestWrapper.newData.newCitizenship='test';
            requestWrapper.newData.newPointFiles=1;
            requestWrapper.newData.newMaxPointReferenceData=1;
            requestWrapper.newData.newBirthState='test';
            requestWrapper.newData.newMaxPointPersonData=1;
            requestWrapper.newData.newBirthDate=Date.today();
            requestWrapper.newData.newPointContactNumber=1;
            requestWrapper.newData.newMaxPointLocalData=1;
            requestWrapper.newData.newBankClabe='test';
            requestWrapper.newData.newMaxPointFiles=1;
            requestWrapper.newData.newBankAccount='test';
            requestWrapper.newData.newBank='test';
            requestWrapper.newData.newMaxPointContactNumber=1;
            requestWrapper.newData.newWithdrawType='test';
            requestWrapper.newData.newTypePhone2='test';
            requestWrapper.newData.newTypePhone1='test';
            requestWrapper.newData.newStreetWork='test';
            requestWrapper.newData.newStateWork='test';
            requestWrapper.newData.newSecurityType='test';
            requestWrapper.newData.newSalaryB=102.30;
            requestWrapper.newData.newSalaryA=102.30;
            requestWrapper.newData.newResolution='test';
            requestWrapper.newData.newPostalCodeWork='test';
            requestWrapper.newData.newPointAPHistory=1;
            requestWrapper.newData.newPhoneNumber2='test';
            requestWrapper.newData.newPhoneNumber1='test';
            requestWrapper.newData.newPensionType='test';
            requestWrapper.newData.newPendingNumber=1;
            requestWrapper.newData.newOption='test';
            requestWrapper.newData.newMaxPointAPHistory=1;
            requestWrapper.newData.newInternalNumberWork='test';
            requestWrapper.newData.newExternalNumberWork='test';
            requestWrapper.newData.newExtensionNumber2='test';
            requestWrapper.newData.newExtensionNumber1='test';
            requestWrapper.newData.newDelegationWork='test';
            requestWrapper.newData.newColonyWork='test';
            AAZ_NewProcedureAux_cls.saveRecords( requestWrapper);
        Test.stopTest();
    }
}