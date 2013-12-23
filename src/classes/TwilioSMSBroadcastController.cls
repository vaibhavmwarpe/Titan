/**
* @Author    : VW
* @Purpose   : Class to cater to broad cast functionality
*/

public with sharing class TwilioSMSBroadcastController { 
   
    public Boolean isTemplate { get; set; }
    public Boolean isRecord { get; set; }

    public String selectedTemplate { get; set; }
    public String smsMessage { get; set; }
    public List<String> recordSfIds { get; set; }
    public String whatType { get; set; }
    
    public List<Contact> contactsList { get; set; }
    public List<Lead> leadsList { get; set; }
    public List<CampaignMember> campaignMembersList { get; set; }
    
    public List<Sobject> recordsList { get; set; }
    public List<SMSTemplate__c> SMSTemplatesList { get; set; }
    
    public Map<String, String> templateNameAndBodyMap { get; set; }

    public TwilioSMSBroadcastController (){
        
        String recordIdsParam = ApexPages.currentPage().getParameters().get(Label.Ids_String);
        isRecord = false;
        if(recordIdsParam != null)
            recordSfIds = recordIdsParam.split(',');     
        else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Incorrect_URL));            
        }
        SMSTemplatesList = [SELECT id, Display_Name__c, Template_Body__c FROM SMSTemplate__c];
        templateNameAndBodyMap = new  Map<String, String>();
        for(SMSTemplate__c tempTemplate : SMSTemplatesList )
            templateNameAndBodyMap.put(String.valueOf(tempTemplate.id), tempTemplate.Template_Body__c );      
        
        whatType = TwilioSMSHelper.getWhatType(recordSfIds[0]);
    }
    
    public List<Contact> getSelectedContacts() {
        contactsList = [SELECT id, Name, MobilePhone, Twilio_SMS_Enabled__c FROM Contact Where (Id IN : recordSfIds) AND (Twilio_SMS_Enabled__c = True)];
        if(contactsList != null && contactsList.size() > 0)
            isRecord = true;
        return contactsList;
    }
    
    public List<Lead> getSelectedLeads() {
        leadsList = [SELECT id, Name, MobilePhone, Twilio_SMS_Enabled__c FROM Lead Where (Id IN : recordSfIds) AND (Twilio_SMS_Enabled__c = True)];
        if(leadsList != null && leadsList.size() > 0)
            isRecord = true;
        return leadsList;
    }
    
    public List<CampaignMember> getSelectedCampaignMembers() {
        campaignMembersList = [SELECT Id,Twilio_CM_Name__c,Twilio_Mobile__c, CampaignId FROM CampaignMember Where (Id IN : recordSfIds) AND (SMS_Enabled__c = 'True')];
        if(campaignMembersList != null && campaignMembersList.size() > 0)
            isRecord = true;

        return campaignMembersList;
    }
    
    
    public PageReference sendSMSToSelectedRecords() {
        
        try{ 
            if ( whatType == Label.Contact_String && contactsList != null ){
                TwilioSMSBroadcastHelper.sendSMSToSelectedRecords(smsMessage, contactsList, whatType );                  
                return new PageReference('/' + Schema.SObjectType.Contact.getKeyPrefix());
                
            } else if ( whatType == Label.Lead_String && leadsList != null ) {
                TwilioSMSBroadcastHelper.sendSMSToSelectedRecords(smsMessage, leadsList, whatType );       
                return new PageReference('/' + Schema.SObjectType.Lead.getKeyPrefix());          
            } else if ( whatType == Label.CampaignMember_String && campaignMembersList != null ) {
                TwilioSMSBroadcastHelper.sendSMSToSelectedRecords(smsMessage, campaignMembersList , whatType );       
                return new PageReference('/' + campaignMembersList[0].CampaignId);          
            } 
            
        } catch (Exception exp) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL, Label.Exception_Occurred + exp.getMessage()));
            return null;
        }        
            
        return new PageReference('/home/home.jsp');
    }

    /*
     * returns the list of user profiletype
     */
     
    public List<SelectOption> getSMSTemplates() {
    
        List<SelectOption> options = new List<SelectOption>(); 
        
        options.add(new SelectOption('none', '---None---'));
        for(SMSTemplate__c tempSMSTemplate : SMSTemplatesList){
    
            options.add(new SelectOption(tempSMSTemplate.id, tempSMSTemplate.Display_Name__c));
    
        }
    
        return options;
   
    }
    
    
    public PageReference checkBoxAction() {
        if(isTemplate == true && templateNameAndBodyMap != null && templateNameAndBodyMap.size() > 0 && selectedTemplate != 'none'){
            smsMessage = templateNameAndBodyMap.get(selectedTemplate);           
        }
        else{            
            smsMessage = '';            
        }
        return null;
    }

    public PageReference cancel() {
        if ( whatType == Label.Contact_String && contactsList != null )                                
            return new PageReference('/' + Schema.SObjectType.Contact.getKeyPrefix());            
        else if ( whatType == Label.Lead_String && leadsList != null )                  
            return new PageReference('/' + Schema.SObjectType.Lead.getKeyPrefix());     
        else if ( whatType == Label.CampaignMember_String && campaignMembersList != null && campaignMembersList.size() > 0)
            return new PageReference('/' + campaignMembersList[0].CampaignId);   
        return new PageReference('/home/home.jsp');
    }

    public PageReference clearMessage() {
        smsMessage = '';
        return null;
    }

}