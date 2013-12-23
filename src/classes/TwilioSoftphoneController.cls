/**
* @Author    : VW
* @Purpose   : This is a main controller. Makes broswer a SOFTPHONE.
*                          This contains methods for various functions of Softphone
*/
global with sharing class TwilioSoftphoneController {

    // Properties
    public String smsMessage { get; set; }    
    public String phoneNumber { get; set; }
    public String recordName { get; set; }
    public String token { get; set; }    
    public String notesBody { get; set; }
    public String notesTitle { get; set; }
    
    // Salesforce Records' Lists
    public static List<sObject> contactsList { get; set; }
    public static List<sObject> leadsList { get; set; }
    public static List<sObject> sObjsList { get; set; }
    public static String recordId = '';
    
    // Configuration Setttings For Twilio
        
    public static final String ACCOUNT_SID        = TwilioConfig__c.getValues(Label.Twilio_Default_Custom_Setting).AccountSid__c;//'AC6cb1ce3e925d6c9536d74d9b3f2c13a5';
    public static final String AUTH_TOKEN         = TwilioConfig__c.getValues(Label.Twilio_Default_Custom_Setting).AuthToken__c;//'f20229a53a902072748672321cbc9c91';
    public static final String applicationSid     = TwilioConfig__c.getValues(Label.Twilio_Default_Custom_Setting).ApplicationSid__c;//'AP2b1db551e6f7d81e109acb57a9c93bfb';   
    public static final String twilioPhoneNumber  = TwilioConfig__c.getValues(Label.Twilio_Default_Custom_Setting).Phone_Number__c;//+14248004152
    public static String twilioClientName         = TwilioConfig__c.getValues(Label.Twilio_Default_Custom_Setting).Client_Name__c;//Vaishnav       
    public static TwilioAccount account           = TwilioAPI.getDefaultAccount();
    


    // Constructor    
    public TwilioSoftphoneController(){        

        // Capability tokens are a secure way of setting up your device/ browser to access various features of Twilio       
        // Capability Token requires : Twilio Account SID and Authorization Token. This token is referenced in the vf page's JS   
        // TwilioCapability class is provided by twilio            
        TwilioCapability capability = new TwilioCapability(ACCOUNT_SID, AUTH_TOKEN);

        // (1) https://www.twilio.com/user/account/apps/add (2)https://www.twilio.com/user/account/apps/<<AppId>>         
        // To allow outgoing call from browser, add outgoing capability by providing application sid.
        capability.allowClientOutgoing(applicationSid);
        capability.allowClientIncoming(twilioClientName); 
        try {
            
            // Generate the actual capability token by calling generateToken method          
            token = capability.generateToken();
            System.debug('=======token ============' + token );
        } catch (Exception e) {    
            // Just in case exception. Show message to the user.                     
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL, Label.Exception_Occurred + e.getMessage()));             
        }
        
    }
        
    /* A method to send out an SMS. (At the most, 10 SMSs at once coz of callout limits. This sends out only one at a time)
     * Calls out to Twilio by providing necessary parameters. To, From and Message body
     * @return      PageReference (typically null just to refresh the page)
     */ 
    
    public PageReference sendSMS() {
        String toNumber = (phoneNumber.startsWith('+')) ? phoneNumber : '+' + phoneNumber;
        // Form a map of parameters required for Twilio to send out an SMS
        Map<String, String> params = new Map<String, String>{
            Label.From_String => twilioPhoneNumber,
            Label.To_String => toNumber ,
            Label.Body_String => smsMessage,
            Label.ApplicationSid => applicationSid
        };
                //'StatusCallback' => 'https://vaibhav-sfdev-developer-edition.ap1.force.com/services/apexrest/smsStatusCallback/'
        try {
            // Call out to Twilio
            TwilioSms sms = account.getSmsMessages().create(params); 
        } catch (Exception e) {
            // Just in case exception. Show message to the user.      
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL, Label.Exception_Occurred + e.getMessage()));
            // Stay on the same page
            return null;
        }
        // flush message and phone number once processed
        phoneNumber = null;
        smsMessage = null;

        return null;
    }        
    
    /* Action to be called when clicked on hang up button.
     * If navigated to softphone from SF Record the redirect to the record detail else stay on the same page 
     * @return      PageReference
     */ 
      
    public PageReference hangupAction() {
        return null;        
    }
    // Getter for twilioPhoneNumber
    public String getTwilioPhoneNumber() {
        return twilioPhoneNumber ;
    }
    
    // SMS panel's Cancel button action
    public PageReference cancel() {
        return null;
    }
    // SMS panel's Clear button action 
    public PageReference clearMessage() {
        return null;
    }

    // Remote action to implement search functionality
    // Gets called whenever user types in 3 or more numbers in phone number text box. Searches for contact / lead with similar phone number
    // @TODO: should search any phone number field on contact/ lead.
    // @ return    List<sObject>
             
    @RemoteAction
    global static List<sObject> getSFRecord(String tempPhoneNumber) {
        // fetch contact / lead with similar phone number        
        contactsList = [SELECT Id, Name, Phone, MobilePhone, Phone_E164__c , Mobile_E164__c  
                        FROM Contact 
                        WHERE  (Phone_E164__c LIKE : '%'+tempPhoneNumber+'%'      OR
                               Mobile_E164__c LIKE : '%'+tempPhoneNumber+'%' OR
                               FirstName LIKE : tempPhoneNumber+'%'       OR
                               LastName LIKE : tempPhoneNumber+'%' )      AND
                               (Phone_E164__c != NULL OR Mobile_E164__c != NULL)
                        LIMIT 10];
                        
        leadsList = [SELECT Id, Name, Phone, MobilePhone, Phone_E164__c , Mobile_E164__c  
                     FROM Lead 
                     WHERE (Phone_E164__c LIKE : '%'+tempPhoneNumber+'%'      OR
                           Mobile_E164__c LIKE : '%'+tempPhoneNumber+'%' OR
                           FirstName LIKE : tempPhoneNumber+'%'       OR
                           LastName LIKE : tempPhoneNumber+'%' )      AND
                           (Phone_E164__c != NULL OR Mobile_E164__c != NULL)
                    LIMIT 10];
                    
        sObjsList = new List<sObject>();
        
        // Add contacts/ leads in the generic list
        if(contactsList != null && contactsList.size() > 0){
            sObjsList.addAll(contactsList);
        }
        
        if(leadsList != null && leadsList .size() > 0){
            sObjsList.addAll(leadsList);
        }
        
        return sObjsList;
    }
    
    @RemoteAction
    global static Boolean isValidPhoneNumber(String tempPhoneNumber) {
        // match the phone number with E.164 standards
        if(tempPhoneNumber != null && tempPhoneNumber.trim() != '')            
            return Pattern.matches('^\\+?\\d{10,14}$', tempPhoneNumber); 
        return false;
    }
    
    @RemoteAction
    global static List<Sobject> getCallersName(String callerNumber) {
        List<sObject> callerContactsList ;
        List<sObject> callerLeadsList ;
        System.debug('=======in getCallersName(callerNumber)===========' + callerNumber);
        callerContactsList = [  SELECT Id, Name, Phone, MobilePhone, Phone_E164__c , Mobile_E164__c    
                                FROM Contact 
                                WHERE Phone_E164__c =: callerNumber OR Mobile_E164__c =: callerNumber
                                LIMIT 1];
                        
        callerLeadsList = [  SELECT Id, Name, Phone, MobilePhone, Phone_E164__c , Mobile_E164__c  
                             FROM Lead 
                             WHERE Phone_E164__c =: callerNumber OR Mobile_E164__c =: callerNumber
                             LIMIT 1];
                    
        System.debug('=======in getCallersName(callerNumber)====callerContactsList =======' + callerContactsList  + '=======callerLeadsList ========'  + callerLeadsList );                    
                    
        List<sObject> callerSObjsList = new List<sObject>();
        
        // Add contacts/ leads in the generic list
        if(callerContactsList != null && callerContactsList.size() > 0){
            callerSObjsList.addAll(callerContactsList);
        }
        
        if(callerLeadsList != null && callerLeadsList.size() > 0){
            callerSObjsList.addAll(callerLeadsList);
        }
        System.debug('=======callerSObjsList====' + callerSObjsList);
        return callerSObjsList;       
        
    }
    
    @RemoteAction
    global static List<sObject> saveNotes(String phoneNumber, String notesTitle, String notesBody) {
        if ( isValidPhoneNumber(phoneNumber) ) {
            List<sObject> recordsList = getCallersName(phoneNumber); 
            
            if(recordsList != null && recordsList.size() > 0) { // recordsList.size == 1        
                
                Note tempNote = new Note( parentId = recordsList[0].Id, 
                                          Title= notesTitle, 
                                          Body = notesBody
                                        );
                
                try{ 
                    insert tempNote ;
                }
                catch(DMLException error){
                    return null;
                }        
                return recordsList;
            }else {
                return null;
            }
        }
        return null;        
    }
}