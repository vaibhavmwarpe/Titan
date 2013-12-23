public with sharing class VWDynamicBindingExtn {
    private final Contact contact;
    public VWDynamicBindingExtn(ApexPages.StandardController controller) {
        this.contact= (Contact)controller.getRecord();
    }
    
    public List<Contact> getAllContacts(){
        return [SELECT Id, LastName, Contact.Name, AccountId, Account.Name FROM Contact LIMIT 20];
    }
    
    public List<String> getAllContactFields(){
        List<String> fieldsList = new List<String>();
        /*for(Schema.SObjectField tempField : Schema.SObjectType.Contact.fields.getMap().values()){
                        
            fieldsList.add(String.valueOf(tempField));
        } */
        fieldsList.add('Id');
        fieldsList.add('LastName');

        
        System.debug('==in getAllContactFields()==fieldsList====' +fieldsList );
        return fieldsList;
    }

}