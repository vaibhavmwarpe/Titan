public with sharing class BCSchedulerCon {

    public String jobId { get; set; }

    public Boolean isJobCreateSuccess { get; set; }
    
    public BCSchedulerCon (){
        isJobCreateSuccess = False;
    }

    public PageReference doSchedule() {
        String CRON_STRING = '0 13 19 * * ?';
        //jobId  = System.schedule( 'Notify Inventory Manager', CRON_STRING, new BCNotifyInventoryManager());
        jobId  = System.schedule( 'BC Product Creation From Apex', CRON_STRING, new BCNewProductsCreator());
        isJobCreateSuccess = True;
        return null;
    }

}