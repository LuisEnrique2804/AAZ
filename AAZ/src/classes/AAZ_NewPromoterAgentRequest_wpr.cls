/****************************************************************************************
	Desarrollado por:  Avanxo México
	Autor:             René Ayala Medina
	Proyecto:          Mesa de Control Afore Azteca
	Descripción:       Clase de APEX que se utiliza para deserializar la solicitud en el servicio "Alta de agente promotor"
	Cambios (Versiones)     
	-------------------------------------     
	  No.      Fecha                  Autor                      Descripción     
	------  -------------  ------------------------------   ----------------------    
	 1.0      01-08-2017    René Ayala Medina RAM            Creacion
****************************************************************************************/

global class AAZ_NewPromoterAgentRequest_wpr {
	
	global class NewAgent{
		global String employeeNumber;	
		global String nss;
		global String paternalLastName;	
		global String maternalLastName;
		global String firstName;
		global Date admitionDate;
		global String schoolGrade;	
		global Date birthDate;	
		global Integer shopNumber;
		global String shopName;
		global String zone;
		global String state;
	}

}