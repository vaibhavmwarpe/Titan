public with sharing class OpportunityCon {

    public ApexPages.StandardSetController setCon {
        get{
            if(setCon == null){
                setCon = new ApexPages.StandardSetController(Database.getQueryLocator([SELECT id, Name FROM User]));
            }
            return setCon ;
        }
        set;
    
    }
    public List<User> getAllOpportunities (){ 
       return (List<User>) setCon.getRecords();
    }  
    
}