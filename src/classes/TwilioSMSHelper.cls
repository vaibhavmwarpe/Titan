public with sharing class TwilioSMSHelper{
    
    public static void insertSMSMessageRecords(String smsMessage, List<SObject> sObjectList, String fromNumber, String toNumber, String direction, String status, String sid) {
        List<SMSMessage__c> smsMessageInsertList = new List<SMSMessage__c> ();
        SMSMessage__c tempSMSMessage;
        
        try {
            for( SObject tempSobject : sObjectList ){
              tempSMSMessage = new SMSMessage__c(); 
                tempSMSMessage.Body__c = smsMessage;
                tempSMSMessage.Direction__c = direction;
                tempSMSMessage.From__c = fromNumber;
                tempSMSMessage.To__c = toNumber;
                tempSMSMessage.Status__c = status;
                tempSMSMessage.Sid__c = sid;
                if(TwilioSMSHelper.getWhatType(tempSobject.id) == Label.Contact_String)
                    tempSMSMessage.Contact__c = tempSobject.id;
                else if(TwilioSMSHelper.getWhatType(tempSobject.id) == Label.Lead_String)
                    tempSMSMessage.Lead__c = tempSobject.id;
                smsMessageInsertList.add(tempSMSMessage);
            }
            
            insert smsMessageInsertList;
 			
        }  catch (Exception exp) {
              System.debug(Label.An_Exception_Occurred);
        }
    }
        
    public static void attachSMSMessageToRecords( Map<String, String> params){
        
        List<Sobject> sobjContactList = new List<Sobject>(); 
        List<Sobject> sobjLeadList = new List<Sobject>();
        List<Sobject> sobjAllList = new List<Sobject>();
        String fromNumber ='';
       
        if( params != null ){
            fromNumber = params.get('From');
            if(fromNumber.startsWith('+'))
            	fromNumber = removePlus(fromNumber);
            
            //sobjContactList = [SELECT id, MobilePhone, Phone, Name FROM Contact WHERE (Phone LIKE : '%'+fromNumber+'%' OR  MobilePhone LIKE : '%'+fromNumber+'%')];//AND Twilio_SMS_Enabled__c = True];  
            //sobjLeadList = [SELECT id, MobilePhone, Phone, Name FROM Lead WHERE (Phone LIKE : '%'+fromNumber+'%' OR  MobilePhone LIKE : '%'+fromNumber+'%')];//AND Twilio_SMS_Enabled__c = True];   
            sobjContactList = [SELECT id, MobilePhone, Phone, Name,Phone_E164__c , Mobile_E164__c FROM Contact WHERE (Phone_E164__c LIKE : '%'+fromNumber+'%' OR  Mobile_E164__c LIKE : '%'+fromNumber+'%')];//AND Twilio_SMS_Enabled__c = True];  
            sobjLeadList = [SELECT id, MobilePhone, Phone, Name,Phone_E164__c , Mobile_E164__c FROM Lead WHERE (Phone_E164__c LIKE : '%'+fromNumber+'%' OR  Mobile_E164__c LIKE : '%'+fromNumber+'%')];//AND Twilio_SMS_Enabled__c = True];   
            sobjAllList.addAll(sobjContactList);
            sobjAllList.addAll(sobjLeadList);
            
            if( sobjAllList != null && sobjAllList.size() > 0){
                  insertSMSMessageRecords(params.get('Body'), sobjAllList, fromNumber,  params.get('To'), Label.Inbound_String, Label.Received_String, params.get('SmsSid'));                                      
            } else {
                  System.debug('No Contact In SF System !!!');
            }
            
        } else
            System.debug('Incorrect Params');
  }
    
    private static Map<String, String> getObjCodeMap(){
        Map<String, String> stdObjToStdCodeMap = 
          new Map<String, String>{
                  Schema.SObjectType.Account.getKeyPrefix() => 'Account',
                    Schema.SObjectType.Contact.getKeyPrefix() => 'Contact',
                    Schema.SObjectType.User.getKeyPrefix() => 'User',
                    Schema.SObjectType.Lead.getKeyPrefix() => 'Lead',
                    Schema.SObjectType.CampaignMember.getKeyPrefix() => 'CampaignMember'   
                    };
        return stdObjToStdCodeMap;                     
    }
    
    public static String getWhatType(String whatSFId){        
    
        String whatType ='';
        if( whatSFId != null && (whatSFId.trim().length()== 15 || whatSFId.trim().length() == 18)){ 
            
            whatType = getObjCodeMap().get(whatSFId.trim().subString(0,3));   
            
            return whatType;
        }
        else
            return 'Unknown';
    }   
    
    public static Map<String, String> getCMIdVsContactORLeadIdMap (List<SObject> sObjectList){
        List<CampaignMember> cmList ;
        Map<String, String> cmIdVsContactORLeadIdMap;        
        
        if(sObjectList != null && (sObjectList.size() > 0) ){
            
            List<CampaignMember> tempCMlist = [SELECT Id, CampaignId, ContactId, LeadId FROM CampaignMember WHERE Id =: sObjectList[0].id LIMIT 1];
            
            cmList = [ SELECT Id, CampaignId, ContactId, LeadId 
                       FROM CampaignMember 
                       WHERE CampaignId =: tempCMlist[0].CampaignId                                          
                     ];
        }                                                                                                      
        
        if(cmList != null && cmList.size() > 0){
          cmIdVsContactORLeadIdMap = new Map<String, String>();
          
            for(CampaignMember tempCM : cmList){
                if(tempCM.ContactId != null && String.valueOf(tempCM.ContactId).trim() != '')
                    cmIdVsContactORLeadIdMap.put(tempCM.Id, tempCM.ContactId);
                else if(tempCM.LeadId != null && String.valueOf(tempCM.LeadId).trim() != '')
                    cmIdVsContactORLeadIdMap.put(tempCM.Id, tempCM.LeadId);                    
            }  
        
        }  
        
        return cmIdVsContactORLeadIdMap;
        
    }
    public static void createSMSMessageRecords(String smsMessage, List<SObject> sObjectList, String whatType, String fromNumber, String direction) {
        List<SMSMessage__c> smsMessageInsertList = new List<SMSMessage__c> ();        
        Map<String, String> cmIdVsContactORLeadIdMap = new Map<String, String>();
        SMSMessage__c tempSMSMessage;
        try{
            if(whatType == 'CampaignMember')
              cmIdVsContactORLeadIdMap = getCMIdVsContactORLeadIdMap(sObjectList);
                
            for( SObject tempSobject : sObjectList ){
                tempSMSMessage = new SMSMessage__c(); 
                tempSMSMessage.Body__c = smsMessage;
                tempSMSMessage.Direction__c = direction;
                tempSMSMessage.From__c = fromNumber;
                tempSMSMessage.Status__c = 'Sent';
                
                if(whatType == 'Contact') 
                    tempSMSMessage.Contact__c = tempSobject.id;
                else if(whatType == 'Lead')
                    tempSMSMessage.Lead__c = tempSobject.id;
                else if(whatType == 'CampaignMember'){
                    
                    if(TwilioSMSHelper.getWhatType(cmIdVsContactORLeadIdMap.get(tempSobject.id)) == 'Contact')
                      tempSMSMessage.Contact__c = cmIdVsContactORLeadIdMap.get(tempSobject.id);
                     else if(TwilioSMSHelper.getWhatType(cmIdVsContactORLeadIdMap.get(tempSobject.id)) == 'Lead')
                        tempSMSMessage.Lead__c = cmIdVsContactORLeadIdMap.get(tempSobject.id);
                        
                }
                smsMessageInsertList.add(tempSMSMessage);
            }
            
            insert smsMessageInsertList;
            
       } catch (Exception exp) {
              System.debug(Label.An_Exception_Occurred);
        } 
    
    }
    
    public static void createSingleSMSMessageRecord(String smsMessage, SObject sfObject, String whatType, String fromNumber, String direction, String status) {             
        
        SMSMessage__c tempSMSMessage = new SMSMessage__c();        
        try {
            tempSMSMessage.Body__c = smsMessage;
            tempSMSMessage.Direction__c = direction;
            tempSMSMessage.From__c = fromNumber;
            tempSMSMessage.Status__c = status;
            
            if(whatType == 'Contact') 
                tempSMSMessage.Contact__c = sfObject.id;
            else if(whatType == 'Lead')
                tempSMSMessage.Lead__c = sfObject.id;      
            
            insert tempSMSMessage;
            
        } catch (Exception exp) {
              System.debug(Label.An_Exception_Occurred);
        }    
            
    }
    
    public static void createSingleSMSMessageRecord(Map<String, String> params) {             
        
        SMSMessage__c tempSMSMessage = new SMSMessage__c();        
        List<Sobject> sobjAllList;
        
        try {
            sobjAllList = getSobjectList(params.get('To'));
            System.debug('innn createSingleSMSMessageRecord=====sobjAllList==' + sobjAllList + '===params=======' + params);
            if(sobjAllList != null && sobjAllList.size() > 0 ) {
            	insertSMSMessageRecords(params.get('Body'), sobjAllList, params.get('From'), params.get('To'), Label.Outbound_String, Label.Sent_String,params.get('SmsSid'));
            }
            /*tempSMSMessage.Body__c = smsMessage;
            tempSMSMessage.Direction__c = direction;
            tempSMSMessage.From__c = fromNumber;
            tempSMSMessage.Status__c = status;
            
            if(whatType == 'Contact') 
                tempSMSMessage.Contact__c = sfObject.id;
            else if(whatType == 'Lead')
                tempSMSMessage.Lead__c = sfObject.id;      
            
            insert tempSMSMessage;*/
            
        } catch (Exception exp) {
              System.debug(Label.An_Exception_Occurred);
        }    
            
    }
    
    public static List<Sobject> getSobjectList(String fromNumber){
        List<Sobject> sobjContactList = new List<Sobject>(); 
        List<Sobject> sobjLeadList = new List<Sobject>();
        List<Sobject> sobjAllList = new List<Sobject>();
        String searchNumber = fromNumber;
		if(fromNumber.startsWith('+'))
            searchNumber = removePlus(fromNumber);
        System.debug('==========in getSobjectList() searchNumber======' + searchNumber );
        //sobjContactList = [SELECT id, MobilePhone, Phone, Name FROM Contact WHERE ( Phone LIKE : '%'+searchNumber+'%' OR MobilePhone LIKE : '%'+searchNumber+'%' ) LIMIT 10];  
        //sobjLeadList = [SELECT id, MobilePhone, Phone, Name FROM Lead WHERE ( Phone LIKE : '%'+searchNumber+'%' OR MobilePhone LIKE : '%'+searchNumber+'%' ) LIMIT 10]; 
        sobjContactList = [SELECT id, MobilePhone, Phone, Name,Phone_E164__c , Mobile_E164__c FROM Contact WHERE ( Phone_E164__c LIKE : '%'+searchNumber+'%' OR Mobile_E164__c LIKE : '%'+searchNumber+'%' ) LIMIT 10];  
        sobjLeadList = [SELECT id, MobilePhone, Phone, Name, Phone_E164__c , Mobile_E164__c FROM Lead WHERE ( Phone_E164__c LIKE : '%'+searchNumber+'%' OR Mobile_E164__c LIKE : '%'+searchNumber+'%' ) LIMIT 10]; 
        sobjAllList.addAll(sobjContactList);
        sobjAllList.addAll(sobjLeadList);        
		System.debug('innn getSobjectList=====sobjAllList==' + sobjAllList);
        return sobjAllList;
    }
                          
    public static String removePlus(String phoneNumber){
        return phoneNumber.substringAfter('+');
    }  
    
    public static String addPlus(String phoneNumber){
        return '+' + phoneNumber;
    } 
}