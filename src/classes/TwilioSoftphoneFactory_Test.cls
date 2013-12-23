/**
* @Author    : VW
* @Purpose   : Test Factory Class
*/
@isTest
public class TwilioSoftphoneFactory_Test {

    // Constants    
    public static String TEST_CONTACT_NAME = 'Test Contact';
    public static String TEST_ACCOUNT_NAME = 'Test Account';
    public static String TEST_LEAD_NAME = 'Test Lead';
    public static String TEST_COMPANY_NAME = 'Test Company';
    public static String TEST_CAMPAIGN_NAME = 'Test Campaign';
    public static String TEST_PHONE_NUMBER = '+918881114444';
    public static String TEST_MOBILE_NUMBER = '+91777111444';   
    public static String TEST_FORMATTED_NUMBER = '+91 (666) 111-444';   
    
    public static testMethod Contact getContact(){
        Account account = getAccount();
        Contact contact = new Contact( Lastname= TEST_CONTACT_NAME, Account = account, Phone = TEST_PHONE_NUMBER, MobilePhone = TEST_MOBILE_NUMBER);
        insert contact;
        return contact;
    } 
    
    public static testMethod Contact getContact_withoutPhone(){
        Account account = getAccount();
        Contact contact = new Contact( Lastname= TEST_CONTACT_NAME, Account = account);
        insert contact;
        return contact;
    }
    
    public static List<Contact> getContactsList(Integer count){
        Account account = getAccount();
        Contact contact;
        List<Contact> contactsList = new List<Contact>();
        
        for ( Integer i = 0; i < count; i++){
            contact = new Contact( Lastname= TEST_CONTACT_NAME, Account = account, Phone = TEST_PHONE_NUMBER, MobilePhone = TEST_MOBILE_NUMBER);
            contactsList.add(contact);
        }
        insert contactsList;
        return contactsList;
    }
    
    public static testMethod Account getAccount(){
        Account account = new Account(Name = TEST_ACCOUNT_NAME);
        insert account;
        return account;
    }
    
    public static testMethod Lead getLead(){
        Lead lead = new Lead(LastName = TEST_LEAD_NAME , Company = TEST_COMPANY_NAME, Phone = TEST_PHONE_NUMBER, MobilePhone = TEST_FORMATTED_NUMBER);
        insert lead;
        return lead;
    }
    
    public static testMethod Lead getLead_withoutPhone(){
        Lead lead = new Lead(LastName = TEST_LEAD_NAME , Company = TEST_COMPANY_NAME);
        insert lead;
        return lead;
    }
    
    public static List<Lead> getLeadsList(Integer count){
        
        Lead lead;
        List<Lead> leadsList = new List<Lead>();
        
        for ( Integer i = 0; i < count; i++){
            lead = new Lead( LastName = TEST_LEAD_NAME , Company = TEST_COMPANY_NAME, Phone = TEST_PHONE_NUMBER, MobilePhone = TEST_MOBILE_NUMBER);
            leadsList.add(lead);
        }
        insert leadsList;
        return leadsList;
    }
   
}