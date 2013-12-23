/**
* @Author    : VW
* @Purpose   : Test Class for TwilioSMSBroadcastController
*/
@isTest(SeeAllData=True)
public class TwilioSMSBroadcastController_Test {   
        
    public static testmethod void testTwilioSMSBroadcastController_Contact(){        
        String recordsIds = ''; 
        Contact contact;
       
        List<Contact> contactList = TwilioSMSFactory.getContactsList(5);
        for(Contact tempContact : contactList){
            recordsIds = recordsIds + tempContact.id + ',';
        }
        
        // Start the actual tests
        Test.startTest();
        
        //Instantiate a page
        PageReference pageRef = Page.TwilioSMSBroadcastPage;
        Test.setCurrentPage(pageRef);  
        ApexPages.currentPage().getParameters().put(Label.Ids_String, recordsIds);
        
        //Instantiate and construct the controller class.   
        TwilioSMSBroadcastController controller = new TwilioSMSBroadcastController();       
        System.assertNotEquals(controller.recordSfIds, null);
                
        PageReference pgRef = controller.sendSMSToSelectedRecords();
        System.assertEquals(pgRef.getURL(), '/home/home.jsp');

        controller.getSelectedContacts();
        controller.getSelectedLeads();
        controller.getSelectedCampaignMembers();
        controller.cancel();
        controller.checkBoxAction();
        controller.getSMSTemplates();
        controller.clearMessage();
        System.assertEquals(controller.smsMessage, '');  
        
        // Stop tests
        Test.stopTest();          
    }
    
    public static testmethod void testTwilioSMSBroadcastController_Lead(){
        String recordsIds = ''; 
        Lead lead;
        
        Test.startTest();
        //Instantiate a page
        PageReference pageRef = Page.TwilioSMSBroadcastPage;
        Test.setCurrentPage(pageRef);  

        ApexPages.currentPage().getParameters().put(Label.Ids_String, recordsIds);

        List<Lead> leadsList = TwilioSMSFactory.getLeadsList(5);
        
        for(Lead tempLead : leadsList){           
            recordsIds = recordsIds + tempLead.id + ',';
        }
        
        TwilioSMSBroadcastController controller = new TwilioSMSBroadcastController();       
        System.assertNotEquals(controller.recordSfIds, null);
        PageReference pgRef = controller.sendSMSToSelectedRecords();
        System.assertEquals(pgRef.getURL(), '/home/home.jsp');

    }

}