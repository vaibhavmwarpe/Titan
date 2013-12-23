public with sharing class VWDummyCon {
    public Account conAccount {get;set;}
    public PageReference save() {
        return null;
    }


    public Account getAccount() {
        return conAccount ;
    }


    public String getName() {
        return null;
    }


    public String myConVar { get; set; }

    public String myConProp { 
        get{
            return myConProp;
        }
        private set;
        
    }
    public PageReference myActionMethod1() {
        if(myConProp == null || myConProp != null){
                myConProp = 'OMG it worked!! at ' + String.valueOf(System.now());
            }
        return null;
    }


    public DateTime timenow { get; set; }
    
    public VWDummyCon(){
        timenow = System.now();
        myConVar = 'Ahoy hoy !!';
       // conAccount = [SELECT id, Name FROM Account WHERE Id =: ApexPages.currentPage().getParameters().get('id')];
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Invalid Input.'));
//        ApexPages.addMessage('asdf', );
    }

    public PageReference whatisthetime() {
        timenow = System.now();
        return null;
    }

}