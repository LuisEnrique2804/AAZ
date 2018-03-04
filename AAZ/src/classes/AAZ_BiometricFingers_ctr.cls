/**
 * Desarrollado por:  Avanxo México
 * Autor:       Samuel Galindo Rodríguez
 * Proyecto:    Afore Azteca
 * Descripción: Clase para seleccionar la huella del biometrico
 *
 * Cambios (Versiones)
 * -------------------------------------
 * No.     Fecha        Autor                         Descripción
 * ------  ----------   -------------                 ------------
 * 1.0     29-08-2017   Samuel Galindo                Crea la clase
 */
public class AAZ_BiometricFingers_ctr {

    /**
     * Lista opciones dedo 1
     * @type List
     */
	public List<SelectOption> lstDedo1{set;get;}


	/**
	 * Lista opciones 2 dedos
	 * @type List
	 */
	public List<SelectOption> lstDedo2{set;get;}

	/**
	 * Opción seleccionada dedo 1
	 * @type String
	 */
	public String strOpcionDedo1{set;get;}

	/**
	 * Opción seleccionada dedo 2
	 * @type String
	 */
	public String strOpcionDedos2{set;get;}

	/**
	 * Datos Usuario
	 * @type User
	 */
	public User userInstance{set;get;}


	/**
	 * Variable para mostrar el mensaje de exito
	 *
	 */
	public Boolean blnSuccess{set;get;}

	/**
	 * Constuctor de la clase
	 *
	 */
	public AAZ_BiometricFingers_ctr()
	{

    	lstDedo1 = new List<SelectOption>();

    	lstDedo2 = new List<SelectOption>();

    	strOpcionDedo1 = '';

    	strOpcionDedos2 = '';

    	blnSuccess = false;

        String strQueryOverCasesStatement = 'SELECT '+String.join(
          new List<String>(SObjectType.User.Fields.getMap().keySet()), ', ')+
          ' FROM User WHERE Id = \''+UserInfo.getUserId()+'\'';
        userInstance = Database.query(strQueryOverCasesStatement);

        strOpcionDedo1 = userInstance.settings1Finger__c;

        strOpcionDedos2 = userInstance.settings2Finger__c;

    	Schema.DescribeFieldResult fieldResult = User.settings1Finger__c.getDescribe();
    	List<Schema.PicklistEntry> lst = fieldResult.getPicklistValues();
    	for ( Schema.PicklistEntry f : lst)
    	{
			lstDedo1.add(new SelectOption(f.getValue(), f.getLabel()));
    	}

    	Schema.DescribeFieldResult fieldResult2 = User.settings2Finger__c.getDescribe();
    	List<Schema.PicklistEntry> lst2 = fieldResult2.getPicklistValues();
    	for ( Schema.PicklistEntry f2 : lst2)
    	{
			lstDedo2.add(new SelectOption(f2.getValue(), f2.getLabel()));
    	}
    }

    /**
     * Función para guardar los dedos del biometrico
     * @type void
     */
    public void biometricFingersSave() {

    		userInstance.settings1Finger__c = strOpcionDedo1;

				userInstance.settings2Finger__c = strOpcionDedos2;

    		update userInstance;

    		blnSuccess = true;
    }

}