global class AAZ_ReturnToQueue_sch  implements Schedulable {
	global void execute(SchedulableContext sc){
    	List<String> lstFilterOwnerParams = new List<String>{
      		'Owner.Profile.Name = \'Analista Validador\''
    	};
    	
    	List<String> lstFilterANDParams = new List<String>{
      		'( '+String.join(lstFilterOwnerParams,' AND ')+' )',
      		'isClosed = false'
		};
    	
    	
    	String strQueryOverOpenCasesSttmnt = 'SELECT Id, Owner.UserRole.DeveloperName FROM Case WHERE ( '+String.join(lstFilterANDParams,' AND ')+' )';
    	
    	AAZ_ReturnToQueue_bch bchInstance = new AAZ_ReturnToQueue_bch(strQueryOverOpenCasesSttmnt);
    	Database.executeBatch(bchInstance,200);
  }

}