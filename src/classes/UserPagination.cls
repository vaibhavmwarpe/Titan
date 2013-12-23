public with sharing class UserPagination {

    public UserPagination() {

    }

    private final User user;
    
    public UserPagination(ApexPages.StandardSetController controller) {
        this.user= (User)controller.getRecord();
    }
    
    public ApexPages.StandardSetController userRecords {
        get {
            if(userRecords == null) {
                userRecords = new ApexPages.StandardSetController(
                    Database.getQueryLocator([SELECT id, Name FROM User]));
            }
            return userRecords;
        }
        private set;
    }
    public List<User> getAllUsers() {
         return (List<User>) userRecords.getRecords();
    } 
}