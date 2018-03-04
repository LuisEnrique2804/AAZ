/*******************************************************************************
Desarrollado por: Avanxo México
Autor: Luis Enrique Garcia 
Proyecto: Afore Azteca
Descripción: Clase wrapper para procesar respuesta de servicio de Alta de Usuarios en TIBCO

------ ---------- -------------------------- -----------------------------------
No.    Fecha      Autor                      Descripción
------ ---------- -------------------------- -----------------------------------
1.0    30/06/2017 Luis Enrique Garcia         Clase creada
*******************************************************************************/
public class AAZ_UserResponseWrapper_wpr {

    public AddUserRs signToken;
    public Errors genericResponse;
    public Boolean isSuccessful;

    public class AddUserRs {
        public String username;
        public String signedToken;
        public String expiration;
    }

    public class Errors{
        public Error Response;  
    }

    public class Error{
        public String code;
        public String message;       
    }

    /*
        Método que convierte una cadena JSON a una instancia de la clase "AAZ_UserResponseWrapper_wpr"
    */

    public static AAZ_UserResponseWrapper_wpr parse(String json) {
        AAZ_UserResponseWrapper_wpr wrappInstance = new AAZ_UserResponseWrapper_wpr();
        try{wrappInstance = (AAZ_UserResponseWrapper_wpr) System.JSON.deserialize(json, AAZ_UserResponseWrapper_wpr.class);}catch(SerializationException sE){}catch(Exception gE){}
        System.debug(loggingLevel.Error, '*** wrappInstance: ' + wrappInstance);
        return wrappInstance;
    }
}