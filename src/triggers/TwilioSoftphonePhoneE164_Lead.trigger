/**
* @Author    : VW
* @Purpose   : This trigger is used for inserting/ updating custom phone fields as per E.164 standards
*			   Calls up the helper class to perform the actions.
*/
trigger TwilioSoftphonePhoneE164_Lead on Lead (before insert, before update) {
    
    if(Trigger.isInsert || Trigger.isUpdate){
        TwilioSoftphonePhoneUtil.updateE164StdNumFields(Trigger.New);        
    }
}