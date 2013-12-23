global with sharing class JSRemotingCon {
    
    global static Account account { get; set; }

    @RemoteAction
    global static Account getAccount(String accountName) {
        system.debug('In JSRemotingCon ');
        account = [select id, name, phone, type, numberofemployees from
             Account where name = :accountName limit 1];
        //system.debug('In JSRemotingCon Account' + account ); 
        return account;
    }
    
}