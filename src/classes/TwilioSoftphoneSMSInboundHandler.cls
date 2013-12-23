/**
* @Author    : VW
* @Purpose   : This Rest service caters to incoming SMS requests from Twilio.
*              Upon receiving an SMS on Twilio Number, twilio requests for TwiML from this class.
*/
@RestResource(urlMapping='/smsrequest/*')
global with sharing class TwilioSoftphoneSMSInboundHandler {

    @HttpPost
    global static void saveSMSMessage(){
        System.debug('=====TwilioSoftphoneSMSInboundHandler.saveSMSMessage()=========' );
        RestRequest postReq = RestContext.request ;        
        System.debug('========in TwilioSoftphoneSMSInboundHandler=====postReq.params=======' + postReq.params);
        RestResponse res = new RestResponse();
        String smsReplyMessage = TwilioConfig__c.getValues(Label.Twilio_Default_Custom_Setting).SMS_Reply_Message__c;
        
        try{               

            TwilioSoftphoneHelper.attachSMSMessageToRecords(postReq.params);
            
            res = RestContext.response  ;
            res.addHeader('Content-Type','text/xml');            
            // sender of the SMS will receive confirmation message as mentioned in <sms>
            res.responseBody = blob.valueof('<Response><Sms>' + smsReplyMessage +'</Sms></Response>');
            
            return ;
        }catch(Exception e){
            
            res.responseBody = blob.valueof('An Exception Occurred');

           return ;
        }           
    }
}