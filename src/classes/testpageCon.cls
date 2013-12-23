global with sharing class testpageCon {

    public PageReference sendSMS() {
        return null;
    }


    public String smsMessage { get; set; }

    public String calleeNumber { get; set; }
    
    public String phoneNumber{ get; set; }
    public static Contact contact { get; set; }    
    
    @RemoteAction
    global static Contact getContact(String tempPhoneNumber) {
        contact = [SELECT Id, Name, Phone FROM Contact WHERE Phone LIKE : '%'+tempPhoneNumber+'%'];
        return contact;
    }
}