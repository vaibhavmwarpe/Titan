/********** Created By : Suman Gupta *********
*********** Organization : Arxxus Technology Partners ***************
*********** Description : This class is used for mass Activate/Deactive the users
*********** Created Date : 21-06 -12**********
*/
public with sharing class MassActivateUsers {
    
    list<User> listUsers = new list<User>();
    public string userList{get;set;}
    public string userRoleList{get;set;}
    public string userProfileList{get;set;}
    list<Profile > li_Profile;
    list<UserRole > li_UserRoles;
    public HelperClaassMassUpdateUser helperMasactivateUsr{get;set;}
    HelperClaassMassUpdateUser obj;
    //Constructor
    public MassActivateUsers(){
        userList='All';
        userRoleList = 'All';
        userProfileList = 'All';
        li_Profile= [select id, name from Profile];
        li_UserRoles = [select id, name from UserRole];
        obj = new HelperClaassMassUpdateUser();
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
        for(Profile tempUserProfile : li_Profile){
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
    
    //Call when select the pick list value of view users
    public Pagereference viewUsersList(){
        system.debug('userList=='+userList+'userProfileList=='+userProfileList+'userRoleList'+userRoleList);
        obj = new HelperClaassMassUpdateUser();
        obj.userListHel = userList;
        obj.userRoleListHel =userRoleList;
        obj.userProfileListHelp = userProfileList;
        helperMasactivateUsr = obj;
        return null;
    }
    
}