public with sharing class FoxUberController {
    
    public FoxUberController (){
        allImages = new List<String>{'https://c.ap1.content.force.com/servlet/servlet.ImageServer?id=01590000002B9jW&oid=00D90000000irPU&lastMod=1381821985000','https://ap1.salesforce.com/img/seasonLogos/2014_winter_aloha.png','https://c.ap1.content.force.com/servlet/servlet.ImageServer?id=01590000002Aq9B&oid=00D90000000irPU&lastMod=1380804123000','https://c.ap1.content.force.com/servlet/servlet.ImageServer?id=01590000001AuND&oid=00D90000000irPU&lastMod=1382154506000'};
    }

    public List<String> allImages { get; set; }

    

    public List<String> getAllTiles() {
        return new List<String> {'a','b','c','d','e','f'};
    }
    
    public List<Account> getAllAccounts() {
        return [SELECT Id, Name, NumberOfEmployees, ImageURL__c FROM Account WHERE ImageURL__c!= null];
    }

}