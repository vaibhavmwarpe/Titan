/**
* @Author    : VW
* @Purpose   : Test Class for TwilioSoftphoneController
*/
@isTest(SeeAllData=True)
public class TwilioSoftphoneController_Test {   
        
    public static testmethod void twilioSoftphoneControllerTest(){    

      // Start the actual tests
        Test.startTest();
        
        //Instantiate a page
        PageReference pageRef = Page.TwilioSoftphone;
        Test.setCurrentPage(pageRef);
        
        //Instantiate and construct the controller class.   
        TwilioSoftphoneController controller = new TwilioSoftphoneController();     
		controller.phoneNumber = '1234567890';
        controller.smsMessage = 'Test SMS';
        
        PageReference pgRef = controller.sendSMS();
        System.assertEquals(pgRef, null); 
        
        pgRef = controller.hangupAction();
        System.assertEquals(pgRef, null); 
        
        System.assertEquals(controller.cancel(), null);
        System.assertEquals(controller.clearMessage(), null);
        
        System.assertEquals(controller.getTwilioPhoneNumber(), TwilioConfig__c.getValues(Label.Twilio_Default_Custom_Setting).Phone_Number__c);
        
        /* To test utility class. Contact/lead without phone or mobile */
        Contact tempContactWithoutPhone = TwilioSoftphoneFactory_Test.getContact_withoutPhone();
        Lead tempLeadWithoutPhone = TwilioSoftphoneFactory_Test.getLead_withoutPhone();        
        
        Contact tempContact = TwilioSoftphoneFactory_Test.getContact();
        Lead tempLead = TwilioSoftphoneFactory_Test.getLead();
        List<sObject> sObjectList = TwilioSoftphoneController.getSFRecord('+918881114444');
        
        System.assertNotEquals(sObjectList , null);
        System.assertEquals(sObjectList.size() , 2);
        
        Boolean flag = TwilioSoftphoneController.isValidPhoneNumber('+918881114444');
        System.assertEquals(flag , true);
        
        flag = TwilioSoftphoneController.isValidPhoneNumber('+91(888) 111-4444');
        System.assertEquals(flag , false);        
         
        sObjectList = TwilioSoftphoneController.getCallersName('+918881114444');
        System.assertNotEquals(sObjectList , null);
        System.assertEquals(sObjectList.size() , 2);
        
        sObjectList = TwilioSoftphoneController.saveNotes('wrong_number',  '' ,'Test Notes Body');
        System.assertEquals(sObjectList , null);
        
        sObjectList = TwilioSoftphoneController.saveNotes('+918881114444','Test Notes Title','Test Notes Body');
        System.assertNotEquals(sObjectList , null);
        // Stop tests
        Test.stopTest();           

    }

}