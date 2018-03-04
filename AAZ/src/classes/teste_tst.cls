@isTest
public class teste_tst {
@testSetup
      static void setup() {
    Test.startTest();

  Contact promoterAgent = new Contact ();
             promoterAgent.EmployeeNumber__c = 'NewPromoterAgent_In.employeeNumbe';
			 promoterAgent.NSS__c = 'NewPromoterAgent_In.nss';
			 promoterAgent.FirstName = 'NewPromoterAgent_In.firstName';
			 promoterAgent.LastName = 'No especificado';
			 promoterAgent.PaternalLastName__c ='NewPromoterAgent_In.paternalLastName';
			 promoterAgent.MaternalLastName__c =  'NewPromoterAgent_In.maternalLastName';
			 promoterAgent.AdmitionDate__c = Date.today();
			 promoterAgent.LevelStudy__c = 'NewPromoterAgent_In.schoolGrade';
			 promoterAgent.Birthdate =  Date.today();
			 promoterAgent.ShopNumber__c = 123;
			 promoterAgent.ShopName__c = 'NewPromoterAgent_In.shopName';
			 promoterAgent.Zone__c = 'NewPromoterAgent_In.zone';
			 promoterAgent.State__c = 'NewPromoterAgent_In.state';
                                 
     insert  promoterAgent;
}
}