global class DeleteHistoricalProcess_sch  implements Schedulable {

    global void execute(SchedulableContext sc)
    {
         DeleteHistoricalProcess_bch bachHitorical=new DeleteHistoricalProcess_bch();
         bachHitorical.strFecha='';
         
         List<SearchHistoricalProcess_cnf__c> cnfHistorial=[select id,name,Min_Date__c,SolicitudId__c from SearchHistoricalProcess_cnf__c where name='Historial'];
         if(cnfHistorial.size()>0)
         {
             bachHitorical.strFecha=String.ValueOf(cnfHistorial[0].Min_Date__c);
             bachHitorical.strSolicitudId=cnfHistorial[0].SolicitudId__c;
             if(bachHitorical.strFecha!=null&&bachHitorical.strFecha.length()>0)database.executeBatch(bachHitorical,2000);
         }
         
    }
 }