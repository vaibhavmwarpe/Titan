/**
* @Author    : VW
* @Purpose   : This Rest service caters to status callback for SMS (incoming/ outgoing)
*/
@RestResource(urlMapping='/smsStatusCallback/*') 
global with sharing class TwilioSoftphoneSMSStatusCBHandler {

    @HttpPost
    global static void updateSMSMessage(){
        RestRequest postReq = RestContext.request ;        
        RestResponse res = new RestResponse();
        
        try{               
			// for outbound sms, only status call back contains SMS SID...so for outbound sms create sms record
            // only on status call back. 
            TwilioSoftphoneHelper.createSingleSMSMessageRecord(postReq.params);
            System.debug('====in updateSMSMessage()====of ==TwilioSoftphoneSMSStatusCBHandler===with url mapping smsStatusCallback=========postReq.params=====' + postReq.params);
            res = RestContext.response  ;
            res.addHeader('Content-Type','text/xml'); 
            // nothing to process after call back so empty response
            res.responseBody = blob.valueof('<Response></Response>');
            return ;
        }catch(Exception e){
            System.debug('====in updateSMSMessage()====exception=======');
            res.responseBody = blob.valueof('An Exception Occurred');

           return ;
        }           
    }
}