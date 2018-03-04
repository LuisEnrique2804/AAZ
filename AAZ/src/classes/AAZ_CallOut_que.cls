public class AAZ_CallOut_que implements Queueable, Database.AllowsCallouts {

	public Set<Id> setIdProcedure {get;set;}

	public void execute(QueueableContext context) {
        AAZ_CallOutFuture_cls.callOuts(this.setIdProcedure);
	}
}