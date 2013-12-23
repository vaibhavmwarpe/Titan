/**
* @Author    : VW
* @Purpose   : Test Class for TwilioSoftphoneController
*/
@isTest(SeeAllData=True)
public class TwilioSoftphoneHelper_Test {   
   
    static Map<String, String> paramsMap = new Map<String, String>{
                                                'ApiVersion'  => '2010-04-01',
                                                'From'  => '+918881114444',
                                                'Direction'  => 'inbound',
                                                'CallSid'  => 'CAd769c99c16afghe83a8acd05b1d1663892e',
                                                'PhoneNumber'  => '+918881114444',
                                                'Called'  => '+919987778888',
                                                'To'  => '+918881114444',
                                                'Caller'  => '+17775552121',
                                                'CallStatus'  => 'ringing',
                                                'ApplicationSid'  => 'AP2b1db551e6frty7d81e109acb57a9c93bfb',
                                                'AccountSid'  => 'AC6cb1ce3e925d6c9536rtyd74d9b3f2c13a5'};    
	    
    public static testmethod void twilioSoftphoneHelperTest(){  
        
        Contact tempContact = TwilioSoftphoneFactory_Test.getContact();
        
        Integer initialCDRCount = [SELECT Count() FROM CDR__c];
		TwilioSoftphoneHelper.createCDRRecord(paramsMap, Label.Outbound_String);
        Integer finalCDRCount = [SELECT Count() FROM CDR__c];
        
        System.assertEquals( finalCDRCount, initialCDRCount + 1 ); 
        
        TwilioSoftphoneHelper.updateCDRRecord(paramsMap);
        
        Lead tempLead = TwilioSoftphoneFactory_Test.getLead();
        TwilioSoftphoneHelper.createCDRRecord(paramsMap, Label.Outbound_String);
        finalCDRCount = [SELECT Count() FROM CDR__c];
        
        System.assertEquals( finalCDRCount, initialCDRCount + 2 ); 
        
        TwilioSoftphoneHelper.attachSMSMessageToRecords(paramsMap); 
        TwilioSoftphoneHelper.createSingleSMSMessageRecord(paramsMap);
        
    }
}