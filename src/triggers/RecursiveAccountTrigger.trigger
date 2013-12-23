trigger RecursiveAccountTrigger on Account (after update) {
    
    Id someAccountId = Trigger.new[0].id;
    
    if(Utility.allowExecute == true){
        Account secondAccount = [SELECT Id, Name, Phone FROM Account WHERE Id = '0019000000KJ30R' LIMIT 1];
        secondAccount.accountNumber = 'BTA-002'; 
        Utility.allowExecute = false;
        update secondAccount;
        
    }
}