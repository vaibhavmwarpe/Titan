/**
* @Author    : VW
* @Purpose   : This is a helper class to request handler services.
*/

public class TwilioSoftphoneHelper {
	
    /* A method to create CDR for inbound and outbound calls. 
	 * @param		parameters map, call's direction (wrt salesforce)
     * @return      void
     */
    public static void createCDRRecord(Map<String, String> paramsMap, String direction){
        CDR__c tempCDR = new CDR__c();       
        //system.debug('=======SalesTwilioSoftcallHelper ======Params from Twilio'+system.JSON.serialize(paramsMap));
        
		// For outbound calls from Softphone, just in case browser is not registered with Twilio by any name. Need to show 'Browser' as a caller. 
        // Other times Twilio's post request contains 'From' param 
        tempCDR.From__c = ( paramsMap.get('From') != '' ) ? paramsMap.get('From') : Label.Browser_String;
        
        // This is checked because, when client calls out, "To" param is not sent from Twilio. So to get "To" number, 
        // use 'PhoneNumber' param which is passed on to Twilio by Client.
        if( paramsMap.get('PhoneNumber') != null && paramsMap.get('PhoneNumber') != '')
            tempCDR.To__c = paramsMap.get('PhoneNumber');
        else
            tempCDR.To__c = paramsMap.get('To');
        
        // Twilio's post request 'Direction' 
        tempCDR.Direction__c = paramsMap.get('Direction'); 
        // call sid is used to uniquely identify any call
        tempCDR.Sid__c = paramsMap.get('CallSid');
        // salesforce specific direction.
        tempCDR.Salesforce_Direction__c = direction;
        
        List<sObject> possibleCallersList = (direction.equalsIgnoreCase(Label.Outbound_String)) ? getCallersName(paramsMap.get('PhoneNumber')) : getCallersName(paramsMap.get('From'));
        
        if(possibleCallersList != null && possibleCallersList.size() == 1){
            if(getWhatObjType(possibleCallersList[0].id).equalsIgnoreCase(Label.Contact_String) )
        		tempCDR.Contact__c = possibleCallersList[0].id;
            else if(getWhatObjType(possibleCallersList[0].id).equalsIgnoreCase(Label.Lead_String) )
            	tempCDR.Lead__c = possibleCallersList[0].id;
        }    
        try{
            // insert this CDR. 
            insert tempCDR;
            
        } catch(Exception e) {
            System.debug('=============Exception in createCDRRecord========' + e.getMessage());
        }        
    }
    	
    /* A method to update CDR for inbound and outbound calls. This method gets called by status call back Rest service.
     * This updates the CDR with appropriate call back params like duration n all
	 * @param		parameters map
     * @return      void
     */
    public static void updateCDRRecord(Map<String, String> paramsMap){
        try{
            // get the call sid from params
            String callSidString = paramsMap.get('CallSid');
            // fetch the CDR with sid to update
            List<CDR__c> cdrList = [SELECT Id, Name, Sid__c FROM CDR__c WHERE Sid__c =: callSidString LIMIT 1];
            
            if( cdrList != null && cdrList.size() > 0 ) {
                cdrList[0].CallDuration__c = paramsMap.get('CallDuration');
                cdrList[0].recordingUrl__c = paramsMap.get('RecordingUrl');
                cdrList[0].callstatus__c = paramsMap.get('CallStatus');
                cdrList[0].FromCountry__c = paramsMap.get('FromCountry');
                cdrList[0].FromState__c = paramsMap.get('FromState');     
                // update it.
                update cdrList[0]; 
            }
        } catch(Exception e) {
            System.debug('=============Exception in updateCDRRecord========' + e.getMessage());
        }         
    }    
        	
    /* A method to get list of sObjects which contains passed in string as Phone or Mobile (E.164 std)
	 * @param		phone number string
     * @return      list of sObjects
     */
    public static List<Sobject> getCallersName(String callerNumber) {
        List<sObject> callerContactsList ;
        List<sObject> callerLeadsList ;
        System.debug('=======in getCallersName(callerNumber)===========' + callerNumber);
        callerContactsList = [  SELECT Id, Name, Phone, MobilePhone, Phone_E164__c , Mobile_E164__c   
                                FROM Contact 
                                WHERE Phone_E164__c =: callerNumber OR Mobile_E164__c =: callerNumber
                                LIMIT 1];
                        
        callerLeadsList = [  SELECT Id, Name, Phone, MobilePhone, Phone_E164__c , Mobile_E164__c 
                             FROM Lead 
                             WHERE Phone_E164__c =: callerNumber OR Mobile_E164__c =: callerNumber
                             LIMIT 1];
                    
                    
        List<sObject> callerSObjsList = new List<sObject>();
        
        // Add contacts/ leads in the generic list
        if(callerContactsList != null && callerContactsList.size() > 0){
            callerSObjsList.addAll(callerContactsList);
        }
        
        if(callerLeadsList != null && callerLeadsList.size() > 0){
            callerSObjsList.addAll(callerLeadsList);
        }
        
        return callerSObjsList;       
        
    }    
    /* Object Prefix to Object Name Map */
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
    
