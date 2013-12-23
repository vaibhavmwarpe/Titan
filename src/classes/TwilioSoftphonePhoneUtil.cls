/**
* @Author    : VW
* @Purpose   : This is a utility class. Used for converting phone numbers as per E.164 standards
*/

public class TwilioSoftphonePhoneUtil {
    
    /* A method to insert/ update phone & mobile number values in custom fields
     * @param       list of sObjects (from Trigger.new on contact and lead)
     * @return      void
     */
    public static void updateE164StdNumFields (List<sObject> recordsList) {         
                
        for(sObject tempRecord : recordsList) {
            if( tempRecord.get('Phone') != null && (String.valueOf(tempRecord.get('Phone'))).trim() != '' ) {
                tempRecord.put('Phone_E164__c', convertToE164Format(String.valueOf(tempRecord.get('Phone'))));                
            } else {
                tempRecord.put('Phone_E164__c', '');
            } 
            
            if( tempRecord.get('MobilePhone') != null && (String.valueOf(tempRecord.get('MobilePhone'))).trim() != '' ) {
                tempRecord.put('Mobile_E164__c', convertToE164Format(String.valueOf(tempRecord.get('MobilePhone'))));                
            } else {
                tempRecord.put('Mobile_E164__c', '');
            }

        }
    }
        
    /* A method to remove unwanted characters from phone number.
     * @param       phone number string in any format
     * @return      number string as per E.164 standards
     */
    public static String convertToE164Format ( String phoneNumber ) {
        String e164Number = phoneNumber;
        
        if(e164Number.contains('(')){
            e164Number = e164Number.replaceAll('\\(','');
        }      
        if(e164Number.contains(')')){
            e164Number = e164Number.replaceAll('\\)','');
        }
        if(e164Number.contains(' ')){
          e164Number = e164Number.replaceAll(' ','');
        }
        if(e164Number.contains('-')){
          e164Number = e164Number.replaceAll('-','');
        }

        if(e164Number.contains('+')){
            e164Number = e164Number.replaceAll('\\+','');
        }
        
        e164Number = '+' + e164Number;
        
        return e164Number;
    }
}