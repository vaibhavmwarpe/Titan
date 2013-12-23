public with sharing class SalesTwilioSoftphoneDialerController {

    public String notestitle { get; set; }

    public String notesbody { get; set; }
   
    public Note myfile;
    public Note getMyfile() {
        if (myfile== null)
        myfile = new Note();
        return myfile;
    }

    public PageReference upload() {
        List<Contact> contactNotes = [SELECT id, Name, Phone, MobilePhone FROM Contact WHERE Phone LIKE :phonenumber];
        system.debug('############+contactss+++##############' + contactNotes[0].Id);
      //  system.debug('############+ note.body +##############' + note.body);
        //soql to get contact/ lead
        Note a = new Note(parentId = contactNotes[0].Id, Title=notestitle, Body = notesbody);
         system.debug('############+ note.tITLE +##############' +notestitle+ '************phone******+'+ phonenumber + '@@@@@@@@Note.bODY@@@@@@@@'+notesbody);
        try{ 
            insert a;
        }
        catch(DMLException error){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading file'));
            return null;
        }finally{
            notesbody = null;
            notestitle = null;
            a = new Note();
        }
                
        //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'File uploaded successfully'));
        return null;
     }
  
    public String numb{ get; set; }

    public String clientId { get; set; }

    public Boolean flag { get; set; }

    public String recordLink { get; set; }

    public String mymobile { get; set; }
    public String smsMessage { get; set; }
    public String calleeNumber { get; set; }

    public String message { get; set; }
    public Boolean isRecord { get; set; }
    public String phonenumber { get; set; }
    public String mobilenumber { get; set; }
    public String recordName { get; set; }
    public String token { get; set; }
    
    // Configuration Setttings For Twilio
    
    public static final String ACCOUNT_SID    =  TwilioConfig__c.getValues(Label.Twilio_Default_Custom_Setting).AccountSid__c;//'AC0a1081724f45e8a6013474fb5e262a64';
    public static final String AUTH_TOKEN     =  TwilioConfig__c.getValues(Label.Twilio_Default_Custom_Setting).AuthToken__c;//'a7855ae2440ffd4fb273eebbe322f145';
    public static final String applicationSid =  TwilioConfig__c.getValues(Label.Twilio_Default_Custom_Setting).ApplicationSid__c;//'AP8482810a5fd0a18f8297af811043f1cc';   
    public static final String twilioPhoneNumber =  TwilioConfig__c.getValues(Label.Twilio_Default_Custom_Setting).Phone_Number__c;//+17865653833
    public static String twilioClientName = TwilioConfig__c.getValues(Label.Twilio_Default_Custom_Setting). Client_Name__c;//Puneet
    public TwilioAccount account = TwilioAPI.getDefaultAccount();
    
    
    String recordId = '';      
    

    public SalesTwilioSoftphoneDialerController (){
        isRecord = false;
                
        TwilioCapability capability = new TwilioCapability(ACCOUNT_SID, AUTH_TOKEN);
        capability.allowClientOutgoing(applicationSid);
        capability.allowClientIncoming(twilioClientName);
        /*if( TwilioConfig__c.getValues(Label.Twilio_Default_Custom_Setting).Is_Client_Registered__c == false ){
            capability.allowClientIncoming(twilioClientName);
            TwilioConfig__c.getValues(Label.Twilio_Default_Custom_Setting).Is_Client_Registered__c = true;
            //update TwilioConfig__c.getValues(Label.Twilio_Default_Custom_Setting);            
        }*/
        try {
            recordId = ApexPages.currentPage().getParameters().get('id'); //'0039000000MM6vO';
            if(recordId !=null && recordId != '') {
                List<Contact> sobjList = [SELECT id, Phone, MobilePhone, Name FROM Contact WHERE id =: recordId LIMIT 1];
                
                if(sobjList[0].Phone != null)
                    phonenumber = sobjList[0].Phone;
                else
                    phonenumber = sobjList[0].MobilePhone;
                    
                if(sobjList[0].Phone != null || sobjList[0].MobilePhone != null)
                recordName = sobjList[0].Name; // phonenumber = sobjList[0].MobilePhone;
                isRecord = true;
                flag = true;
                //clientId = '/'+recordId;
            }       
        
            token = capability.generateToken();
            
        } catch (Exception e) {            
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL, Label.Exception_Occurred + e.getMessage())); 
            
        }
           
    }
    
        /* Typically, whenever softphone gets opened, it has OUTGOING capability by default as it is mentioned in the constuctor. 
     * A method to add INCOMING capability to the browser to receive calls. This method will be called only on a button click to allow incoming calls.
     * @return      PageReference (typically null just to refresh the page)
     */ 
     
    public PageReference regenerateCapabilityToken(){
        // Recalculate the token         
        TwilioCapability capability = new TwilioCapability(ACCOUNT_SID, AUTH_TOKEN);
        capability.allowClientOutgoing(applicationSid);
        // Add Incoming capablilty now
        capability.allowClientIncoming(twilioClientName);       
        token = capability.generateToken();
        return null;
    }
    
    public PageReference sendSMS() {
        Map<String, String> params = new Map<String, String>{
            Label.From_String => twilioPhoneNumber,
            Label.To_String => '+' + phoneNumber ,
            //Label.To_String => '+' + mobilenumber,
            Label.Body_String => smsMessage 
        };

        try {
            //System.debug('in sendSMS=========' +         params);
            TwilioSms sms = account.getSmsMessages().create(params);            
            //TwilioSMSHelper.createSingleSMSMessageRecord(message, sfObject[0] , whatObject, twilioPhoneNumber, Label.Outbound_String, Label.Sent_String);
                        
        } catch (Exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL, Label.Exception_Occurred + e.getMessage()));
            return null;
        }

        phoneNumber = null;
        smsMessage = null;

        return null;
    }        
    
    
        
    public PageReference hangupAction() {
        if(isRecord == true)
            return new PageReference ('/' + recordId );
        return null;
    }
    
    public PageReference closeSPAction() {
    
        TwilioConfig__c.getValues(Label.Twilio_Default_Custom_Setting).Is_Client_Registered__c = false; 
        update TwilioConfig__c.getValues(Label.Twilio_Default_Custom_Setting); 
        if(isRecord == true)
            return new PageReference ('/' + recordId );
        return new PageReference ('/home/home.jsp' );
    }
    
    
    public String getTwilioPhoneNumber() {
        return twilioPhoneNumber ;
    }

    public PageReference cancel() {
        return null;
    }

    public PageReference clearMessage() {
        return null;
    }
    
    
    public PageReference createRecordLink() {
    String searchPhoneNum;
    searchPhoneNum = phonenumber; //'+' + phonenumber;
    system.debug('############ phoneNumber####' + phonenumber);
    //     searchPhoneNum = mobilenumber;    
     //if(searchPhoneNum != ''){   
            List<Contact> contactsList = [SELECT id, Name, Phone, MobilePhone FROM Contact WHERE Phone LIKE :searchPhoneNum ];
            if(contactsList != null && contactsList.size() > 0){
                recordLink = '/' + contactsList[0].id;
                phonenumber = contactsList[0].Phone;
                recordName = contactsList[0].Name;
                flag = false;
            }
     //}
            else
               flag = true;
        //System.debug('in createRecordLink===============' + recordLink );
        return null;
    }

    public PageReference acceptRecordLink() {
         String fromNumber;
        // fromNumber = numb.substringAfter('+');
         String areaCode = numb.substring(2,5);
         String prefix = numb.substring(5,8);
         String last4 = numb.substring(8);
         fromNumber = '(' + areaCode +')' + ' ' + prefix + '-' + last4;
        
         system.debug('######################################## Caller #################################' + fromNumber);
         if(fromNumber != null)
         {
             List<Contact> callers = [SELECT Name, id, Phone, MobilePhone
                                      FROM Contact
                                      WHERE Phone = :fromNumber OR MobilePhone = :fromNumber
                                     ];
             if(callers != null && callers.size() > 0){
                 recordLink = '/' + callers[0].id;
                 flag = false;
             }
                                    
         }
         return null;
    }
   


    
    /*public PageReference unregisterAction() {
        TwilioConfig__c.getValues(Label.Twilio_Default_Custom_Setting).Is_Client_Registered__c = false;
        update TwilioConfig__c.getValues(Label.Twilio_Default_Custom_Setting);
        return null;
    }

    public PageReference checkSingleClient() {
        TwilioConfig__c.getValues(Label.Twilio_Default_Custom_Setting).Is_Client_Registered__c = true;
        update TwilioConfig__c.getValues(Label.Twilio_Default_Custom_Setting);
        return null;
    }*/
}