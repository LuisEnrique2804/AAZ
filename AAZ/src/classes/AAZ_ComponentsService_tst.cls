/*******************************************************************************
Desarrollado por: Avanxo México
Autor: Iván Neria
Proyecto: Afore Azteca
Descripción: Clase de prueba para los servicios web de la clase AAZ_ComponentsService_cls (WS008 y WS009)

------ ---------- -------------------------- -----------------------------------
No.    Fecha      Autor                      Descripción
------ ---------- -------------------------- -----------------------------------
1.0    02/10/2017 Iván Neria           Clase creada

*******************************************************************************/
@isTest public class AAZ_ComponentsService_tst { 
    @testSetup static void AAZ_ComponentsService(){
        // Crear configuración global de la app
       // AppMainSetting_cs__c mainSettings = Test.isRunningTest()?
        //AAZ_TestUtils_tst.getMainSettings() : AppMainSetting_cs__c.getOrgDefaults();
        
     
    }
    @isTest
    static void registerComponent() {
		AAZ_ComponentsService_cls.RegisterComponentParamsWrapper paramsInstance = new AAZ_ComponentsService_cls.RegisterComponentParamsWrapper();
        paramsInstance.strNss = '12345';
        paramsInstance.strFolio = '54321';
        
        // Get endpoints for services
        EndpointSetting__mdt tokenEndpoint = AAZ_Utils_cls.getEndpointSetting('Afore_Authorization');
        String strTokenEndpoint = AAZ_GenericCallout_cls.getEndpoint(tokenEndpoint);
         EndpointSetting__mdt referencesEndpoint = AAZ_Utils_cls.getEndpointSetting('Afore_ComponentSign');
        String strReferencesEndpoint = AAZ_GenericCallout_cls.getEndpoint(referencesEndpoint);

        // Create response mocks
        SingleRequestMock tokenMock = new SingleRequestMock('{"signToken":{"signedToken":"ZWQzNzUyZTg5MDk4MzE0YTA1OTY4ZGU0YWI4MjljMzFhYmU5MDNkOTA0NzIzYTlhOGNmNGJhNTAwYjE5YzYwNg==","expiration":"2017-04-26 13:24:19"}}');
        SingleRequestMock referencesMock = new SingleRequestMock('{"Out_RegistraComponente":{"docServiceRs":{"codError":"-1","msjError":"Lo sentimos ocurrio un error. Nss no es correcto favor de validarlo."}}}');

        // Save response mocks in a MultiRequestMock instance
        MultiRequestMock multiRequestMock = new MultiRequestMock();
        multiRequestMock.addRequestMock(strTokenEndpoint, tokenMock);
        multiRequestMock.addRequestMock(strReferencesEndpoint, referencesMock);

        Test.setMock(HttpCalloutMock.class, multiRequestMock);

        Test.startTest();
        AAZ_ComponentsService_cls.registerComponent(paramsInstance);
        Test.stopTest();
       }
    @isTest
    static void getComponentStatus() {
		AAZ_ComponentsService_cls.StatusComponentParamsWrapper paramsInstance = new AAZ_ComponentsService_cls.StatusComponentParamsWrapper();
        paramsInstance.strNss = '12345';
        paramsInstance.strFolio = '54321';
        
        // Get endpoints for services
        EndpointSetting__mdt tokenEndpoint = AAZ_Utils_cls.getEndpointSetting('Afore_Authorization');
        String strTokenEndpoint = AAZ_GenericCallout_cls.getEndpoint(tokenEndpoint);
         EndpointSetting__mdt referencesEndpoint = AAZ_Utils_cls.getEndpointSetting('Afore_ComponentSign');
        String strReferencesEndpoint = AAZ_GenericCallout_cls.getEndpoint(referencesEndpoint);

        // Create response mocks
        SingleRequestMock tokenMock = new SingleRequestMock('{"signToken":{"signedToken":"ZWQzNzUyZTg5MDk4MzE0YTA1OTY4ZGU0YWI4MjljMzFhYmU5MDNkOTA0NzIzYTlhOGNmNGJhNTAwYjE5YzYwNg==","expiration":"2017-04-26 13:24:19"}}');
        SingleRequestMock referencesMock = new SingleRequestMock('{"Out_RegistraComponente":{"docServiceRs":{"codError":"0","msjError":"OperaciÃ³n exitosa"}}}');

        // Save response mocks in a MultiRequestMock instance
        MultiRequestMock multiRequestMock = new MultiRequestMock();
        multiRequestMock.addRequestMock(strTokenEndpoint, tokenMock);
        multiRequestMock.addRequestMock(strReferencesEndpoint, referencesMock);

        Test.setMock(HttpCalloutMock.class, multiRequestMock);

        Test.startTest();
        AAZ_ComponentsService_cls.getComponentStatus(paramsInstance);
        Test.stopTest();
       }

}