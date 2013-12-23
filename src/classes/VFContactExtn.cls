public with Sharing class VFContactExtn {

    public Integer currentContactsCount {get;set;}
    
    public List<Contact> getContactsList(){
        List<Contact> tempContacts = [SELECT Id, Name, AccountId, Department, Email, LeadSource, MobilePhone FROM Contact];
        currentContactsCount = tempContacts.size();
        return tempContacts;
    }

}