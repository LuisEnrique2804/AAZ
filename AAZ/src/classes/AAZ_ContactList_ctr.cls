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
public class AAZ_ContactList_ctr {

    public List<Case> lstCase {set;get;}

    public List<Schema.FieldSetMember> lstFieldSetMembers {set;get;}

    public AAZ_ContactList_ctr(ApexPages.StandardController stdr) {

        lstCase = new List<Case>();

        lstFieldSetMembers = new List<Schema.FieldSetMember>();

        String strQueryCases = 'SELECT '+String.join(
          new List<String>(SObjectType.Case.Fields.getMap().keySet()), ', ') +
          ' , Owner.Name FROM Case WHERE ContactId = \''+stdr.getId()+'\' AND complaintsAndTrades__c= \'\' ORDER BY CaseNumber';
        lstCase = Database.query(strQueryCases);

        Schema.FieldSet fs = Schema.SObjectType.Case.fieldSets.getMap().get('ListProcessContact');
        lstFieldSetMembers = fs.getFields();
    }
}