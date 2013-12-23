trigger VWContactsMapTrigger on Contact (after insert, after update) {
    
    if(Trigger.isInsert || Trigger.isUpdate){    
        System.debug('=======in trigger contact====Trigger.newMap.keySet()=====' + Trigger.newMap.keySet());
        //VWContactsMapHelper.serverSideGeocode(Trigger.newMap.keySet());
        
    }    
}