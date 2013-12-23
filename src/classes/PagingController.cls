public with sharing class PagingController {
 
    List<Userwrapper> userwrapperList{get;set;}
    List<User> selectedUsers{get;set;} 
    public string selectedUserOption{get;set;}
    public string selectedUserRole{get;set;}
    public string selectedUserProfile{get;set;}
    public Boolean status{get;set;}
    List<Profile> li_Profiles;
    List<UserRole> li_UserRoles;
    
    //Constructor
    public PagingController (){
        selectedUserOption='All';
        selectedUserRole= 'All';
        selectedUserProfile= 'All';
        li_Profiles= [select id, name from Profile];
        li_UserRoles = [select id, name from UserRole];
    }

    // return the list of user role type
    public List<SelectOption> getUsersRole() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('All','Select User Role'));
        for(UserRole tempUserRole : li_UserRoles){
            options.add(new SelectOption(tempUserRole.id,tempUserRole.name));
        }
        
        return options;
    }
     // return the list of user profiletype
    public List<SelectOption> getUsersProfile() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('All','Select User Profile'));
        for(Profile tempUserProfile : li_Profiles){
            options.add(new SelectOption(tempUserProfile.id,tempUserProfile.name));
        }
        return options;
    }
     // return the list of user type
    public List<SelectOption> getUsers() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('All','--None--'));
        options.add(new SelectOption('All Active Users','All Active Users'));
        options.add(new SelectOption('All Inactive Users','All Inactive Users'));
        return options;
    }

   /*public PageReference deactivateUsers() {
        List<User> selectedUsers = new List<User>();
        for(Userwrapper tempUser1 : getAllUsers()){
            if(tempUser1.selected == true){
                selectedUsers.add(tempUser1.user);
            }            
        }
        for(User tempUser2 : selectedUsers){
            tempUser2.IsActive = false;
        }
        update selectedUsers;
        return null;
    }

    public PageReference activateUsers() {
        List<User> selectedUsers = new List<User>();
        for(Userwrapper tempUser1 : getAllUsers()){
            if(tempUser1.selected == true){
                selectedUsers.add(tempUser1.user);
            }            
        }
        for(User tempUser2 : selectedUsers){
            tempUser2.IsActive = true;
        }
        update selectedUsers;
        return null;
    }*/
    // instantiate the StandardSetController from a query locator
    public ApexPages.StandardSetController con {
        get {
            if(con == null) {
                con = new ApexPages.StandardSetController(Database.getQueryLocator([select id, name,UserRoleId, ProfileId, IsActive, Profile.Name,UserRole.Name, Email from User]));
                // sets the number of records in each page set
                con.setPageSize(4);
            }
            return con;
        }
        set;
    }

    // returns a list of wrapper objects for the sObjects in the current page set
    public List<Userwrapper> getUserwrapperList() {
        userwrapperList = new List<Userwrapper>();
        for (User currentUser : (List<User>)con.getRecords())
            userwrapperList.add(new Userwrapper(currentUser));
 
        return userwrapperList;
    }
 
    // displays the selected items
    public PageReference process() {
        if(selectedUsers ==null){
            selectedUsers = new List<User>();
        }else{
            selectedUsers.clear();
        }
        
        for (Userwrapper uw : userwrapperList) {
            if (uw.selected){
                selectedUsers.add(uw.user);
            }
        }
        
        for (User tempUser: selectedUsers) {
            tempUser.isactive = false;
        }
        update selectedUsers;
        return null;
    }
 
    // indicates whether there are more records after the current page set.
    public Boolean hasNext {
        get {
            return con.getHasNext();
        }
        set;
    }
 
    // indicates whether there are more records before the current page set.
    public Boolean hasPrevious {
        get {
            return con.getHasPrevious();
        }
        set;
    }
 
    // returns the page number of the current page set
    public Integer pageNumber {
        get {
            return con.getPageNumber();
        }
        set;
    }
 
    // returns the first page of records
    public void first() {
        con.first();
    }
 
    // returns the last page of records
    public void last() {
        con.last();
    }
 
    // returns the previous page of records
    public void previous() {
        con.previous();
    }
 
    // returns the next page of records
    public void next() {
        con.next();
    }
 
    // returns the PageReference of the original page, if known, or the home page.
    public void cancel() {
        con.cancel();
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
 
}