    /* A method to get the name of the object by first three characters in object id
	 * @param		sfdc object id
     * @return      sfdc std Object name
     */
    public static String getWhatObjType(String whatSFId){        
    
        String whatType ='';
        if( whatSFId != null && (whatSFId.trim().length()== 15 || whatSFId.trim().length() == 18)){ 
            
            whatType = getObjCodeMap().get(whatSFId.trim().subString(0,3));   
            
            return whatType;
        }
        else
            return 'Unknown';
    }
    
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
                if(getWhatObjType(tempSobject.id) == Label.Contact_String)
                    tempSMSMessage.Contact__c = tempSobject.id;
                else if(getWhatObjType(tempSobject.id) == Label.Lead_String)
                    tempSMSMessage.Lead__c = tempSobject.id;
                smsMessageInsertList.add(tempSMSMessage);
            }
            
            insert smsMessageInsertList;
 			
        }  catch (Exception exp) {
              System.debug(Label.An_Exception_Occurred);
        }
    }
    
    public static void insertSMSMessageRecords(String smsMessage, String fromNumber, String toNumber, String direction, String status, String sid) {
       List<SMSMessage__c> smsMessageInsertList = new List<SMSMessage__c> ();
        SMSMessage__c tempSMSMessage;
        
        try {
            
            tempSMSMessage = new SMSMessage__c(); 
            tempSMSMessage.Body__c = smsMessage;
            tempSMSMessage.Direction__c = direction;
            tempSMSMessage.From__c = fromNumber;
            tempSMSMessage.To__c = toNumber;
            tempSMSMessage.Status__c = status;
            tempSMSMessage.Sid__c = sid;               
            
            insert tempSMSMessage;
 			
        }  catch (Exception exp) {
              System.debug(Label.An_Exception_Occurred);
        }
    }
        
    public static void attachSMSMessageToRecords( Map<String, String> params){
        System.debug('======In attachSMSMessageToRecords()=====params===' + params);
        List<Sobject> sobjContactList = new List<Sobject>(); 
        List<Sobject> sobjLeadList = new List<Sobject>();
        List<Sobject> sobjAllList = new List<Sobject>();
        String fromNumber ='';
       
        if( params != null ){
            fromNumber = params.get('From');
            if(fromNumber.startsWith('+'))
            	fromNumber = removePlus(fromNumber);            
            
            sobjContactList = [SELECT id, MobilePhone, Phone, Name,Phone_E164__c , Mobile_E164__c FROM Contact WHERE (Phone_E164__c LIKE : '%'+fromNumber+'%' OR  Mobile_E164__c LIKE : '%'+fromNumber+'%')];//AND Twilio_SMS_Enabled__c = True];  
            sobjLeadList = [SELECT id, MobilePhone, Phone, Name,Phone_E164__c , Mobile_E164__c FROM Lead WHERE (Phone_E164__c LIKE : '%'+fromNumber+'%' OR  Mobile_E164__c LIKE : '%'+fromNumber+'%')];//AND Twilio_SMS_Enabled__c = True];   
            sobjAllList.addAll(sobjContactList);
            sobjAllList.addAll(sobjLeadList);
            
            if( sobjAllList != null && sobjAllList.size() > 0){
                  insertSMSMessageRecords(params.get('Body'), sobjAllList, fromNumber,  params.get('To'), Label.Inbound_String, Label.Received_String, params.get('SmsSid'));                                      
            } else {
                  insertSMSMessageRecords(params.get('Body'), fromNumber,  params.get('To'), Label.Inbound_String, Label.Received_String, params.get('SmsSid'));   
            }
            
        } else
            System.debug('Incorrect Params');
   }
        
    public static void createSingleSMSMessageRecord(Map<String, String> params) {             
        
        SMSMessage__c tempSMSMessage = new SMSMessage__c();        
        List<Sobject> sobjAllList;
        System.debug('====in createSingleSMSMessageRecord()====params===' + params);
        try {
            sobjAllList = getSobjectList(params.get('To'));
            System.debug('====innn createSingleSMSMessageRecord=====sobjAllList==' + sobjAllList + '===params=======' + params);
            if(sobjAllList != null && sobjAllList.size() > 0 ) {
            	insertSMSMessageRecords(params.get('Body'), sobjAllList, params.get('From'), params.get('To'), Label.Outbound_String, Label.Sent_String,params.get('SmsSid'));
            }else{
            	insertSMSMessageRecords(params.get('Body'), params.get('From'), params.get('To'), Label.Outbound_String, Label.Sent_String,params.get('SmsSid'));
            }
            
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