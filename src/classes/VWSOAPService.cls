global class VWSOAPService{
    webservice static String createContact(String lastName){
        Contact con = new Contact(LastName = lastName);
        insert con;
        return con.id;
    }
}