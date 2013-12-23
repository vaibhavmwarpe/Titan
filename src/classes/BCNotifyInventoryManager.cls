public class BCNotifyInventoryManager implements System.Schedulable{
    public void execute(SchedulableContext sc){
    	BCNotifyInventoryManagerHelper tempHelper = new BCNotifyInventoryManagerHelper();
        tempHelper.sendEmailToManager();
    }
}