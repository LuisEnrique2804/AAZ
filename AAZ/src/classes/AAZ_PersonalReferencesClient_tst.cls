@isTest
public class AAZ_PersonalReferencesClient_tst {
    
    
    @isTest static void test_method_one() {
   Test.startTest();
    
    List<Id> lstCaseIds = new List<Id> ();
    
   Case caso1 = new Case ();
  //caso1.CaseNumber=3333;
    caso1.FolioNSS__c='teste';
    insert caso1;
   
    Case caso2 = new Case ();
  //caso2.CaseNumber=222;
    caso2.FolioNSS__c='teste2';
    insert caso2;
    
   lstCaseIds.add(caso1.id);
   lstCaseIds.add(caso2.id);
    
   AAZ_PersonalReferencesClient_cls.getPersonalReferencesAsync(lstCaseIds);
     		
           }


}