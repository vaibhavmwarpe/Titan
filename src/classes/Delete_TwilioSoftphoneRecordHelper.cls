public class Delete_TwilioSoftphoneRecordHelper {
    
    public static final String ACCOUNT_SID = TwilioConfig__c.getValues(Label.Twilio_Default_Custom_Setting).AccountSid__c;//'AC6cb1ce3e925d6c9536d74d9b3f2c13a5';
    public static final String AUTH_TOKEN  = TwilioConfig__c.getValues(Label.Twilio_Default_Custom_Setting).AuthToken__c;//'f20229a53a902072748672321cbc9c91';
    public static final String CALLOUT_URI = TwilioConfig__c.getValues(Label.Twilio_Default_Custom_Setting).Site_Default_Secure_Web_Address__c;
    
    public static void dialOutToRecordNumber (Map<String, String> paramsMap){
        // write a logic to dial out to record's number first
               
        TwilioRestClient client = new TwilioRestClient(ACCOUNT_SID, AUTH_TOKEN);
         
        String toNumber = paramsMap.get('PhoneNumber');
        String fromNumber = TwilioConfig__c.getValues(Label.Twilio_Default_Custom_Setting).Phone_Number__c;
        String calloutURL = CALLOUT_URI + 'services/apexrest/softcallclient/';
        String statusCbURL = CALLOUT_URI + 'services/apexrest/softcallclient/';
        // Build a filter for the CallList
        
        Map<String, String> params = new Map<String, String>();
        params.put('Url', calloutURL);
        params.put('To', toNumber);
        params.put('From', fromNumber);
        params.put('StatusCallback', statusCbURL);

        System.debug('=======TwilioSoftphoneRecordHelper.dialOutToRecordNumber========='+ params);
        try{
        	TwilioCall call = client.getAccount().getCalls().create(params);
        } catch(System.Exception ex){
   			return ;
		}
        //System.debug('=======TwilioSoftphoneRecordHelper.getDuration========='+call.getDuration());
		//System.debug('=======TwilioSoftphoneRecordHelper.getSid========='+call.getSid());

    }
}