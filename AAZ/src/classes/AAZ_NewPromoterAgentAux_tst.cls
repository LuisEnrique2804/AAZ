@isTest
private class  AAZ_NewPromoterAgentAux_tst{
	
	@isTest static void test_method_promoterCreation() {

   
        Test.startTest();
        
      AAZ_NewPromoterAgentRequest_wpr.NewAgent requestWrapper = new AAZ_NewPromoterAgentRequest_wpr.NewAgent();

    requestWrapper.employeeNumber='teste';	
	requestWrapper.nss='teste';
     requestWrapper.maternalLastName='teste';
     requestWrapper.firstName='teste';
	requestWrapper.admitionDate=Date.today();
    requestWrapper.schoolGrade='teste';
	requestWrapper.birthDate=Date.today();
    requestWrapper.shopNumber=1111;
    requestWrapper.shopName='teste';
	requestWrapper.zone='sp';
	requestWrapper.state='sp';
        
   AAZ_NewPromoterAgentAux_cls.promoterCreation(requestWrapper);
      
			
           }
   
		
}