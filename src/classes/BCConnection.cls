/**
*	A class creates connections specific to Bigcommerce stores
*/
public class BCConnection{
    String username;
	String apiKey;
	String storeUrl;
    static final String AUTH_MODE = 'Basic ';
    
    public BCConnection(String storeUrl, String username, String apiKey) {
		this.storeUrl = storeUrl;
		this.username = username;
		this.apiKey = apiKey;
	}
    
    /**
	 * Get encoded string representing HTTP Basic authorization credentials for
	 * the request.
	 */
	private String getBasicAuthHeader() {
		String token = this.username + ':' + this.apiKey;   
        String encodedToken = EncodingUtil.base64Encode(Blob.valueOf(token));
	
		return AUTH_MODE + encodedToken;
	}    
    
    public String getStoreUrl(){
    	return this.storeUrl;
    }
        
    public List<BCProduct> get(String resource){
        HttpRequest req = new HttpRequest(); 
        Http http = new Http();
        
        req.setMethod('GET');  
        req.setHeader('Authorization', this.getBasicAuthHeader());
        req.setHeader('Content-Type', 'application/json');        
        req.setEndpoint(this.storeUrl + resource + '.json');
		
        try {
            HTTPResponse res = http.send(req);  
            //return generateProductsList(res.getBody()); 
            return generateResourcesList(res.getBody(), resource);
        } catch(System.CalloutException e) {
            //Exception handling goes here....
            System.debug('e=======:'+e.getMessage ());
        }
    	return null;    
    }
    
    /*public HTTPResponse get(String resource, Boolean returnUnchangedResponse){
        HttpRequest req = new HttpRequest(); 
        Http http = new Http();
        
        req.setMethod('GET');  
        req.setHeader('Authorization', this.getBasicAuthHeader());
        req.setHeader('Content-Type', 'application/json');        
        req.setEndpoint(this.storeUrl + resource + '.json');
		
        try {
            HTTPResponse res = http.send(req);  
            
            return res;
        } catch(System.CalloutException e) {
            //Exception handling goes here....
            System.debug('e=======:'+e.getMessage ());
        }
    	return null;    
    }*/
    

    
    //public List<String> post(String resource, List<sObject> resourcesList){resourcesJSONString
    public List<BCProduct> post(String resource, String resourcesJSONString){
        HttpRequest req = new HttpRequest(); 
        Http http = new Http();
        
        req.setMethod('POST');  
        req.setHeader('Authorization', this.getBasicAuthHeader());
        req.setHeader('Content-Type', 'application/json');        
        req.setEndpoint(this.storeUrl + resource + '.json');
        /*System.debug('====BCConnection.post===resource===' + resource + '======resourcesList======' + resourcesList);
        String data = '{"name":"GenwattFabrics","price":19.99,"categories":[1],"type":"physical","weight":10, "availability":"available"}';*/
        req.setBody(resourcesJSONString);
		System.debug('==in BCConnection.post====resourcesJSONString=======' + resourcesJSONString + '=====req===' + req);
        try {
            HTTPResponse res = http.send(req);  
            //return generateProductsList(res.getBody()); 
            return generateResourcesList(res.getBody(), resource);
        } catch(System.CalloutException e) {
            //Exception handling goes here....
            System.debug('e=======:'+e.getMessage ());
        }
    	return null;    
    }
    
    public void post1(String resource, String resourcesJSONString){
    	
        HttpRequest req = new HttpRequest(); 
        Http http = new Http();
        
        req.setMethod('GET');  
        req.setHeader('Authorization', this.getBasicAuthHeader());
        req.setHeader('Content-Type', 'application/xml');        
        req.setEndpoint(this.storeUrl + resource + '.json');
		
        try {
        	System.debug('==before===in post1()===req=:' + req);
            HTTPResponse res = http.send(req);
		    System.debug('==after===in post1()===res=:' + res);
            //return generateProductsList(res.getBody()); 
            //return generateResourcesAsString(res.getBody(), resource);
        } catch(System.CalloutException e) {
            //Exception handling goes here....
            System.debug('e=post1======:'+e.getMessage ());
        }
    	//return null;    
    }
    
    public List<String> generateResourcesAsString(String responseJSON, String resource){ 
    	System.debug('===== in generateResourcesList()======responseJSON========' + responseJSON);
        JSONParser parser = JSON.createParser(responseJSON);
        List<String> resourcesList = new List<String>();
        if(resource == 'customers'){
            while (parser.nextToken() != null) {
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                    (parser.getText() == 'first_name')) {
                        
                        parser.nextToken();
                        resourcesList.add(parser.getText());       
                }
            }
                
        }else if(resource == 'products'){
        	convertToWrapper(responseJSON);
        	while (parser.nextToken() != null) {
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                    (parser.getText() == 'name')) {                        
                        parser.nextToken();
                        resourcesList.add(parser.getText());       
                }
            }        
        }
        return resourcesList;
    }
    
    public List<BCProduct> generateResourcesList(String responseJSON, String resource){ 
    	System.debug('===== in generateResourcesList()======responseJSON========' + responseJSON);
        JSONParser parser = JSON.createParser(responseJSON);
        List<String> resourcesList = new List<String>();
        if(resource == 'products'){
        	return convertToWrapper(responseJSON);        	      
        }
        return null;
    }
    
    private static List<BCProduct> convertToWrapper(String responseJSON){    	
    	List<BCProduct> tempProducts = (List<BCProduct>) JSON.deserialize(responseJSON, List<BCProduct>.class);
    	/*List<BCProduct> updatedProdList = new List<BCProduct> ();
    	for(BCProduct tempProd : updatedProdList){
    		if(!tempProd.name.startsWith('[Sample]'))
    			updatedProdList.add(tempProd);
    	}*/
    	System.debug('==convertToWrapper()===responseJSON======' + responseJSON  + '====tempProducts======' + tempProducts );    	
    	return tempProducts;
    }
    public List<String> generateProductsList(String productsJSON){       
        JSONParser parser = JSON.createParser(productsJSON);
        List<String> products_list = new List<String>();
        while (parser.nextToken() != null) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                (parser.getText() == 'first_name')) {
                    parser.nextToken();
                    products_list.add(parser.getText());       
            }
        }
        return products_list;    
    }
}