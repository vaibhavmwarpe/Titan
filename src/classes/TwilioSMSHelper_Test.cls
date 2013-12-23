/**
* @Author    : VW
* @Purpose   : Test Class for TwilioSMSHelper
*/
@isTest(SeeAllData=True)
public class TwilioSMSHelper_Test { 
  
    public static String TEST_SMS_MESSAGE = 'Test Message - Twilio SFDC';  
    public static String TEST_INBOUND = 'Inbound';  
    public static String TEST_OUTBOUND = 'Outbound';
    public static String TEST_STATUS = 'Sent';
    
    
          
    public static testmethod void testCreateSMSMessageRecords(){  //line# 102
        
        List<Contact> contactsList = TwilioSMSFactory.getContactsList(2); 
        TwilioSMSHelper.createSMSMessageRecords(TEST_SMS_MESSAGE, contactsList, TwilioSMSHelper.getWhatType(contactsList[0].id), TwilioSMSConfig.getTwilioPhoneNumber(), TEST_INBOUND );
        
        List<Lead> leadsList = TwilioSMSFactory.getLeadsList(2);  
        TwilioSMSHelper.createSMSMessageRecords(TEST_SMS_MESSAGE, leadsList , TwilioSMSHelper.getWhatType(leadsList[0].id), TwilioSMSConfig.getTwilioPhoneNumber(), TEST_INBOUND ); 
               
        List<CampaignMember> cmsList = TwilioSMSFactory.getCampaignMembersList(2);
        TwilioSMSHelper.createSMSMessageRecords(TEST_SMS_MESSAGE, cmsList , 'CampaignMember', TwilioSMSConfig.getTwilioPhoneNumber(), TEST_INBOUND );
    }
    
    public static testmethod void testAttachSMSMessageToRecords(){
        Contact contact = TwilioSMSFactory.getContact();
        Lead lead = TwilioSMSFactory.getLead();
        Map<String, String> paramsMap = new Map<String, String>{     'AccountSid' => 'AC0870a85989c2b1cc98813212d240488a', 
                                                                     'ApiVersion' => '2010-04-01', 
                                                                     'Body' => 'Test Message', 
                                                                     'From' => '+918308791135', 
                                                                     'SmsMessageSid' => 'SM2df44f070d128959eb1a509c83d1eb04', 
                                                                     'SmsSid' => 'SM2df44f070d128959eb1a509c83d1eb04'
                                                                     };
        
                                
        TwilioSMSHelper.attachSMSMessageToRecords(paramsMap);
    }
    
    public static testmethod void testCreateSingleSMSMessageRecord(){
        Boolean isException = False;
        Contact contact = TwilioSMSFactory.getContact();
        Lead lead = TwilioSMSFactory.getLead();        
        try{                
            TwilioSMSHelper.createSingleSMSMessageRecord(TEST_SMS_MESSAGE, contact, Label.Contact_String, TwilioSMSConfig.getTwilioPhoneNumber(), TEST_OUTBOUND, TEST_STATUS );
            TwilioSMSHelper.createSingleSMSMessageRecord(TEST_SMS_MESSAGE, lead, Label.Lead_String, TwilioSMSConfig.getTwilioPhoneNumber(), TEST_OUTBOUND, TEST_STATUS );
        } catch (Exception exp){
            isException = True;
        }
        
        System.assertEquals(isException, false);
    }
    
}