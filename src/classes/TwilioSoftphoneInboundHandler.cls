/**
* @Author    : VW
* @Purpose   : This Rest service caters to incoming call requests from Twilio.
* 			   Upon receiving call on Twilio Number, twilio needs a TwiML to route the call appropriately. 
*			   Twilio does that by requesting this class to provide TwiML to dial to either a number or a Client/ Softphone.
*		       This dials in registered browser/ softphone.
*/

@RestResource(urlMapping='/softcallclient/*')
global with sharing class TwilioSoftphoneInboundHandler{

    @HttpPost
    global static void handleSFInboundCall(){
        // request from rest context
        RestRequest postReq = RestContext.request ;        
        RestResponse res = new RestResponse();
        system.debug('=======TwilioSoftphoneInboundHandler.handleSFInboundCall ======handleSFInboundCall======params from twilio====='+system.JSON.serialize(postReq.params));
        try{               
			// Read a custom setting to get client name
            String clientName = TwilioConfig__c.getValues(Label.Twilio_Default_Custom_Setting).Client_Name__c;
            
            // Twilio's request contains caller info/ number. 
            // This number will be used as a callerId and can be refered by client/ softphone using conn.parameters.From
            // CallerId attribute is a must in <Dial>
            String callerId = postReq.params.get('Caller');      
            
            // Create CDR for this incoming call. 
            // Pass on the direction - 'Inbound' to know what is the direction wrt to salesforce. Post params' direction always happens to be 'inbound')
            
            TwilioSoftphoneHelper.createCDRRecord(postReq.params, Label.Inbound_String);
            
            // Form a response for Twilio
            res = RestContext.response  ;
            res.addHeader('Content-Type','text/xml');            
            // Response's body contains a <Dial>.
            // i.e. upon receiveing Twilio wants to know where to dial. <Client> within <Dial> dials in to mentioned client.
            // If client with the specified name is not registered with Twilio, call does not happen.
            res.responseBody = blob.valueof('<Response><Dial callerId="' + callerId + '"><Client>'+ clientName +'</Client></Dial></Response>');
            
            return ;
        }catch(Exception e){
            
            res.responseBody = blob.valueof('An Exception Occurred');
			
           return ;
        }           
  }
    
    
        
}