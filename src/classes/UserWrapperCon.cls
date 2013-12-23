public with sharing class UserWrapperCon {

    public string selectedUserOption{get;set;}
    public string selectedUserRole{get;set;}
    public string selectedUserProfile{get;set;}
    public Boolean status{get;set;}
    List<Profile> li_Profiles;
    List<UserRole> li_UserRoles;
    List<Userwrapper> userwrapperList{get;set;}
    
    //Constructor
    public UserWrapperCon (){
        selectedUserOption='All';
        selectedUserRole= 'All';
        selectedUserProfile= 'All';
        li_Profiles= [select id, name from Profile];
        li_UserRoles = [select id, name from UserRole];
    }

    public PageReference viewUsersList() {
        if(selectedUserOption == 'All Active Users'){
            status = true;
            //selectedUserOption = 'Active';
        }
        else{
            status = false;
            //selectedUserOption = 'Inactive';
        }
        return null;
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

    public PageReference deactivateUsers() {
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
    }


        
    public List<Userwrapper> getAllUsers (){ 
       if(userwrapperList == null){
           userwrapperList = new List<Userwrapper>();
       }
       userwrapperList.clear();
       for(User currentUser : [select id, name,UserRoleId, ProfileId, IsActive, Profile.Name,UserRole.Name, Email from User Where Isactive =: status]){
                userwrapperList.add(new Userwrapper(currentUser));
       }           
           
       return userwrapperList;
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