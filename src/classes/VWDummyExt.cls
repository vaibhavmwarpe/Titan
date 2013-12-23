public with sharing class VWDummyExt {
    public Account myAccount {get; set;}
    public VWDummyExt(VWDummyCon controller) {
        this.myAccount = (Account) controller.getAccount();
        if(this.myAccount != null)
        this.myAccount.name =  this.myAccount.name + ' ' + String.valueOf(System.now());
        //update myAccount;
    }
    
    public String getsayHelloExt(){
        
        return 'Hello ' + this.myAccount.name + ' there !!';
    }

}