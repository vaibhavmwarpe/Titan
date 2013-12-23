/**
* @Author    : VW
* @Purpose   : Test Class for REST services used for Softphone
*/
@isTest(SeeAllData=True)
public class TwilioSoftphoneRESTServices_Test {   
    static String INSTANCE_URL = URL.getSalesforceBaseUrl().toExternalForm();    
    public static testmethod void testOutboundCallService (){    
		
        // Start the actual tests
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
    
        req.requestURI = INSTANCE_URL + '/services/apexrest/softcall/';
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        
        TwilioSoftphoneOutboundHandler.handleSFOutboundCall();        
        
        System.assert(RestContext.response.responseBody.toString().contains('</Dial></Response>'));     
                
        // Stop tests
        Test.stopTest();           

    }
    
    public static testmethod void testInboundCallService (){    
		
        // Start the actual tests
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
    
        req.requestURI = INSTANCE_URL + '/services/apexrest/softcallclient/';
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        
        TwilioSoftphoneInboundHandler.handleSFInboundCall();        
        
        System.assert(RestContext.response.responseBody.toString().contains('</Client></Dial></Response>'));     
                
        // Stop tests
        Test.stopTest();           

    }
    
    public static testmethod void testStatusCallBackService (){    
		
        // Start the actual tests
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
    
        req.requestURI = INSTANCE_URL + '/services/apexrest/softcallstatus/';
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        
        TwilioSoftphoneStatusCBHandler.updateCDR();        
        
        System.assert(RestContext.response.responseBody.toString().contains('<Response></Response>'));    
                
        // Stop tests
        Test.stopTest();           

    }
    
    public static testmethod void testSMSInboundService (){    
		
        // Start the actual tests
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
    	
        req.requestURI = INSTANCE_URL + '/services/apexrest/smsrequest/';
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        
        TwilioSoftphoneSMSInboundHandler.saveSMSMessage();        
        
        //System.assert(RestContext.response.responseBody.toString().contains('</Sms></Response>'));    
                
        // Stop tests
        Test.stopTest();           

    }
    
    public static testmethod void testSMSStatusCallBackService (){    
		
        // Start the actual tests
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
    
        req.requestURI = INSTANCE_URL + '/services/apexrest/smsStatusCallback/';
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        
        TwilioSoftphoneSMSStatusCBHandler.updateSMSMessage();        
        
        System.assert(RestContext.response.responseBody.toString().contains('<Response></Response>'));    
                
        // Stop tests
        Test.stopTest();           

    }
    
    
    
    

}