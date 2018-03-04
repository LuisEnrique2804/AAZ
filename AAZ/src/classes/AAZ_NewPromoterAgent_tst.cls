/*******************************************************************************
Desarrollado por: Avanxo México
Correo: ineria@avanxo.com
Autor: Iván Neria
Proyecto: Afore Azteca
Descripción: Clase de prueba para los servicios web de la clase 'AAZ_NewPromoterAgent_ws'

------ ---------- -------------------------- -----------------------------------
No.    Fecha      Autor                      Descripción
------ ---------- -------------------------- -----------------------------------
1.0    04/10/2017 Iván Neria           Clase creada

*******************************************************************************/
@isTest
	public class AAZ_NewPromoterAgent_tst {
        
        //Método prueba para cuando la respuesta es exitosa 
        static testMethod void newPromoterAgent(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        AAZ_NewPromoterAgentRequest_wpr.NewAgent NewPromoterAgent_In = new AAZ_NewPromoterAgentRequest_wpr.NewAgent();
            NewPromoterAgent_In.employeeNumber = '12345';
            NewPromoterAgent_In.nss = '555555';
            NewPromoterAgent_In.paternalLastName = 'Test1';
            NewPromoterAgent_In.maternalLastName = 'TstLM';
            NewPromoterAgent_In.firstName = '';
            NewPromoterAgent_In.admitionDate= Date.newInstance(2016, 12, 9);
            NewPromoterAgent_In.schoolGrade = 'LC';
            NewPromoterAgent_In.birthDate =Date.newInstance(2000, 5, 5);
            NewPromoterAgent_In.shopNumber=45432;
            NewPromoterAgent_In.shopName='Tester';
            NewPromoterAgent_In.zone='CA';
            NewPromoterAgent_In.state='Test';
            
            Test.startTest();
            	AAZ_NewPromoterAgent_ws.newPromoterAgent(NewPromoterAgent_In);
            Test.stopTest();
        }
		
        //Método prueba para cuando la respuesta NO es exitosa 
        static testMethod void newPromoterAgentFalse(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        AAZ_NewPromoterAgentRequest_wpr.NewAgent NewPromoterAgent_InFalse = new AAZ_NewPromoterAgentRequest_wpr.NewAgent();
            
            
            Test.startTest();
            	AAZ_NewPromoterAgent_ws.newPromoterAgent(NewPromoterAgent_InFalse);
            Test.stopTest();
        }
		
}