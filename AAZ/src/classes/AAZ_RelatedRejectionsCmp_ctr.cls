/*******************************************************************************
Desarrollado por: Avanxo México
Autor: Daniel Peñaloza
Proyecto: Banco Azteca - Afore
Descripción: Controlador para componente de Motivos de Rechazo

------ ---------- -------------------------- -----------------------------------
No.    Fecha      Autor                      Descripción
------ ---------- -------------------------- -----------------------------------
1.0    03/08/2017 Daniel Peñaloza            Clase creada
*******************************************************************************/

public class AAZ_RelatedRejectionsCmp_ctr {

    // Id de Caso
	public String thisCaseId { get; set; }

    // Instancia de Objeto Caso
    public Case objCase {
        get {
            if (this.objCase == null) {
                String strCaseQuery = 'SELECT ' + String.join(new List<String>(SObjectType.Case.Fields.getMap().keySet()),', ')+' FROM Case WHERE Id = \'' + this.thisCaseId + '\'';
                this.objCase = Database.query(strCaseQuery);
            }
            return objCase;
        }
        private set;
    }

    /**
     * Obtener Motivos de Rechazo por Documento
     * @return Lista de Motivos de Rechazo
     */
    public List<ReasonRejection__c> getLstReasonsByDocument() {
        Document__c[] lstDocuments = [SELECT Id FROM Document__c WHERE RelatedProcedure__c = :thisCaseId];
        return new List<ReasonRejection__c>([
            SELECT Id, Name, Document__c, Document__r.DocumentTypeId__c, Document__r.DocumentType__c
            FROM ReasonRejection__c
            WHERE Document__c IN :lstDocuments
        ]);
    }

    /**
     * Obtener Motivos de Rechazo por Trámite
     * @return Lista de Motivos de Rechazo
     */
    public List<ReasonRejection__c> getLstReasonsByProcedure() {
        return new List<ReasonRejection__c>([
            SELECT Id, Name
            FROM ReasonRejection__c
            WHERE ProcedureId__c = :thisCaseId
        ]);
    }
}