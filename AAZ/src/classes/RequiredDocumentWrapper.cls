public class RequiredDocumentWrapper implements Comparable {
    public RequiredDocument__mdt reqDocument { get; set; }
    
    public RequiredDocumentWrapper(RequiredDocument__mdt reqDocument) {
        this.reqDocument = reqDocument;
    }    
    
    public Integer compareTo(Object compareTo) {
        RequiredDocumentWrapper objToCompare = (RequiredDocumentWrapper) compareTo;
        Integer defaultOrder = 1000;
        
        Decimal currentOrder = this.reqDocument.RelatedDocumentType__r.ListOrder__c == null ? defaultOrder : this.reqDocument.RelatedDocumentType__r.ListOrder__c;
        Decimal nextOrder = objToCompare.reqDocument.RelatedDocumentType__r.ListOrder__c == null ? defaultOrder : objToCompare.reqDocument.RelatedDocumentType__r.ListOrder__c;
        
        Integer returnValue = 0;
        if (currentOrder > nextOrder) {
            returnValue = 1;
        } else if (currentOrder < nextOrder) {
            returnValue = -1;
        } else {
            returnValue = 0;
        }
        
        return returnValue;
    }
}