/*******************************************************************************
Desarrollado por: Avanxo México
Autor: Luis E. Garcia
Proyecto: Afore Azteca
Descripción: Clase para servicio de consulta de referencias (WS014)

------ ---------- -------------------------- -----------------------------------
No.    Fecha      Autor                      Descripción
------ ---------- -------------------------- -----------------------------------
1.0    26/07/2017 Luis E. Garcia           Clase creada
*******************************************************************************/
public class AAZ_Afore_QueryReference_cls {
private static final String strOrdersQueryConfigCode = 'Afore_QueryReference';
    // Cargar los mainsettings para las clases de prueba
    public static AppMainSetting_cs__c mainSettings = Test.isRunningTest()?
        AAZ_TestUtils_tst.getMainSettings() : AppMainSetting_cs__c.getOrgDefaults();

    public static List<People__c> getReferenceList(List<Case> lstSObjects, Map<String, Object> mapExtraAttrs){
        System.debug('Param 1 = ' + lstSObjects);
        System.debug('Param 2 = ' + mapExtraAttrs);
        List<People__c> lstfoundDocuments = new List<People__c>();
        Boolean blnServiceHadError = false;
        string stgMessage = '';
        String stgtype = 'Web Service';
        id idCurrentCase;
        id idCurrentId = UserInfo.getUserId();
        String strRequest = '';
        String strResponse = '';
        Map<String, Object> mapRequest = new Map<String, Object>();
        Map<String, Object> mapResponse = new Map<String, Object>();
        ResponseWrapper     responseWp  = new ResponseWrapper();

        strRequest = JSON.serializePretty(
            new Map<String,Object>{
                'In_ConsultaReferencias' => new Map<String,Object>{
                    'employedServiceRq' => new Map<String,Object>{
                        'codigoServicio' => lstSObjects[0].idServiceType__c,
                        'nss'=> lstSObjects[0].Account.NSS__c,
                        'folio'=> lstSObjects[0].FolioNSS__c
                    }
                }
            }
        );
        System.debug(loggingLevel.Error, '*** strRequest: ' + strRequest);
        if(strRequest != null || String.isNotBlank(strRequest)) {
            try{strResponse = AAZ_GenericCallout_cls.fn_runCallout(strRequest, strOrdersQueryConfigCode, null);}catch(CalloutException cE){blnServiceHadError = true;stgMessage = cE.getMessage();}catch(UnexpectedException uE){blnServiceHadError = true;stgMessage = uE.getMessage();}catch(Exception gE){blnServiceHadError = true;stgMessage = gE.getMessage();}

            System.debug(loggingLevel.Error, '*** strResponse: ' + strResponse);
            if (String.isNotBlank(strResponse) && strResponse != null) {
                responseWp = (ResponseWrapper)JSON.deserialize(strResponse, ResponseWrapper.class);
                //try {responseWp = (ResponseWrapper)JSON.deserialize(strResponse, ResponseWrapper.class);} catch(Exception e) {System.debug(loggingLevel.Error, '*** e: ' + e);}
                System.debug(loggingLevel.Error, '*** responseWp: ' + responseWp);
                if(responseWp.Out_ConsultaReferencias != null) {
                    if(responseWp.Out_ConsultaReferencias.employedServiceRs != null) {
                        if(responseWp.Out_ConsultaReferencias.employedServiceRs.isSucessful == 'true') {
                            if(responseWp.Out_ConsultaReferencias.employedServiceRs.references != null) {
                                if(!responseWp.Out_ConsultaReferencias.employedServiceRs.references.reference.isEmpty()) {
                                    for(Integer i = 0; i < responseWp.Out_ConsultaReferencias.employedServiceRs.references.reference.size(); i++) {
                                        People__c reference = new People__c(
                                            isUpdateData__c     = (responseWp.Out_ConsultaReferencias.employedServiceRs.references.reference[i].isUpdateData != null)?Boolean.valueOf(responseWp.Out_ConsultaReferencias.employedServiceRs.references.reference[i].isUpdateData): false,
                                            Name__c             = responseWp.Out_ConsultaReferencias.employedServiceRs.references.reference[i].nameReferences,
                                            FatherLastName__c   = responseWp.Out_ConsultaReferencias.employedServiceRs.references.reference[i].fatherLastNameReference,
                                            MaternalLastName__c = responseWp.Out_ConsultaReferencias.employedServiceRs.references.reference[i].motherLastNameReference,
                                            CURP__c             = responseWp.Out_ConsultaReferencias.employedServiceRs.references.reference[i].curpReference,
                                            BirthState__c       = responseWp.Out_ConsultaReferencias.employedServiceRs.references.reference[i].stateBirthReference,
                                            BirthDate__c        = (responseWp.Out_ConsultaReferencias.employedServiceRs.references.reference[i].birthDateReference != null)?Date.valueOf(responseWp.Out_ConsultaReferencias.employedServiceRs.references.reference[i].birthDateReference):Date.today(),
                                            Gender__c           = responseWp.Out_ConsultaReferencias.employedServiceRs.references.reference[i].genderReference,
                                            Phone__c            = responseWp.Out_ConsultaReferencias.employedServiceRs.references.reference[i].phoneRefernce,
                                            PhoneType__c        = responseWp.Out_ConsultaReferencias.employedServiceRs.references.reference[i].typePhoneReference
                                        );
                                        lstfoundDocuments.add(reference);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }


        if(blnServiceHadError == true) {
            //AAZ_Utils_cls.insertIncidence(stgMessage,stgtype,idCurrentCase,idCurrentId);
        }

        return lstfoundDocuments;
    }

    public class ResponseWrapper {
        public ReferenceRs Out_ConsultaReferencias;
    }

    public class ReferenceRs {
        public ReferenceData employedServiceRs;
    }

    public class ReferenceData {
        public String isSucessful;
        public References references;

    }

    public class References {
        public List<Reference> reference;
    }

    public class Reference {
        public String isUpdateData;
        public String nameReferences;
        public String fatherLastNameReference;
        public String motherLastNameReference;
        public String curpReference;
        public String stateBirthReference;
        public String birthDateReference;
        public String genderReference;
        public String phoneRefernce;
        public String typePhoneReference;
    }
}