/**
* @Author    : VW
* @Purpose   : This Rest service caters to oucoming call requests to salesforce records (contacts/leads) via Twilio
*			   URL for this Rest service needs to be mentioned under Voice URL in Twilio Application. 
*			   When browser with outbound capabilty requests Twilio to connect using JS, Twilio reads application sid from cap. token
*			   and requests instruction from this class for further processing. This class forms a TwiML response and inserts appropriate 
*			   callee number within <Dial>. Callee number is passed on to this class via Twilio Request post param - phoneNumber.
*/
@RestResource(urlMapping='/softcall/*')
global with sharing class TwilioSoftphoneOutboundHandler {

    @HttpPost
    global static void handleSFOutboundCall(){
        RestRequest postReq = RestContext.request ;        
        RestResponse res = new RestResponse();
        
        //String actionURL = 'https://vaibhav-sfdev-developer-edition.ap1.force.com/services/apexrest/softcallstatus/';
        // Get callerId (mandatory for <Dial>) from custom settings. Typically this is twilios phone number.
        String callerId = TwilioConfig__c.getValues(Label.Twilio_Default_Custom_Setting).Phone_Number__c;
        system.debug('=======TwilioSoftphoneOutboundHandler ======handleTwilioRequest======params from twilio====='+system.JSON.serialize(postReq.params));       
        try{
            // Create initial CDR for this outbound call. This will be updated upon end of call.
            TwilioSoftphoneHelper.createCDRRecord(postReq.params, Label.Outbound_String);
            res = RestContext.response  ;
            res.addHeader('Content-Type','text/xml');            
            
            //res.responseBody = blob.valueof('<Response><Dial callerId="' + callerId + '" action="'+actionURL+'">'+ postReq.params.get('PhoneNumber') + '</Dial></Response>');
            
            // Form correct TwiML to dial out to appropriate number. Post request from Twilio has 'PhoneNumber' param which is passed on 
            // from vf page.
            res.responseBody = blob.valueof('<Response><Dial callerId="' + callerId + '">'+ postReq.params.get('PhoneNumber') + '</Dial></Response>');
            return ;
        }catch(Exception e){
            // Exception just in case
            String htmlResponse = 'An error occurred in placing the call';
            res.responseBody = blob.valueof('An Exception Occurred');

           return ;
        }       
  }  
}