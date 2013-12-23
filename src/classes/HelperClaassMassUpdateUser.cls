public class HelperClaassMassUpdateUser{

    public string userListHel{get;set;}
    public string userRoleListHel{get;set;}
    public string userProfileListHelp{get;set;}
    public boolean noRecordFoundMsg{get;set;}
    public boolean selected{get;set;}
    list<User> li_Users = new list<User>();
    
    // return the list of user what we have selected in picklist value
    public list<User> getUsersList(){
       
            return (list<User>)conActive.getRecords();
       
    }
    
    // update the active users
    public Pagereference ActivateUsers(){
        try{
            update (list<User>)conActive.getRecords();
            Pagereference pg= new Pagereference('/home/home.jsp');
            return pg;
        }
        catch(Exception e){return null;}
        
    }
    
    // update the deactive users
    public Pagereference DeactivateUsers(){
        try{
            update (list<User>)conActive.getRecords();
            Pagereference pg= new Pagereference('/home/home.jsp');
            return pg;
        }
        catch(Exception e){return null;}
        
    }
    
    public ApexPages.StandardSetController conActive {
   
        get {
         system.debug('userRoleListHel=='+userRoleListHel+'userProfileListHelp =='+userProfileListHelp );
            if(conActive == null ) {
            noRecordFoundMsg=false;
            system.debug('userRoleListHel==null');
                boolean status = true;
                if(userListHel=='All Active Users'){
                    status = true;
                }
                else if(userListHel=='All Inactive Users'){
                    status = false;
                }
                if(userRoleListHel== 'All' && userProfileListHelp == 'All'){
                system.debug('inside all record');
                     conActive = new ApexPages.StandardSetController(Database.getQueryLocator([select id, name,UserRoleId, ProfileId, IsActive, Profile.Name,UserRole.Name, Email from User                                
                     where (IsActive =:status) and id != :UserInfo.getUserId() Order By Name ]));
                 }
                else if(userProfileListHelp == 'All'){
                system.debug('inside profile all record');
                     conActive = new ApexPages.StandardSetController(Database.getQueryLocator([select id, name,UserRoleId, ProfileId, IsActive, Profile.Name,UserRole.Name, Email from User                                
                     where (IsActive =:status) and id != :UserInfo.getUserId() and UserRoleId =:userRoleListHel and UserRoleId =:userRoleListHel Order By Name ]));
                }
                else if(userRoleListHel =='All'){
                system.debug('inside role all record');
                     conActive = new ApexPages.StandardSetController(Database.getQueryLocator([select id, name,UserRoleId, ProfileId, IsActive, Profile.Name,UserRole.Name, Email from User                                
                     where (IsActive =:status) and id != :UserInfo.getUserId() and ProfileId =:userProfileListHelp Order By Name ]));
                 }
                 else{
                 system.debug('inside selected record');
                     conActive = new ApexPages.StandardSetController(Database.getQueryLocator([select id, name,UserRoleId, ProfileId, IsActive, Profile.Name,UserRole.Name, Email from User                                
                     where (IsActive =:status) and id != :UserInfo.getUserId() and UserRoleId =:userRoleListHel and ProfileId =:userProfileListHelp Order By Name ]));
                 }
                // sets the number of records in each page set
                if(conActive.getRecords().size()<=0){
                    noRecordFoundMsg = true;
                }
                //This store backup of users record :If user does not perform any action then they would be rollback the records
                li_Users  = (list<user>)conActive.getRecords();
               
                conActive.setPageSize(10);
            }
            return conActive;
        }
        set;
    }
    
 // indicates whether there are more records after the current page set.
    public Boolean hasNext {
        get {
            
                return conActive.getHasNext();
            
        }
        set;
    }
 
    // indicates whether there are more records before the current page set.
    public Boolean hasPrevious {
        get {
         
                return conActive.getHasPrevious();       
        }
        set;
    }
    
    public void previous() {
            
            conActive.save();
            conActive.previous();        
    }
 
    // returns the next page of records
    public void next() {
       
            conActive.save();
            conActive.next();
        
    }
    
    // returns the page number of the current page set
    public Integer pageNumber {
        get {
           
                return conActive.getPageNumber();
           
        }
        set;
    }
 
    // returns the first page of records
    public void first() {
       
            conActive.save();
            system.debug('conActive=='+conActive.getRecords().size());
            conActive.first();
       
    }
 
    // returns the last page of records
    public void last() {
       
            conActive.save();
            system.debug('conActive=='+conActive.getRecords().size());
            conActive.last();
        
    }
}