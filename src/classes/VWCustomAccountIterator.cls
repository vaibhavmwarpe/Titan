global class VWCustomAccountIterator implements Iterator<Account>{    
    List<Account> accountsList {get;set;}
    Integer i {get;set;}
	public VWCustomAccountIterator(String queryStr){    	
        accountsList = Database.query(queryStr);
        i = 0;
        System.debug('==in VWCustomAccountIterable() constructor=====accountsList====' + accountsList);
    }
    
    public Boolean hasNext(){
    	if(i >= accountsList.size())
            return false;
		else
            return true;            
    }
    
    public Account next(){
    	if(i == 40)
            return null;
		
		i++;
        return accountsList[i-1];
    }
    
}