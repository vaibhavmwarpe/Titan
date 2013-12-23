public with sharing class SalesTwilioIncomingCallPageController {

    public String phonenumber { get; set; }
    public String recordName { get; set; }
    public String token { get; set; } 

    public static final String ACCOUNT_SID = 'AC6cb1ce3e925d6c9536d74d9b3f2c13a5';
    public static final String AUTH_TOKEN = 'f20229a53a902072748672321cbc9c91';
   
    // This is a special Quickstart application sid - or configure your own
    // at twilio.com/user/account/apps
    
    String applicationSid = 'AP0b7062777fafe6fe793f852f1ec8d1a3';       

    public SalesTwilioIncomingCallPageController (){
        
        TwilioCapability capability = new TwilioCapability(ACCOUNT_SID, AUTH_TOKEN);
        capability.allowClientOutgoing(applicationSid);
        capability.allowClientIncoming('Vaishnav');
        //String token = null;       
        
        try {
            token = capability.generateToken();
        } catch (Exception e) {
            //e.printStackTrace();
        }
        
    }    
    
    public PageReference hangupAction() {
        return null;
    }
}