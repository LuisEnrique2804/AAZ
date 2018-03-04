public class Delete_Historial_ctr {

    public date datFecha{get;set;}
    public Delete_Historial_ctr()
    {
       List<SearchHistoricalProcess_cnf__c> cnfHistorial=[select id,name,Min_Date__c from SearchHistoricalProcess_cnf__c where name='Historial'];
       
       if(cnfHistorial.size()>0)
       {
          datFecha=cnfHistorial[0].Min_Date__c;
       }
       
    } 
    /**
    guarda la fecha de borrado en la configuracion personalizada
    
    ***/
    public PageReference Guardar()
    {
       List<SearchHistoricalProcess_cnf__c> cnfHistorial=[select id,name,Min_Date__c from SearchHistoricalProcess_cnf__c where name='Historial'];
       
       if(cnfHistorial.size()>0)
       {
          cnfHistorial[0].Min_Date__c =datFecha;
          update cnfHistorial;
          
          ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, 'Operación Existosa.');
          ApexPages.addMessage(msg);
       }else
       {
          ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'No existen registros en la configuración personalizada.');
          ApexPages.addMessage(msg);
       
       }
       
       
       
       return null;
    }
    

}