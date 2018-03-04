@isTest
private class AAZ_RelatedRejectionsCmpTest_tst {

    @isTest static void should_get_rejection_reasons_by_document() {
		
		Case objCase = new Case(Origin = 'Phone', employeeNumber__c = '1234');
		insert objCase;

		AAZ_RelatedRejectionsCmp_ctr controller = new AAZ_RelatedRejectionsCmp_ctr();
		controller.thisCaseId = objCase.Id;
		Case createdCase = controller.objCase;
		controller.getLstReasonsByDocument();
		controller.getLstReasonsByProcedure();

	}

}