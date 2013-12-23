/**
*	A class that mimics the actual store on Bigcommerce site
*/
public class BCStore{
	private BCConnection connection;
    
    /**
	 * A constructor that accepts any object implementing BCCredentials	 
	 * @param storeUrl
	 * @param credentials
	 */ 
    
    public BCStore(String storeUrl, BCCredentials credentials){
    	this.connection = new BCConnection(storeUrl, credentials.getUsername(), credentials.getApiKey());
    }    
    
    /**
	 * Products collection
	 */
	//public List<Product> getProducts() {
    /*public List<String> getStoreProducts() {
		List<String> products = new List<String>();
        products = this.connection.get('products');
		return products;
	}*/
	
	public List<BCProduct> getStoreProducts() {
		List<BCProduct> products = new List<BCProduct>();
        products = this.connection.get('products');
		return products;
	}
    
    /*public HTTPResponse getStoreProducts(Boolean returnUnchangedResponse) {		
        return this.connection.get('products', returnUnchangedResponse);		
	} */
    public List<String> getStoreCustomers() {
		List<String> customers = new List<String>();
        /*try{
            customers = this.connection.get('customers');
            System.debug('====in getStoreCustomers()==customers=======' + customers);
        }catch(Exception exp){
			System.debug('====exp=in getStoreCustomers========' + exp.getMessage());            	
        }*/
		return customers;
	} 
    
    public void postStoreProducts(String resource, String resourcesJSONString) {
		//List<String> products = new List<String>();
        this.connection.post1(resource, resourcesJSONString);
		//return products;
	}
}