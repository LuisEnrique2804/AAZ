/****************************************************************************************
	Desarrollado por:  Avanxo México
	Autor:             René Ayala Medina
	Proyecto:          Mesa de Control Afore Azteca
	Descripción:       Clase de APEX que se utiliza para deserializar la respuesta del servicio de "Alta de trámite"
	Cambios (Versiones)     
	-------------------------------------     
	  No.      Fecha                  Autor                      Descripción     
	------  -------------  ------------------------------   ----------------------    
	 1.0      01-08-2017    René Ayala Medina RAM            Creacion
****************************************************************************************/

global class AAZ_ResponseNewProcedure_wpr {
	
	global Boolean isSuccessful; 
	global String transactionId;
	global String result;
	global List<Error> errorList;

	global class Error{
		global String code;
		global String description;
	} 
}