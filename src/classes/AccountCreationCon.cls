/**
* Added new comments on 1 st Nov
*
*/
public with sharing class AccountCreationCon{ 
    public PageReference doAction() {
        Account account = new Account(Name = 'Test Accout Created by ' + Userinfo.getUserName() + ' at ' + System.now());
        insert account;
        return null;
    }



}