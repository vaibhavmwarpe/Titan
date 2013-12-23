/**
* @Author    : VW
* @Purpose   : This Rest service caters to status call back from Twilio.
*              Whenever call gets terminated, Twilio requests this class.
*/

@RestResource(urlMapping='/softcallstatus/*')
global with sharing class TwilioSoftphoneStatusCBHandler {

    @HttpPost
    global static void updateCDR(){
        // get request from context 
        RestRequest postReq = RestContext.request ;        
        RestResponse res = new RestResponse();
        
        try{               
            // Form a map of request params to pass it on for further processing
            Map<String, String> paramsMap = postReq.params;
            
            // Update CDR which has the same sid mentioned in the request params. This is needed when  
            TwilioSoftphoneHelper.updateCDRRecord(paramsMap);                          
                 
            res = RestContext.response  ;
            res.addHeader('Content-Type','text/xml');            
            // TwiML Response for Twilio. @TODO: form appropriate response. Empty does work as nothing to be processed upon call back.
            res.responseBody = blob.valueof('<Response></Response>');
            return ;
        }catch(Exception e){
            // if exception occurs
            res.responseBody = blob.valueof('An Exception Occurred');
            return ;
        }           
  }
    
    
        
}