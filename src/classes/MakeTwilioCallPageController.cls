public with sharing class MakeTwilioCallPageController {

    public String phonenumber { get; set; }
    public String recordName { get; set; }
    public String token { get; set; }

    public static final String ACCOUNT_SID = 'AC6cb1ce3e925d6c9536d74d9b3f2c13a5';
    public static final String AUTH_TOKEN = 'f20229a53a902072748672321cbc9c91';
   
    // This is a special Quickstart application sid - or configure your own
    // at twilio.com/user/account/apps
    
    String applicationSid = 'AP2b1db551e6f7d81e109acb57a9c93bfb';       
    String recordId = '';

    public MakeTwilioCallPageController (){
        
        TwilioCapability capability = new TwilioCapability(ACCOUNT_SID, AUTH_TOKEN);
        capability.allowClientOutgoing(applicationSid);
        capability.allowClientIncoming('Vaishnav');
        //String token = null;
        recordId = ApexPages.currentPage().getParameters().get('id');
        List<Contact> sobjList = [SELECT id, Phone, Name FROM Contact WHERE id =: recordId LIMIT 1];
        phonenumber = sobjList[0].Phone;
        recordName = sobjList[0].Name;
        
        
        try {
            token = capability.generateToken();
        } catch (Exception e) {
            //e.printStackTrace();
        }
        
    }
    
    
    public PageReference hangupAction() {
        return new PageReference ('/' + recordId );
    }

}