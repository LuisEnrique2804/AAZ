/*****************************************************************************************************
Desarrollado por: Avanxo México
Autor: Luis Enrique Garcia 
Proyecto: Elektra
Descripción: Clase WRAPPER (envoltorio) de APEX que realiza la función encriptacion y desencriptacion
    de los mensajes, asi como la generaacion del token.

------ ---------- -------------------------- -----------------------------------
No.    Fecha      Autor                      Descripción
------ ---------- -------------------------- -----------------------------------
1.0    30/06/2017  Luis Enrique Garcia        Clase creada
*******************************************************************************************************/

public with sharing class AAZ_ServiceTokenResponse_wpr {

    public RefreshTokenRs signToken;

	public class RefreshTokenRs {
		public String signedToken;
		public String expiration;
	}

	/*
        Método que convierte una cadena JSON a una instancia de la clase "AAZ_ServiceTokenResponse_wpr"
    */

	public static AAZ_ServiceTokenResponse_wpr parse(String json) {
		AAZ_ServiceTokenResponse_wpr wrappInstance = new AAZ_ServiceTokenResponse_wpr();
		try{wrappInstance = (AAZ_ServiceTokenResponse_wpr) System.JSON.deserialize(json, AAZ_ServiceTokenResponse_wpr.class);}catch(SerializationException sE){}catch(Exception gE){}
		return wrappInstance;
	}

}