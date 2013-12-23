global class VWAccIterable implements Iterable<Account>{
    public String queryString {get;set;}
    global VWAccIterable(String queryStr){
    	queryString = queryStr;        
    }
    global Iterator<Account> iterator(){
    	return new VWCustomAccountIterator(queryString);
    }
}