/**
* @Author    : VW
* @Purpose   : This Rest service caters to incoming SMS requests from Twilio.
* 			   Upon receiving an SMS on Twilio Number, twilio requests for TwiML from this class.
*/
@RestResource(urlMapping='/smsrequest1/*')
global with sharing class TwilioSMSSfdcInboundHandler {

    @HttpPost
    global static void saveSMSMessage(){
        RestRequest postReq = RestContext.request ;        
        RestResponse res = new RestResponse();
        String smsReplyMessage = TwilioConfig__c.getValues(Label.Twilio_Default_Custom_Setting).SMS_Reply_Message__c;
        //system.debug('=======TwilioSMSSfdcInboundHandler ======saveSMSMessage======params from twilio====='+system.JSON.serialize(postReq.params));
        try{               

            TwilioSMSHelper.attachSMSMessageToRecords(postReq.params);
            
            res = RestContext.response  ;
            res.addHeader('Content-Type','text/xml');            
            // sender of the SMS will receive confirmation message as mentioned in <sms>
            res.responseBody = blob.valueof('<Response><Sms>' + smsReplyMessage +'</Sms></Response>');
            
            return ;
        }catch(Exception e){
            String htmlResponse = 'An error occurred in placing the call';
            res.responseBody = blob.valueof('An Exception Occurred');

           return ;
        }           
    }
}