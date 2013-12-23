public class StandardSetGetSelectedIssue{

    private boolean runGetter = true;
    
    private ApexPages.StandardSetController controllerSet;
    
    public List<Contact> contacts ;
    
    public StandardSetGetSelectedIssue(ApexPages.StandardSetController controller)
    {
        this.controllerSet = controller;
    }
    
    public List<Contact> getStandardSetRecords(){
    
        contacts = new List<Contact>();
        
        if(runGetter){
            for (Contact contact : (List<Contact>)controllerSet.getSelected()){
                contacts.add(contact);
            }
            runGetter=true;
        }
        
        return contacts;
    }
    
    public PageReference doNothing(){
        return null;
    }
    
    public PageReference sendToAll(){
        return null;
    }
    
    
}