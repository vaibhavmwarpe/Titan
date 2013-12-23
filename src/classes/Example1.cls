public class Example1 {

    public PageReference retrieveSelected() {
        return null;
    }


    public String getSelectedAccounts() {
        return null;
    }

   
    CustomIterable obj;
    public list<AccountInner> accInnerObj {get;set;}
   
    public Example1 () {      
        string sQuery = 'SELECT Id, Name, NumberOfEmployees FROM Account Limit 100';
        obj = new CustomIterable(sQuery);
        obj.setPageSize = 5;
        next();
    }
   
    public Boolean hasNext {
        get {
            return obj.hasNext();
        }
        set;
    }
   
    public Boolean hasPrevious {
        get {
            return obj.hasPrevious();
        }
        set;
    }
   
    public void next() {
        accInnerObj = obj.next();
    }
   
    public void previous() {
        accInnerObj = obj.previous();
    }
}