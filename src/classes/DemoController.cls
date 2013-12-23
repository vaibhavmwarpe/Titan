global with sharing class DemoController {

    public static List<sObject> contactsList { get; set; }
    public static List<sObject> leadsList { get; set; }
    public static List<sObject> sObjsList { get; set; }
    
    global DemoController (){
    
    }
        
    @RemoteAction
    global static List<sObject> getSFRecord(String tempPhoneNumber) {
                
        contactsList = [SELECT Id, Name, Phone FROM Contact WHERE Phone LIKE : '%'+tempPhoneNumber+'%' LIMIT 10];
        leadsList = [SELECT Id, Name, Phone FROM Lead WHERE Phone LIKE : '%'+tempPhoneNumber+'%' LIMIT 10];
        sObjsList = new List<sObject>();
        
        if(contactsList != null && contactsList.size() > 0){
            sObjsList.addAll(contactsList);
        }
        
        if(leadsList != null && leadsList .size() > 0){
            sObjsList.addAll(leadsList);
        }

        return sObjsList;
    }
}