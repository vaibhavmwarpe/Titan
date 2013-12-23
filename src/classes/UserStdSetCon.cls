public with sharing class UserStdSetCon {
    Public Integer noOfRecords{get; set;}
    Public Integer size{get;set;}
    public ApexPages.StandardSetController setCon {
        get{
            if(setCon == null){
                size = 5;
                setCon = new ApexPages.StandardSetController(Database.getQueryLocator([select id, name,UserRoleId, ProfileId, IsActive, Profile.Name,UserRole.Name, Email from User ]));
                setCon.setPageSize(size);
                noOfRecords = setCon.getResultSize();                
            }
            return setCon ;
        }
        set;
    
    }
    public List<User> getAllUsers (){ 
       return (List<User>) setCon.getRecords();
    } 

    public pageReference refresh() {
        setCon = null;
        getAllUsers ();
        setCon.setPageNumber(1);
        return null;
    }
    
        public Boolean hasNext {
        get {
            return setCon.getHasNext();
        }
        set;
    }
    public Boolean hasPrevious {
        get {
            return setCon.getHasPrevious();
        }
        set;
    }
 
    public Integer pageNumber {
        get {
            return setCon.getPageNumber();
        }
        set;
    }
 
    public void first() {
        setCon.first();
    }
 
    public void last() {
        setCon.last();
    }
 
    public void previous() {
        setCon.previous();
    }
 
    public void next() {
        setCon.next();
    }
    
    public class Userwrapper
    {
        public User user{get; set;}
        public Boolean selected {get; set;}
        public Userwrapper(User tempuser)
        {
            user= tempuser;
            selected = false;
        }
    }
    
    public Pagereference checkAllRecords(){
        return null;
    }
}