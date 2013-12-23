/**
* @Author    : VW
* @Purpose   : This Rest service caters to oubound call requests directly from Record Detail link
*/
@RestResource(urlMapping='/dialToRecordsPhone/*')
global with sharing class Delete_TwilioSoftphoneRecordOBHandler {

    @HttpGet
    global static void handleRecordOBCall(){
        RestRequest postReq = RestContext.request ;        
        RestResponse res = new RestResponse();
        
        String callerId = TwilioConfig__c.getValues(Label.Twilio_Default_Custom_Setting).Phone_Number__c;
        system.debug('=======In TwilioSoftphoneRecordOBHandler ======handleRecordOBCall======params from hyperlink====='+system.JSON.serialize(postReq.params));       
        try{
            // Create initial CDR for this outbound call. This will be updated upon end of call.
            
            //callout to twilio before 
            Delete_TwilioSoftphoneRecordHelper.dialOutToRecordNumber(postReq.params);
            //TwilioSoftphoneHelper.createCDRRecord(postReq.params, Label.Outbound_String);
            res = RestContext.response  ;
            res.addHeader('Content-Type','text/xml');            
            
            //res.responseBody = blob.valueof('<Response><Dial callerId="' + callerId + '" action="'+actionURL+'">'+ postReq.params.get('PhoneNumber') + '</Dial></Response>');
            
            // Form correct TwiML to dial out to appropriate number. Post request from Twilio has 'PhoneNumber' param which is passed on 
            // from vf page.
            //res.responseBody = blob.valueof('<Response><Dial callerId="' + callerId + '">'+ postReq.params.get('PhoneNumber') + '</Dial></Response>');
            res.responseBody = blob.valueof('<Response></Response>');
            return ;
        }catch(Exception e){
            // Exception just in case
            String htmlResponse = 'An error occurred in placing the call';
            res.responseBody = blob.valueof('An Exception Occurred');

           return ;
        }       
  }  
}