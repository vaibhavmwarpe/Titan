public with sharing class TwilioSMSConfig{
    
    public static String myPhoneNumber { get; set; }
    public static TwilioAccount account { get; set; }
    
    public TwilioSMSConfig () { 
    }
    
    public static TwilioAccount getTwilioAccount(){    
        account = TwilioAPI.getDefaultAccount();
        return Account;
    }
    
    public static String getTwilioPhoneNumber(){   
        myPhoneNumber = TwilioConfig__c.getAll().values().Phone_Number__c;
        return myPhoneNumber;
    }   
 
}