/**
* @Author    : VW
* @Purpose   : Test Class for TwilioSMSBroadcastHelper
*/
@isTest(SeeAllData=True)
public class TwilioSMSBroadcastHelper_Test {   
    
    public static String TEST_SMS_MESSAGE = 'Test Message - Twilio SFDC';
        
    public static testmethod void testGetParamsList (){
        //public static List<Map<String, String>> getParamsList (String smsMessage, List<SObject> sObjectList, String whatType, String twilioPhoneNumber){
        List<Contact> contactsList = TwilioSMSFactory.getContactsList(2);                
        List<Map<String, String>> paramsList = TwilioSMSBroadcastHelper.getParamsList(TEST_SMS_MESSAGE, contactsList, TwilioSMSHelper.getWhatType(contactsList[0].id), TwilioSMSConfig.getTwilioPhoneNumber());
        System.assertNotEquals(paramsList, null);
        System.assertEquals(paramsList.size(), 2);
        
        
        List<Lead> leadsList = TwilioSMSFactory.getLeadsList(2);  
        paramsList = TwilioSMSBroadcastHelper.getParamsList(TEST_SMS_MESSAGE, leadsList, TwilioSMSHelper.getWhatType(leadsList[0].id), TwilioSMSConfig.getTwilioPhoneNumber());
        System.assertNotEquals(paramsList, null);
        System.assertEquals(paramsList.size(), 2);
        
        List<CampaignMember> cmsList = TwilioSMSFactory.getCampaignMembersList(2);
        paramsList = TwilioSMSBroadcastHelper.getParamsList(TEST_SMS_MESSAGE, cmsList, TwilioSMSHelper.getWhatType(cmsList[0].id), TwilioSMSConfig.getTwilioPhoneNumber());
        System.assertNotEquals(paramsList, null);
        System.assertEquals(paramsList.size(), 2);
    
    }
    
    public static testmethod void testSendSMSToSelectedRecords (){
        //public static Boolean sendSMSToSelectedRecords(String smsMessage, List<SObject> sObjectList, String whatType) {      
        List<Contact> contactsList = TwilioSMSFactory.getContactsList(2);
        TwilioSMSBroadcastHelper.sendSMSToSelectedRecords(TEST_SMS_MESSAGE, contactsList, TwilioSMSHelper.getWhatType(contactsList[0].id));
        
        List<Lead> leadsList = TwilioSMSFactory.getLeadsList(2);  
        TwilioSMSBroadcastHelper.sendSMSToSelectedRecords(TEST_SMS_MESSAGE, leadsList, TwilioSMSHelper.getWhatType(leadsList[0].id));
        
        List<CampaignMember> cmsList = TwilioSMSFactory.getCampaignMembersList(2);
    	TwilioSMSBroadcastHelper.sendSMSToSelectedRecords(TEST_SMS_MESSAGE, cmsList, TwilioSMSHelper.getWhatType(cmsList[0].id));
    }
}