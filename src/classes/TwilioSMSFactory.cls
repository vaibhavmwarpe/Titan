/**
* @Author    : VW
* @Purpose   : Test Factory Class
*/
@isTest
public class TwilioSMSFactory {

    // Constants    
    public static String TEST_CONTACT_NAME = 'Test Contact';
    public static String TEST_ACCOUNT_NAME = 'Test Account';
    public static String TEST_LEAD_NAME = 'Test Lead';
    public static String TEST_COMPANY_NAME = 'Test Company';
    public static String TEST_CAMPAIGN_NAME = 'Test Campaign';
    public static String TEST_PHONE_NUMBER = '+918308791135';   
    
    public static testMethod Contact getContact(){
        Account account = getAccount();
        Contact contact = new Contact( Lastname= TEST_CONTACT_NAME, Account = account, MobilePhone = TEST_PHONE_NUMBER, Twilio_SMS_Enabled__c = True );
        insert contact;
        return contact;
    } 
    
    public static List<Contact> getContactsList(Integer count){
        Account account = getAccount();
        Contact contact;
        List<Contact> contactsList = new List<Contact>();
        
        for ( Integer i = 0; i < count; i++){
            contact = new Contact( Lastname= TEST_CONTACT_NAME, Account = account, MobilePhone = TEST_PHONE_NUMBER, Twilio_SMS_Enabled__c = True );
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
        Lead lead = new Lead(LastName = TEST_LEAD_NAME , Company = TEST_COMPANY_NAME, MobilePhone = TEST_PHONE_NUMBER, Twilio_SMS_Enabled__c = True );
        insert lead;
        return lead;
    }
    
    public static List<Lead> getLeadsList(Integer count){
        
        Lead lead;
        List<Lead> leadsList = new List<Lead>();
        
        for ( Integer i = 0; i < count; i++){
            lead = new Lead( LastName = TEST_LEAD_NAME , Company = TEST_COMPANY_NAME, MobilePhone = TEST_PHONE_NUMBER, Twilio_SMS_Enabled__c = True  );
            leadsList.add(lead);
        }
        insert leadsList;
        return leadsList;
    }

    public static List<CampaignMember> getCampaignMembersList (Integer count){
        List<Contact> contactsList = getContactsList(count);
        List<CampaignMember> cmList = new List<CampaignMember>();
        Campaign campaign = getCampaign();
        CampaignMember campaignMember = new CampaignMember();
        
        for(Contact contact : contactsList){
            campaignMember = new CampaignMember();
            campaignMember.campaignid = campaign.id;
            campaignMember.contactid = contact.id;
            cmList.add(campaignMember );
        }
        insert cmList;
        return cmList;
    }
    public static testmethod Campaign getCampaign(){
    
        Campaign campaign = new Campaign( Name = TEST_CAMPAIGN_NAME );
        insert campaign;
        return campaign;

    }    
    
}