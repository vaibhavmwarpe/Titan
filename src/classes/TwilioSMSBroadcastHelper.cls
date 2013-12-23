public with sharing class TwilioSMSBroadcastHelper {
    public static Boolean isSuccess { get; set; }
    
    public static List<Map<String, String>> getParamsList (String smsMessage, List<SObject> sObjectList, String whatType, String twilioPhoneNumber){
        List<Map<String, String>> paramsList = new List<Map<String, String>>();
        Map<String, String> params = null;
        
        if(whatType == Label.Contact_String) {
            for( Contact tempContact : (List<Contact>) sObjectList) {
                params = new Map<String, String>{
                    Label.From_String => twilioPhoneNumber,
                    Label.To_String => tempContact.MobilePhone,
                    Label.Body_String => smsMessage
                };
                paramsList.add(params);
            }
        } else if(whatType == Label.Lead_String){
            for( Lead tempLead : (List<Lead>) sObjectList) {
                params = new Map<String, String>{
                    Label.From_String => twilioPhoneNumber,
                    Label.To_String => tempLead.MobilePhone,
                    Label.Body_String => smsMessage
                };
                paramsList.add(params);
            }
        } else if(whatType == Label.CampaignMember_String){
            for( CampaignMember tempCM : (List<CampaignMember>) sObjectList) {
                params = new Map<String, String>{
                    Label.From_String => twilioPhoneNumber,
                    Label.To_String => tempCM.Twilio_Mobile__c,
                    Label.Body_String => smsMessage
                };
                paramsList.add(params);
            }
        }
        
        return paramsList;
    }
    
    public static Boolean sendSMSToSelectedRecords(String smsMessage, List<SObject> sObjectList, String whatType) {      
        
        TwilioAccount account = TwilioSMSConfig.getTwilioAccount();
        String twilioPhoneNumber = TwilioSMSConfig.getTwilioPhoneNumber();

        List<Map<String, String>> paramsList = getParamsList(smsMessage,sObjectList, whatType, twilioPhoneNumber);
		
        try {
            TwilioSms sms;
            for( Map<String, String> tempParam : paramsList ){
                sms = account.getSmsMessages().create(tempParam);
            }
            
        } catch (Exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL, Label.Exception_Occurred + e.getMessage()));
            return null;
        }
        
		TwilioSMSHelper.createSMSMessageRecords(smsMessage,sObjectList, whatType, twilioPhoneNumber, Label.Outbound_String);
        return True;
    }   

}