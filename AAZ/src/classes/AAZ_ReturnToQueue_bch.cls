global class AAZ_ReturnToQueue_bch implements Database.Batchable<sObject> {
	
	String query;

	global AAZ_ReturnToQueue_bch(String strQueryStatement){
		query = strQueryStatement;
	}

	global Database.QueryLocator start(Database.BatchableContext BC){
		return Database.getQueryLocator(query);
	}

	global void execute(Database.BatchableContext BC, List<Case> scope){
		AAZ_ReturnToQueue_cls.returnToQueue(scope);
	}

	global void finish(Database.BatchableContext BC){}
	
}