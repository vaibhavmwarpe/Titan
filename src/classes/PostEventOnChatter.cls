/********** Created By   : Suman Gupta *********
*********** Organization : Arxxus Technology Partners ***************
*********** Description  : This class is used for post event to chatter on related object
*********** Created Date : 05-06 -12**********
*/
global class PostEventOnChatter implements  PostActivityOnChatter{
	/* Variable Declarartion  */
	static Event newEvent = new Event();
	static objectprefix__c sobjectName = new objectprefix__c();	
	static list<string> listParentId = new list<string>();
	
	/* this method will be called by ajax toolkit */
	webservice static void postToChatter(string taskID){
		list<sObject> executeWhoIdlist= new list<sObject>();
		list<sObject> executeWhatIdlist= new list<sObject>();
		list<sObject> whoIdRecord = new list<sObject>();
		list<sObject> whatIdRecord = new list<sObject>();
		if(taskID.length()>=15){
			// TODO : Fetch Event Record*/	
			newEvent = [ select id, subject, who.Name, What.Name,WhoID,WhatId, 
							Description,ActivityDate,ownerId From Event where id=:taskID];
			
			//ToDo : Inser new custom Setting Record
			insertRecordInCustomSetting();
		  //TODO : Fetch Record of Whoid 
		    if(newEvent.WhoId != null){
				whoIdRecord = whoIdObjectList(newEvent.WhoID);
				//TODO : Post Description to WhoID Detail Page
				postDescriptionToChatter(whoIdRecord);
		    }
			//TODO : Fetch Record of Whatid 
			if(newEvent.WhatId != null){
				whatIdRecord = whatIdObjectList(newEvent.WhatId);
				//TODO : Post Description to WhatID Detail Page
				postDescriptionToChatter(whatIdRecord);
			}
			//TODO : follow activity on chaater
			followActivityOnChatter(listParentId);
			
		}
		
	} 
	//TODO : fetch who id records
	global static list<sObject> whoIdObjectList(string WhoID){
		
		sobjectName = objectprefix__c.getValues(WhoID.substring(0,3));	
			    	
    	string WhoIdObj = sobjectName.ObjectName__c;
    	string queryWhoId = 'select id from '+ WhoIdObj +' Where id= '+'\''+WhoID+'\'';
    	list<sObject> executeWhoIdlist = Database.query(queryWhoId);
		return executeWhoIdlist;
	}
	//TODO : fetch what id records
	global static list<sObject> whatIdObjectList(string WhatID){
		
		sobjectName = objectprefix__c.getValues(WhatID.substring(0,3));	
				    	
    	string WhatIdObj = sobjectName.ObjectName__c;
    	string queryWhoId = 'select id from '+ WhatIdObj +' Where id= '+'\''+WhatID+'\'';
    	list<sObject> executeWhatIdlist = Database.query(queryWhoId);
		return executeWhatIdlist;
	}
	//TODO : Post Chatter Description to related object
	global static void postDescriptionToChatter(list<sObject> listObjRecord){
		list<FeedItem> post = new list<FeedItem>();
		for(sObject t : listObjRecord ){
	    	string body = '';
	    	body += 'Posting an activity update :\n';			    	
	    	if(newEvent.Subject != null)
	    	body += 'Subject :  '+newEvent.Subject ;	
	    	if(newEvent.Who.Name != null)
	    	body += ' related to ' + newEvent.Who.Name;			    				    	
	    	if(newEvent.Description != null)
	    	body += '\nDescription :  '+newEvent.Description;
	    	listParentId.add(t.id);
	    	FeedItem ps = new FeedItem();
			ps.ParentId = t.id;
			ps.Body = body;
			post.add(ps);
	    }
	    insert post;
		
	}
	// TODO : Follow Activity On Chatter
	global static void followActivityOnChatter(list<string> parentIds){
		list<string> UserIdId = new list<string>();
		list<EntitySubscription> newSUbscriber = new list<EntitySubscription>();
		/* Fetch the record of user who follow the record of WhoID and WhatId */
	    list<EntitySubscription> listEntitySubscription= [Select id,SubscriberId, ParentId From EntitySubscription
	    												  where ParentId IN:parentIds];
	    
	    for(EntitySubscription tempEntity :listEntitySubscription ){
	    	UserIdId.add(tempEntity.SubscriberId);
	    	
	    }
	    /* Follow the task on chatter */
	    if(UserIdId.size()>0){
	    	for(string st:UserIdId){
	    		EntitySubscription newSub = new EntitySubscription(SubscriberId =st,ParentId = newEvent.id);
	    		newSUbscriber.add(newSub);
	    	}
	    	try{
	    		database.insert(newSUbscriber,false);
	    	}
	    	catch(Exception e){}
	    }
		
	}
	
	// TODO : Insert custom Setting record if required Object name is not found
	global static void insertRecordInCustomSetting(){
		objectprefix__c checkSobjectn = objectprefix__c.getValues('003');
		/* TODO  : Insert record in Custom Setting if org is new */
		if(checkSobjectn == null || test.isRunningTest()){
			Map<String,Schema.SObjectType> gd = Schema.getGlobalDescribe();
	        Map<String, String> keyPrefixMap = new Map<String, String>{};
	        
	        Set<String> keyPrefixSet = gd.keySet();
	        list<ObjectPreFix__c> listObj = new list<ObjectPreFix__c>();
	        for(String sObj : keyPrefixSet)
	        {
	            Schema.DescribeSObjectResult r =  gd.get(sObj).getDescribe();
	            String tempName = r.getName();
	            String tempPrefix = r.getKeyPrefix();			           
	            if(tempPrefix!= null){
	            string tPrefix = tempPrefix.subString(0,3);
	           
	            ObjectPreFix__c objectName = new ObjectPreFix__c(name=tPrefix,ObjectName__c=tempName);
	            
	            listObj.add(objectName);
	            }
	        }
			database.insert(listObj,false);
		}
	}

}