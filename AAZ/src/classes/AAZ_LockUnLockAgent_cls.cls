/*******************************************************************************
Desarrollado por: Avanxo México
Autor: Luis E. Garcia
Proyecto: Afore Azteca
Descripción: Clase para servicio de Bloque y desbloqueo del agente (WS004)

------ ---------- -------------------------- -----------------------------------
No.    Fecha      Autor                      Descripción
------ ---------- -------------------------- -----------------------------------
1.0    26/07/2017 Luis E. Garcia           Clase creada
*******************************************************************************/
public class AAZ_LockUnLockAgent_cls {
	private static final String strOrdersQueryConfigCode = 'BloqueoDesbloqueoAgentes';

    public static Contact getLockUnlockAPList(List<Contact> lstSObjects, Map<String, Object> mapExtraAttrs){
        Boolean blnServiceHadError      = false;
        string  stgMessage              = '';
        String  stgtype                 = 'Web Service';
        id      idCurrentCase;
        id      idCurrentId             = UserInfo.getUserId();
        Contact stausContact            = new Contact();
        String  strRequest              = '';
        String  strResponse             = '';
        Boolean blnIsSuccesful          = false;
        Map<String, Object> mapRequest  = new Map<String, Object>();
        Map<String, Object> mapResponse = new Map<String, Object>();
        ResponseWrapper     responseWp  = new ResponseWrapper();

        System.debug(loggingLevel.Error, '*** lstSObjects.BlockReasons__c: ' + lstSObjects[0].BlockReasons__c);
        strRequest = JSON.serializePretty(
            new Map<String,Object>{ 
                'In_BloqueoDesbloqueoAgentes' => new Map<String,Object>{
                    'lockServiceRq' => new Map<String,Object>{
                        'option'=> (lstSObjects[0].Status__c == 'ACTIVO' || lstSObjects[0].Status__c == 'unlock' )?'lock':'unlock',
                        'reasons'=>(lstSObjects[0].Status__c == 'ACTIVO' || lstSObjects[0].Status__c == 'unlock' )? lstSObjects[0].BlockReasons__c:' ', 
                        'employedNumber'=>lstSObjects[0].EmployeeNumber__c
                    }
                }
            }
        );
        System.debug(loggingLevel.Error, '*** strRequest: ' + strRequest);

        if(strRequest != null || strRequest != '') {
            try{strResponse = AAZ_GenericCallout_cls.fn_runCallout(strRequest, strOrdersQueryConfigCode, null);}catch(CalloutException cE){blnServiceHadError = true;stgMessage = cE.getMessage();}catch(UnexpectedException uE){blnServiceHadError = true;stgMessage = uE.getMessage();}catch(Exception gE){blnServiceHadError = true;stgMessage = gE.getMessage();}
            System.debug(loggingLevel.Error, '*** strResponse: ' + strResponse);
            if (String.isNotBlank(strResponse) && strResponse != null) {
                try {responseWp = (ResponseWrapper)JSON.deserialize(strResponse, ResponseWrapper.class);} catch(Exception e) {System.debug(loggingLevel.Error, '*** e: ' + e);}
                System.debug(loggingLevel.Error, '*** responseWp: ' + responseWp);
                if(responseWp.Out_BloqueoDesbloqueoAgentes != null) {
                    if(responseWp.Out_BloqueoDesbloqueoAgentes.lockServiceRs != null) {
                        if(responseWp.Out_BloqueoDesbloqueoAgentes.lockServiceRs.isSucessful) {
                            if(responseWp.Out_BloqueoDesbloqueoAgentes.lockServiceRs.newStatus != null || responseWp.Out_BloqueoDesbloqueoAgentes.lockServiceRs.newStatus != '') {
                                stausContact.Status__c = responseWp.Out_BloqueoDesbloqueoAgentes.lockServiceRs.newStatus;
                                System.debug(loggingLevel.Error, '*** stausContact.Status__c: ' + stausContact.Status__c);
                            }
                        }
                    }
                }
            }
        }



        //if(blnServiceHadError) {
        //    AAZ_Utils_cls.insertIncidence(stgMessage,stgtype,idCurrentCase,idCurrentId);
        //}
        return stausContact;
    }

    public class ResponseWrapper {
        public InLockUnlock Out_BloqueoDesbloqueoAgentes;
    }

    public class InLockUnlock {
        public LockUnlockService lockServiceRs;
    }

    public class LockUnlockService {
        public String newStatus;
        public Boolean isSucessful;
        public ErrorIm errorList;

    }

    public class ErrorIm {
        public List<Error> errorItem;
    }

    public class Error {
        public String code;
        public String description;
    }

}