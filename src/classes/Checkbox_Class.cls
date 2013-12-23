public class Checkbox_Class
{
    
    public static List<UserWrapper> userwrapperList = new List<UserWrapper>();
    public static List<User> selectedUsersList = new List<User>();

    public List<UserWrapper> getUserwrapperList ()
    {
        for(User a : [  SELECT Name, Alias,UserName, UserRoleId, ProfileId, isActive, CreatedDate FROM User  ORDER BY Name limit 10])
        userwrapperList.add(new UserWrapper(a));
        return userwrapperList;
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
    
    public List<User> getSelectedUsersList() {
        if(selectedUsersList.size()>0)
        return selectedUsersList;
        else
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