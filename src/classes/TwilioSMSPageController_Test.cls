/**
* @Author    : VW
* @Purpose   : Test Class for TwilioSMSPageController
*/
@isTest(SeeAllData=True)
public class TwilioSMSPageController_Test {   
        
    public static testmethod void twilioSMSPageControllerTest(){        

        Contact contact = TwilioSMSFactory.getContact();
        Lead lead = TwilioSMSFactory.getLead();
        
        // Start the actual tests
        Test.startTest();
        
        //Instantiate a page
        PageReference pageRef = Page.TwilioSMSPage;
        Test.setCurrentPage(pageRef);  
        
        //Instantiate and construct the controller class.   
        TwilioSMSPageController controller = new TwilioSMSPageController();
        
        ApexPages.currentPage().getParameters().put(Label.sfid_String, contact.id);
        
        controller = new TwilioSMSPageController();

        // Assert Test Results
        System.assertNotEquals(controller.account, null);
        System.assertEquals(controller.twilioPhoneNumber, TwilioConfig__c.getAll().values().Phone_Number__c);
		System.assertEquals(controller.mobileNumber, contact.MobilePhone);
        
        PageReference pgRef = controller.sendSMS();
        System.assertEquals(pgRef, null);
        
        pgRef = controller.cancel();        
        System.assertEquals(pgRef.getURL(), '/' + contact.id);
        
        pgRef = controller.clearMessage();
        System.assertEquals(controller.message, '');
        System.assertEquals(pgRef, null);
        
        ApexPages.currentPage().getParameters().put(Label.sfid_String, lead.id);
        
        //Instantiate and construct the controller class.   
        controller = new TwilioSMSPageController();
        System.assertEquals(controller.mobileNumber, lead.MobilePhone);
        
        // Stop tests
        Test.stopTest();           

    }

}