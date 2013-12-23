public with sharing class VFWorkbookPageCon {

    public List<Contact> getAllContacts() {
        return [SELECT Id, Name, LastName, Email, Phone FROM Contact WHERE Email != '' ORDER BY Email DESC LIMIT 10];
    }

}