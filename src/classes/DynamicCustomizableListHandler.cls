public class DynamicCustomizableListHandler {
    private Apexpages.StandardSetController controller;
    private Set<String> unselectedFieldNames = new Set<String>();
    private Set<String> selectedFieldNames = new Set<String>();
    private Set<String> inaccessibleFieldNames = new Set<String>();  
      
    public DynamicCustomizableListHandler(ApexPages.StandardSetController stdSetCon) {
        this.controller = stdSetCon;
        loadFieldsAccessibility();
    }
    private void loadFieldsAccessibility(){
        Map<String, Schema.SobjectField> accFieldsMap = Schema.SobjectType.Account.Fields.getMap();
        for(String tempField : accFieldsMap.keySet()){
            if(tempField != 'Name'){
                unselectedFieldNames.add(tempField);                             
            }
            if(!accFieldsMap.get(tempField).getDescribe().isAccessible()){
                inaccessibleFieldNames.add(tempField);            
            }                
        }
    }
    
}