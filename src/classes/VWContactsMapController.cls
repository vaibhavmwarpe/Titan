public without sharing class VWContactsMapController {

    public String recordID {get;set;}
    public VWContactsMapController(ApexPages.StandardController controller) {
        recordID = System.currentPageReference().getParameters().get('Id');
    }
    //a method to serialize the contact records...
    public String getContactsJson() {
        List<Contact> contactsList = [  SELECT Id, Name, Email, Account.Name,
                                        MailingStreet, MailingCity, MailingPostalCode, MailingState, MailingCountry, 
                                        Location__Latitude__s, Location__Longitude__s FROM Contact WHERE id =: recordID];
                                        
        if(contactsList != null && contactsList.size() > 0)
           return JSON.serialize(contactsList);
        return null;
    }
}