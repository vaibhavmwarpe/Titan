/**
* @Author    : VW
* @Purpose   : This Rest service caters to status callback for SMS (incoming/ outgoing)
*/
@RestResource(urlMapping='/smsStatusCallback11/*')
global with sharing class TwilioSMSStatusCBHandler {

    @HttpPost
    global static void updateSMSMessage(){
        RestRequest postReq = RestContext.request ;        
        RestResponse res = new RestResponse();
        system.debug('=======TwilioSMSStatusCBHandler ======updateSMSMessage======params from twilio====='+system.JSON.serialize(postReq.params));
        try{               

            TwilioSMSHelper.createSingleSMSMessageRecord(postReq.params);
            
            res = RestContext.response  ;
            res.addHeader('Content-Type','text/xml');            
            // sender of the SMS will receive confirmation message as mentioned in <sms>
            //res.responseBody = blob.valueof('<Response><Sms>Thanks for sending message. Your message will be saved under your record in salesforce!!!</Sms></Response>');
            res.responseBody = blob.valueof('<Response></Response>');
            return ;
        }catch(Exception e){
            String htmlResponse = 'An error occurred in placing the call';
            res.responseBody = blob.valueof('An Exception Occurred');

           return ;
        }           
    }
}