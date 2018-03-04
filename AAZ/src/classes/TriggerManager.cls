public class TriggerManager {
	private static Set<String> inactivatedTriggers = new Set<String>();

    public static boolean isInactive(String triggername){
        if(inactivatedTriggers.contains(triggername)){
            return true;
        }else{
            return false;
        }
    }

    public static void inactivate(String triggername) {
        inactivatedTriggers.add(triggername);
    }
}