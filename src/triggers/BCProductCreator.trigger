trigger BCProductCreator on Product2 (after insert, after update) {
    if(Trigger.isInsert){
    	BCProductCreatorHelper.doCreateBCProduct(Trigger.newMap.keySet()); 
    }
    if(Trigger.isUpdate){
    	BCProductCreatorHelper.doUpdateBCProduct(Trigger.oldMap.keySet(), Trigger.newMap.keySet());
    }
}