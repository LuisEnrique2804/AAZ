/*******************************************************************************
Desarrollado por: Avanxo México
Autor: Daniel Peñaloza
Proyecto: Banco Azteca - Afore
Descripción: Clase para servicio de Aprobación/Rechazo de trámites

------ ---------- -------------------------- -----------------------------------
No.    Fecha      Autor                      Descripción
------ ---------- -------------------------- -----------------------------------
1.0    26/07/2017 Daniel Peñaloza            Clase creada

WS003
*******************************************************************************/

public class AAZ_ApprovalProcessService_cls {

    private static final String strConfigName = 'Afore_ApprovalRejectProcess'; // Afore_ApprovalRejectProcess

    // Enviar un trámite para registrar aprobación/rechazo
    public static Boolean sendForApproval(SObject[] lstRequestObjects, Map<String, Object> mapExtraAttrs, Boolean blnIsAppoved) {
        Boolean isSuccessful = false;
        System.debug(loggingLevel.Error, '*** lstRequestObjects: ' + lstRequestObjects);
        System.debug(loggingLevel.Error, '*** blnIsAppoved: ' + blnIsAppoved);
        //Map<String, Object> mapRequest = new  Map<String, Object>();
        //Map<String, Object> mapResponse = new Map<String, Object>();
        //String strJsonRequest = '';
        //String strJsonResponse = '';
        //try{mapRequest = AAZ_GenericCallout_cls.generateRequestMap(strConfigName, lstRequestObjects, mapExtraAttrs);}catch(NullPointerException nPE){}catch(UnexpectedException uE){}catch(Exception gE){}  
        //if(!mapRequest.isEmpty()){
        //    try{strJsonRequest = JSON.serializePretty(mapRequest);}catch(SerializationException sE){}catch(Exception gE){} 
        //    System.debug('strJsonRequest : '+strJsonRequest);
        //}
        //if(!String.isBlank(strJsonRequest)){
        //    try{strJsonResponse = AAZ_GenericCallout_cls.fn_runCallout(strJsonRequest, strConfigName, null);}catch(CalloutException cE){}catch(UnexpectedException uE){}catch(Exception gE){}
        //    System.debug('strJsonResponse : '+strJsonResponse);
        //}
        //if(!String.isBlank(strJsonResponse)){
        //    try{mapResponse = AAZ_GenericCallout_cls.processServiceResponse(strJsonResponse, strConfigName);}catch(NullPointerException nPE){}catch(UnexpectedException uE){}catch(Exception gE){}          
        //}
        //if(!mapResponse.isEmpty()){
        //    isSuccessful = Boolean.valueOf(mapResponse.get('isSuccessful'));
        //}
        return isSuccessful;
    }
}