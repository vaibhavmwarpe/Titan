public with sharing class VWWizardCon {

    public Account account { 
        public get{
            if(account == null)
                account = new Account();    
                
            return account;
        }        
        set; }
        
    public Contact contact  { 
        public get{
            if(contact== null)
                contact= new Contact();    
             
            return contact;
        }        
        set; }
        
    public Opportunity oppty  { 
        public get{
            if(oppty == null)
                oppty = new Opportunity();   
                
            return oppty;                 
        }        
        set; }


    //----------Navigation methods------------//        
    public PageReference step1() {
        return Page.VWWizardPage1;
    }
    public PageReference step2() {
        return Page.VWWizardPage2;
    }
    public PageReference step3() {
        return Page.VWWizardPage3;
    }
    //----------Action methods---------------//   
    public PageReference save() {
        // copy contact's phone and then insert account
        account.phone = contact.phone;
        insert account;
        
        // assign contact to the account and then insert contact 
        contact.accountId = account.Id;
        insert contact;
        
        // just insert the opportunity
        oppty.accountId = account.Id;        
        insert oppty;
        
        PageReference pgRef = new ApexPages.StandardController(oppty).view();
        pgRef.setRedirect(true);
        return pgRef;
    }
    
    public PageReference cancel() {
        PageReference pgRef = new ApexPages.StandardController(oppty).view();
        pgRef.setRedirect(true);
        return pgRef;
    }
  
}