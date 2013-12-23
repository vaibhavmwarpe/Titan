global class VWSoapWS{
    webservice static List<Contact> getAllContacts(){
    	return [SELECT Id, Name, AccountId FROM Contact LIMIT 10];
    }
}