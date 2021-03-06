/*******************************************************************************
Desarrollado por: Avanxo México
Autor: Daniel Peñaloza
Proyecto: Banco Azteca - Afore
Descripción: Trigger principal para eventos en objeto Caso

------ ---------- -------------------------- -----------------------------------
No.    Fecha      Autor                      Descripción
------ ---------- -------------------------- -----------------------------------
1.0    01/08/2017 Daniel Peñaloza            Clase creada
1.1    24/08/2017 Luis E. Garcia             Adiccion de llamados a los servicios
*******************************************************************************/

trigger AAZ_CaseMainTrigger_tgr on Case (after insert, before update, after update) {
	if(!TriggerManager.isInactive('AAZ_CaseMainTrigger_tgr')) {	
		if(Trigger.isBefore) {
			if(Trigger.isUpdate) {
				AAZ_CallOutFuture_cls.approveRejectProcedure(Trigger.newMap, Trigger.oldMap);
			}
		}
		else {
			if(trigger.isInsert) {
				AAZ_CallOut_que callOutProcedure = new AAZ_CallOut_que();
				callOutProcedure.setIdProcedure = Trigger.newMap.keySet();
				if(!Test.isRunningTest()){
					String jobId = System.enqueueJob(callOutProcedure);
				}
			}else if (trigger.isUpdate) {
				AAZ_CallOutFuture_cls.revalidateProcedure(Trigger.newMap, Trigger.oldMap);
			}
		}
	}
}