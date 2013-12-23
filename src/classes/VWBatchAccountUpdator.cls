/*
* This class is s batch class to update the Accounts that meet the criteria.
*/

global class VWBatchAccountUpdator implements Database.Batchable<Account>{ 
    String queryString;
    global VWBatchAccountUpdator(String queryStr){
    	queryString = queryStr;
    }    
    /*global Database.QueryLocator start(Database.BatchableContext bc){
		return Database.getQueryLocator(queryString);            	
    }*/	
    
    global Iterable<Account> start(Database.BatchableContext bc){
		return new VWAccIterable(queryString);
    }
    
    
    global void execute(Database.BatchableContext bc, List<sObject> sObjsList){
    	DateTime currentDT = System.now(); //This return current Datetime in GMT timezone
        List<sObject> sObjectUpdateList = new List<sObject>();
        for(sObject tempsObject : sObjsList){
        	tempsObject.put('Description', 'This account- ' + tempsObject.get('name') + ' has been updated on ' + currentDT);
            sObjectUpdateList.add(tempsObject);
        } 
        update sObjectUpdateList;
        
    }
        
    global void finish(Database.BatchableContext bc){
        // Get the ID of the AsyncApexJob representing this batch job from Database.BatchableContext.
        // Query the AsyncApexJob object to retrieve the current job's information.
        AsyncApexJob aaj = [ SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
                                    TotalJobItems, CreatedBy.Email
                             FROM AsyncApexJob 
                             WHERE Id =: bc.getJobId()];
                              
        // Send an email to the Apex job's submitter notifying of job completion.
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {aaj.CreatedBy.Email};
        mail.setToAddresses(toAddresses);
        mail.setReplyTo('batch@vaishnav.com');
		mail.setSenderDisplayName('Batch Processing');
        mail.setSubject('Account updation ' + aaj.Status);
        mail.setPlainTextBody
        ('The batch Apex job processed ' + aaj.TotalJobItems + ' batches with '+ aaj.NumberOfErrors + ' failures.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }	
}