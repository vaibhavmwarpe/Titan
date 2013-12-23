/**
* @Author    : VW
* @Purpose   : This Rest service caters to incoming message from Salesforce.com
*			   This m
*/
@RestResource(urlMapping='/ticketTracker/*')
global with sharing class ArxTicketTracker {

    @HttpPost
    global static void saveSMSMessage(){
        RestRequest postReq = RestContext.request ;
        RestResponse res = new RestResponse();
                
        try{               

            TwilioSoftphoneHelper.attachSMSMessageToRecords(postReq.params);
            
            res = RestContext.response  ;
            res.addHeader('Content-Type','text/xml');            
            // sender of the SMS will receive confirmation message as mentioned in <sms>
            res.responseBody = blob.valueof('<Response><Sms></Sms></Response>');
            
            return ;
        }catch(Exception e){            
            res.responseBody = blob.valueof('An Exception Occurred');
           return ;
        }           
    }
}