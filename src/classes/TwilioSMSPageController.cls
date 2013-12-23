public with sharing class TwilioSMSPageController {

    public String status { get; set; }
    public String message { get; set; }
    public String phoneNumber { get; set ;}    
    public String mobileNumber { get;set; }
    
    private String salesforceId;    
    private String whatObject { get; set; }    
    public List<Sobject> sfObject{ get; set; }   
    
    public TwilioAccount account = TwilioAPI.getDefaultAccount();
    public String twilioPhoneNumber = TwilioConfig__c.getAll().values().Phone_Number__c;

    private Map<String, String> stdObjToStdCodeMap = 
                                        new Map<String, String>{
                                                Schema.SObjectType.Account.getKeyPrefix() => Label.Account_String,
                                                Schema.SObjectType.Contact.getKeyPrefix() => Label.Contact_String,
                                                Schema.SObjectType.User.getKeyPrefix() => Label.User_String,
                                                Schema.SObjectType.Lead.getKeyPrefix() => Label.Lead_String,
                                                Schema.SObjectType.CampaignMember.getKeyPrefix() => Label.CampaignMember_String   
                                                };

    public TwilioSMSPageController () {        

        salesforceId = ApexPages.currentPage().getParameters().get(Label.sfid_String);
        try{
            if( salesforceId != null && (salesforceId.trim().length()== 15 || salesforceId.trim().length() == 18)){ 
                whatObject = stdObjToStdCodeMap.get(salesforceId.trim().subString(0,3));
                
                if( whatObject == Label.Contact_String )
                    sfObject = (List<Contact>)[ SELECT id, Name, MobilePhone, Email, Phone FROM Contact WHERE id =: salesforceId LIMIT 1];
                else if( whatObject == Label.User_String )
                    sfObject = (List<User>)[ SELECT id, Name, MobilePhone, Email, Phone FROM User WHERE id =: salesforceId LIMIT 1];
                else if( whatObject == Label.Lead_String)
                    sfObject = (List<Lead>)[ SELECT id, Name, MobilePhone, Email, Phone FROM Lead WHERE id =: salesforceId LIMIT 1];                
                
                if( sfObject != null && sfObject.size () > 0 )             
                    mobileNumber = String.valueOf(sfObject[0].get(Label.MobilePhone_String));             
                        
            } else {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL, Label.Record_Not_Available));            
            }
        } catch(Exception exp){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL, Label.An_Exception_Occurred + exp));
        }
        
    }

    public PageReference sendSMS() {
        Map<String, String> params = new Map<String, String>{
            Label.From_String => twilioPhoneNumber,
            Label.To_String => mobileNumber,
            Label.Body_String => message
        };
        
        System.debug('======TwilioSMSPageController.sendSMS()===== params =======' + params);

        try {
            TwilioSms sms = account.getSmsMessages().create(params);            
            TwilioSMSHelper.createSingleSMSMessageRecord(message, sfObject[0] , whatObject, twilioPhoneNumber, Label.Outbound_String, Label.Sent_String);
            
        } catch (Exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL, Label.Exception_Occurred + e.getMessage()));
            return null;
        }

        phoneNumber = null;
        message = null;

        return new PageReference('/' + salesforceId ); 
    }        
    
    public PageReference cancel() {
        return new PageReference('/' + salesforceId );
    }

    public PageReference clearMessage() {
        message = '';
        return null;
    }
    
                            

}