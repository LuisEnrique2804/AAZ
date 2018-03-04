global class AAZ_UpdateBulkCase_bch implements Database.Batchable<sObject> {
	
	String query;
	
	global AAZ_UpdateBulkCase_bch() {
		
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<sObject> scope) {
	
	}
	
	global void finish(Database.BatchableContext BC) {
		
	}
	
}