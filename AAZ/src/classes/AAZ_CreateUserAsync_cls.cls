/****************************************************************************************
	Desarrollado por:  Avanxo México
	Autor:             Luis Enrique Garcia Sanabria 
	Proyecto:          Mesa de Control Afore
	Descripción:       Clase de para crear un usuario en TIBCO de forma asincrona
	Cambios (Versiones)     
	-------------------------------------     
	  No.      Fecha                  Autor                      Descripción     
	------  -------------  ------------------------------   ----------------------    
	 0.1     08-08-2017    Luis Enrique Garcia Sanabria     Creacion
	 0.2     08-08-2017    Luis Enrique Garcia Sanabria     Construcción
	 1.0     08-08-2017    Luis Enrique Garcia Sanabria     Finalización y documentación
****************************************************************************************/
public class AAZ_CreateUserAsync_cls implements Queueable, Database.AllowsCallouts{
	// Usuario a dar de alta
    public User usr { get; set; }

    /**
     * Implementación del método execute, que permite ejecutar un acción de forma asíncrona
     * @param context Contexto Queable
    */
    
    public void execute(QueueableContext context) {
        AAZ_SecurityServices_cls.createTibcoUser(this.usr.Id);
    }
}