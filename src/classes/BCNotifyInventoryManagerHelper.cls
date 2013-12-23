public class BCNotifyInventoryManagerHelper{
    public void sendEmailToManager(){
        Messaging.SingleEmailMessage mail = formEmailMessageToAdmin();
    	Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
    }
    
    private Messaging.SingleEmailMessage formEmailMessageToAdmin(){
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {UserInfo.getUserEmail()};
        mail.setToAddresses(toAddresses);
        mail.setReplyTo('bcscheduler@vaishnav.com');
		mail.setSenderDisplayName('BC Admin Center');
        mail.setSubject('New Products Have Been Added Today !!');
        mail.setPlainTextBody('Following Products have been added have been inserted/ updated in the Store today');
        List<Product2> productsList = [SELECT Id, Name, Availability__c, Description FROM Product2 LIMIT 5];
        
        Messaging.EmailFileAttachment tempFile = new Messaging.EmailFileAttachment();
        tempFile.setBody(Blob.valueOf(JSON.serializePretty(productsList)));
        tempFile.setContentType('application/json');
        tempFile.setFileName('Products List @ ' + System.now());
               
        mail.setFileAttachments(new List<Messaging.EmailFileAttachment> {tempFile});            
        return mail;        
	}
}