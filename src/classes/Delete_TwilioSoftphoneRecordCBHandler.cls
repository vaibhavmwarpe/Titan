/**
* @Author    : VW
* @Purpose   : 
*/
@RestResource(urlMapping='/dialToRecordsPhoneCB/*')
global with sharing class Delete_TwilioSoftphoneRecordCBHandler {

    @HttpGet
    global static void handleRecordStatusCallback (){
        RestRequest postReq = RestContext.request ;        
        RestResponse res = new RestResponse();
        
        String callerId = TwilioConfig__c.getValues(Label.Twilio_Default_Custom_Setting).Phone_Number__c;
        system.debug('=======In TwilioSoftphoneRecordCBHandler ======handleRecordStatusCallback ======params from hyperlink====='+system.JSON.serialize(postReq.params));       
        try{
            TwilioSoftphoneHelper.createCDRRecord(postReq.params, Label.Outbound_String);
            res = RestContext.response  ;
            res.addHeader('Content-Type','text/xml');
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