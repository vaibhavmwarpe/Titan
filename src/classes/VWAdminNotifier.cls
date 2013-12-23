global class VWAdminNotifier implements System.Schedulable{
    // This event runs on the Last Saturday of every month at 2030hrs
	public static String CRON_EXP = '0 30 dasdfasd  20 23 9 ? 2013'; // '0 30 20 ? * 7L'
    
    global void execute(SchedulableContext sc){
        Messaging.SingleEmailMessage mail = formEmailMessageToAdmin();
    	Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });    	    
    }
    
    private Messaging.SingleEmailMessage formEmailMessageToAdmin(){
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {UserInfo.getUserEmail()};
        mail.setToAddresses(toAddresses);
        mail.setReplyTo('scheduler@vaishnav.com');
		mail.setSenderDisplayName('Month End Activity');
        mail.setSubject('Report: Month End Activity');
        mail.setPlainTextBody('Following accounts and contacts have been inserted/ updated in the System');
        return mail;        
	}
}

/*

Debug logs::
System.debug('=========UserInfo.getUserEmail()==========' + UserInfo.getUserEmail());

String jobId = System.schedule('testBasicScheduledApex',
								VWAdminNotifier.CRON_EXP, 
								new VWAdminNotifier());

// Get the information from the CronTrigger API object
CronTrigger ct = [SELECT Id, CronExpression, 
						 TimesTriggered, 
						 NextFireTime
				  FROM CronTrigger 
				  WHERE Id = :jobId];
				  
System.debug('========ct=======is=======' + ct);				  


Map<String, Account> idVsAccoutMap = [SELECT Id, Name FROM Account];
System.debug('========idVsAccoutMap=========' + idVsAccoutMap);

VWBatchAccountUpdator mybatch = new VWBatchAccountUpdator('SELECT Id, Name, Description FROM Account'); 
String cronID = System.scheduleBatch(mybatch, 'job example', 1);

CronTrigger ct = [SELECT Id, TimesTriggered, NextFireTime FROM CronTrigger WHERE Id = :cronID];
				 
// TimesTriggered should be 0 because the job hasn't started yet.
System.assertEquals(0, ct.TimesTriggered);
System.debug('Next fire time: ' + ct.NextFireTime);


List<sObject> sObjectslist = [SELECT id, Name, Industry FROM Account ALL ROWS];
System.debug('====Total account are==========' + sObjectslist.size());
sObjectslist = [SELECT id, Name, Industry FROM Account WHERE isDeleted = False];
System.debug('====Undeleted accounts are==========' + sObjectslist.size());


//List<String> accountIdsList = new List<String>{'0019000000MiWlA', '0019000000KJ30X', '0019000000VcKY4', '0019000000VcKUl', '0019000000VcKUC'};
VWBatchAccountUpdator accountBatch = new VWBatchAccountUpdator('SELECT id, Name, Description FROM Account');
Id processId = Database.executeBatch(accountBatch);

List<sObject> sObjectslist = new List<sObject>();
sObjectslist.add([SELECT id, Name, Industry FROM Account WHERE Name Like '%Arxxus%' LIMIT 1]);
sObjectslist.add([SELECT id, Name, AccountId FROM Contact WHERE email = 'puneet.mishra@arxxus.com'LIMIT 1]);
System.debug('=====sObjectslist=====' + sObjectslist);
sObjectslist[0].
Contact tempContact = (Contact)sObjectslist[1];
tempContact.title = 'Cloud Analyst';
System.debug('=====tempContact=====' + tempContact);




List<String> orderedList = new List<String>();
orderedList.add('Tom Cruise');
orderedList.add('Blbert');
orderedList.add('Evan');
orderedList.add('Flbert');
orderedList.add('Albert');
System.debug('=====orderedList=====' + orderedList);


Set<String> unorderedSet = new Set<String>();
unorderedSet.add('Tom Cruise');
unorderedSet.add('Blbert');
unorderedSet.add('Evan');

unorderedSet.add('Flbert');
unorderedSet.add('Albert');


System.debug('=====unorderedSet=====' + unorderedSet);


System.debug();

System.debug('=======getSalesforceBaseUrl().toExternalForm()=====' + URL.getSalesforceBaseUrl().toExternalForm());

Map<String, String> params = new Map<String, String>{
    Label.From_String => '+14248004152',
        Label.To_String => '+919762231522' ,
        Label.Body_String => 'from the developer console',
        Label.ApplicationSid => 'AP2b1db551e6f7d81e109acb57a9c93bfb'
        };
TwilioAccount account = TwilioAPI.getDefaultAccount();
TwilioSms sms = account.getSmsMessages().create(params); 

public static String paramJSON = '{  "ApiVersion":"2010-04-01",' + 
                                    '"From":"client:testsoftphone",' + 
                                    '"Direction":"inbound",' + 
                                    '"CallSid":"CAd769c99c16afghe83a8acd05b1d1663892e",' + 
                                    '"PhoneNumber":"+919987778888",' + 
                                    '"Called":"",' + 
                                    '"To":"",' + 
                                    '"Caller":"client:testsoftphone",' + 
                                    '"CallStatus":"ringing",' + 
                                    '"ApplicationSid":"AP2b1db551e6frty7d81e109acb57a9c93bfb",' + 
                                    '"AccountSid":"AC6cb1ce3e925d6c9536rtyd74d9b3f2c13a5"}';

Map<String, Object> mapOfJson = (Map<String, Object>)  JSON.deserializeUntyped(paramJSON);
System.debug('========mapOfJson========' + mapOfJson);


List<Lead> leadsList = [SELECT id, Description FROM Lead];
List<Lead> update_leadsList = new List<Lead>();
for(Lead lead : leadsList){
	lead.Description = '.';
	update_leadsList.add(lead);
}	
update(update_leadsList);

String jsonInput = '{"id":"https://login.salesforce.com/id/00D90000000kz7GEAQ/00590000001GQNVAA4","issued_at":"1365076391158","instance_url":"https://ap1.salesforce.com","signature":"qElvEp5LmlXCyrj7EB0EsRf5wE3BMfiUP7EomOCKqr0=","access_token":"00D90000000kz7G!AR8AQG4e76xbm5z8Roz_GvMuiawFeToCMaj1V6E9MggG6l5AxwqswIvKGhhS87pd88UmrYoOtnRK2tefyJ3.7ppMotCCjROC"}';
Map<String, Object> mapOfJson = (Map<String, Object>)  JSON.deserializeUntyped(jsonInput);

System.debug('========mapOfJson========' + TwilioConfig__c.getValues(Label.Twilio_Default_Custom_Setting).SMS_Reply_Message__c);



String ACCOUNT_SID = TwilioConfig__c.getValues(Label.Twilio_Default_Custom_Setting).AccountSid__c;//'AC6cb1ce3e925d6c9536d74d9b3f2c13a5';
String AUTH_TOKEN  = TwilioConfig__c.getValues(Label.Twilio_Default_Custom_Setting).AuthToken__c;//'f20229a53a902072748672321cbc9c91';
    
TwilioRestClient client = new TwilioRestClient(ACCOUNT_SID, AUTH_TOKEN);

Map<String,String> params = 
	new Map<String,String> { 'To' => '+919762231522','From' => '+14248004152','Url' => 'https://vaibhav-sfdev-developer-edition.ap1.force.com/services/apexrest/softcallclient/' };

TwilioCall call = client.getAccount().getCalls().create(params);
System.debug('==========***********======' + call.getDuration());
System.debug('==========***********======' + call.getSid());

String jsonString =
'{"id":"https://login.salesforce.com/id/00D90000000kz7GEAQ/00590000001GQNVAA4","issued_at":"1365076391158","instance_url":"https://ap1.salesforce.com","signature":"qElvEp5LmlXCyrj7EB0EsRf5wE3BMfiUP7EomOCKqr0=","access_token":"00D90000000kz7G!AR8AQG4e76xbm5z8Roz_GvMuiawFeToCMaj1V6E9MggG6l5AxwqswIvKGhhS87pd88UmrYoOtnRK2tefyJ3.7ppMotCCjROC"}';



*/