public with sharing class MassActiveInactiveUsersCon {

    //PROPERTIES
    public String userrole { get; set; }
    public String userprofile { get; set; }
    public String userstatus { get; set; }
    public Boolean toggle { get; set; }
    
    //CONSTANTS
    public static List<String> AVAILUSERSTATUSES = new List<String>{'All Active Users','All Inactive Users'};
    
    //VARIAABLES
    public static List<User> usersList = new List<User>();
    public static List<UserWrapper> userwrapperList = new List<UserWrapper>();
    public static List<User> selectedUsersList = new List<User>();   
    public Integer usersCount;           
    
    // CONSTRUCTOR
    public MassActiveInactiveUsersCon (){ 
    }

    public List<User> getUsersList() {
        return usersList ;
    }
    
    public List<UserWrapper> getUserwrapperList() {
        //for(User a : [  SELECT Name, Alias,UserName, UserRoleId, ProfileId, isActive, CreatedDate FROM User  ORDER BY Name limit 10])
            //userwrapperList.add(new UserWrapper(a));
        usersCount = getUsersCount(); 
        return userwrapperList;
    }
    
    public Integer getUsersCount(){
        return userwrapperList.size(); 
    }


    public PageReference getSelected()
    {
        //System.debug('========== Inside getSelected() of Checkbox_Class =============');
        selectedUsersList.clear();
        for(UserWrapper uw: userwrapperList)
            if(uw.selected == true)
                selectedUsersList.add(uw.user);
        return null;
    }

    public List<User> getSelectedUsersList()
    {
        if(selectedUsersList.size()>0)
            return selectedUsersList;
        else
            return null;
    } 
            
    public List<SelectOption> getAllProfiles(){
        List<SelectOption> profilesList = new List<SelectOption>();

        profilesList.add(new SelectOption('0','--- ALL ---'));
        for(Profile tempProfile : [SELECT id, Name FROM Profile]){
            profilesList.add(new SelectOption(tempProfile.id, tempProfile.Name));
        }
               
        return profilesList;        
    }
    
    public List<SelectOption> getAllRoles(){
        List<SelectOption> rolesList = new List<SelectOption>();
        Integer i;
        rolesList.add(new SelectOption('0','--- ALL ---'));
        for(UserRole tempRole : [SELECT id, Name FROM UserRole]){
            rolesList.add(new SelectOption(tempRole.id, tempRole.Name ));
        }
               
        return rolesList;                      
    } 
    
    public List<SelectOption> getAllUserStatuses(){
        List<SelectOption> userStatusList = new List<SelectOption>();
        Integer i;
        userStatusList.add(new SelectOption('0','--- ALL ---'));
        userStatusList.add(new SelectOption('True','Active Users'));
        userStatusList.add(new SelectOption('False','Inactive Users'));    
               
        return userStatusList;        
    }
    
    
    public PageReference Deactivate() {        
        return null;
    }

    public PageReference Activate() {
        for( User tempUser : selectedUsersList ){
            tempUser.isActive = true;
            //update tempUser;
        }           
        return null;
    }
    
    
    public PageReference Search() {
        List<User> filteredusersList = null;
        userwrapperList.clear();
        System.debug('=============Inside Search () =============' );
        System.debug('===User Status====' + userstatus + '===User profile====' + userprofile+ '===User Role====' + userrole);
        if(userstatus=='0' && userprofile=='0' && userrole=='0')
            filteredusersList = [SELECT Name, Alias,UserName, UserRoleId, ProfileId, isActive, CreatedDate FROM User ORDER BY Name limit 10];
        else if(userstatus=='0' && userprofile=='0' && userrole!='0')     
            filteredusersList = [SELECT Name, Alias,UserName, UserRoleId, ProfileId, isActive, CreatedDate FROM User WHERE UserRoleId =: userrole ORDER BY Name limit 10];
        else if(userstatus=='0' && userprofile!='0' && userrole=='0')     
            filteredusersList = [SELECT Name, Alias,UserName, UserRoleId, ProfileId, isActive, CreatedDate FROM User WHERE ProfileId =: userprofile ORDER BY Name limit 10];
        else if(userstatus=='0' && userprofile!='0' && userrole!='0')     
            filteredusersList = [SELECT Name, Alias,UserName, UserRoleId, ProfileId, isActive, CreatedDate FROM User WHERE ProfileId =: userprofile AND UserRoleId =: userrole ORDER BY Name limit 10];
        else if(userstatus!='0' && userprofile=='0' && userrole=='0'){     System.debug('==filter===' + 100);
            filteredusersList = [SELECT Name, Alias,UserName, UserRoleId, ProfileId, isActive, CreatedDate FROM User WHERE isActive =: Boolean.valueof(userstatus) ORDER BY Name limit 10];}
        else if(userstatus!='0' && userprofile=='0' && userrole!='0')     
            filteredusersList = [SELECT Name, Alias,UserName, UserRoleId, ProfileId, isActive, CreatedDate FROM User WHERE isActive =: Boolean.valueof(userstatus) AND UserRoleId =: userrole ORDER BY Name limit 10];
        else if(userstatus!='0' && userprofile!='0' && userrole=='0')     
            filteredusersList = [SELECT Name, Alias,UserName, UserRoleId, ProfileId, isActive, CreatedDate FROM User WHERE isActive =: Boolean.valueof(userstatus) AND ProfileId =: userprofile ORDER BY Name limit 10];
        else if(userstatus!='0' && userprofile!='0' && userrole!='0')     
            filteredusersList = [SELECT Name, Alias,UserName, UserRoleId, ProfileId, isActive, CreatedDate FROM User WHERE isActive =: Boolean.valueof(userstatus) AND ProfileId =: userprofile AND UserRoleId =: userrole ORDER BY Name limit 10];
        else
            filteredusersList = [SELECT Name, Alias,UserName, UserRoleId, ProfileId, isActive, CreatedDate FROM User ORDER BY Name limit 10];
        for(User a : filteredusersList )
            userwrapperList.add(new UserWrapper(a));
        
        return null;
        
    }

    public class UserWrapper{
        public User user { get; set; }
        public Boolean selected { get; set; }
        
        public UserWrapper(User user){
           this.user = user;
           this.selected = false;       
        }    
    }  
}