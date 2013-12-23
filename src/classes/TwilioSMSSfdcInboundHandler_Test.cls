/**
* @Author    : VW
* @Purpose   : Test Class for TwilioSMSSfdcInboundHandler
*/

@isTest
public class TwilioSMSSfdcInboundHandler_Test {

    static testMethod void testdoPost() {
  
        Map<String, String> requestsMap = new Map<String, String>{   'AccountSid' => 'AC0870a85989c2b1cc98813212d240488a', 
                                                                     'ApiVersion' => '2010-04-01', 
                                                                     'Body' => 'Test Message', 
                                                                     'From' => '+918308791135', 
                                                                     'SmsMessageSid' => 'SM2df44f070d128959eb1a509c83d1eb04', 
                                                                     'SmsSid' => 'SM2df44f070d128959eb1a509c83d1eb04'
                                                                     };

        String JSONMsg= JSON.serialize('Anything');
        
        RestRequest req = new RestRequest();
        req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
        req.requestURI = '/services/apexrest/requestsf/';
        req.httpMethod = 'POST';
        
        req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST
        
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;
        
        TwilioSMSSfdcInboundHandler.saveSMSMessage();
        
        //System.assertEquals(res.responseBody.toString().contains('Thanks for sending message'), True);
        
    }    
}