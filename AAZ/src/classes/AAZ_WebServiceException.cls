/*******************************************************************************
Desarrollado por: Avanxo México
Autor: Daniel Peñaloza
Proyecto: Banco Azteca - Service Cloud
Descripción: Excepción personalizada para especificar errores en el consumo de Servicios Web

------ ---------- -------------------------- -----------------------------------
No.    Fecha      Autor                      Descripción
------ ---------- -------------------------- -----------------------------------
1.0    02/02/2017 Daniel Peñaloza            Clase creada
1.1    30/03/2017 Daniel Peñaloza            Constructor para utilizar en log de exceptiones (req, res)
*******************************************************************************/
public class AAZ_WebServiceException extends Exception{

    public EndpointSetting__mdt endpointSetting { get; set; }
    public String message     { get; set; }
    public String strRequest  { get; set; }
    public String strResponse { get; set; }
    
    public AAZ_WebServiceException(EndpointSetting__mdt endpointSetting, String message, String strRequest, String strResponse){
        this.endpointSetting = endpointSetting;
        this.message = message;
        this.strRequest = strRequest;
        this.strResponse = strResponse;
    }
}