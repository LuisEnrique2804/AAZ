/*******************************************************************************
Desarrollado por: Avanxo México
Autor: Samuel Galindo Rodríguez
Proyecto: Afore Azteca
Descripción: Controlador personalizado para la página Visualforce en donde se
visualizara los trámites(Casos)

-------------------------------------
No.    Fecha      Autor                          Descripción
------ ---------- ----------------------------- -----------
1.0    25-10-2017 Samuel Galindo Rodríguez      Creación
*******************************************************************************/
public class AAZ_AccountList_ctr {

    public List<Case> lstCase {set;get;}

    public List<Schema.FieldSetMember> lstFieldSetMembers {set;get;}

    public AAZ_AccountList_ctr(ApexPages.StandardController stdr) {

        lstCase = new List<Case>();

        lstFieldSetMembers = new List<Schema.FieldSetMember>();

        String strQueryCases = 'SELECT '+String.join(
          new List<String>(SObjectType.Case.Fields.getMap().keySet()), ', ') +
          ' ,Contact.Name FROM Case WHERE AccountId= \''+stdr.getId()+'\' AND complaintsAndTrades__c= \'\' ORDER BY CaseNumber';
        lstCase = Database.query(strQueryCases);

        Schema.FieldSet fs = Schema.SObjectType.Case.fieldSets.getMap().get('ListProcess');
        lstFieldSetMembers = fs.getFields();
    }
}