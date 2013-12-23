public with sharing class VWAllJScon {

    public String myname { get; set; }

    public PageReference showMyName() {
        myname  += ' Scorsese';
        return null;
    }
    
    @RemoteAction
    public static Contact searchContactRA(String contactName){
        Contact tempContact = [SELECT Id, Name, Phone, MobilePhone, Email FROM Contact WHERE LastName LIKE : contactName];
        return tempContact;
    }
    

}

/*
Code for reference::


*/