public with sharing class BCProductsViewCon {
    
    // Store all below things in a custom settings....
    String store_url = 'https://store-vsk88k.mybigcommerce.com/api/v2/';
    String products_url = 'https://store-vsk88k.mybigcommerce.com/api/v2/products.json';
    String api_key = '494d85ceef9acb1698b0edd37df40f9c39a87c8e';
    String api_username = 'admin';
    public String apiString {get;set;}
    public List<String> products_list{get;set;}
    public BCStore bcStore {get;set;}
    public String resourceSelected {get;set;}
    public static List<BCProduct> productsFromFuture{get;set;}
    //public static HTTPResponse responseForTestOnly;
    public static Boolean isApexTest = false;
    public static HttpResponse mockResponse;
    
    private BCStore initStore(){
        BCSimpleCredentials creds = new BCSimpleCredentials(api_username, api_key);
        BCStore bcStore = new BCStore(store_url, creds);        
        return bcStore;
    }
    
    public BCProductsViewCon(){     
    	System.debug('========in BCProductsViewCon==========BCProductsViewCon()=====');
        resourceSelected = '';
        this.bcStore = initStore();
    }    
    
    //@future(callout = TRUE)
    public static void fetchProductsFromFuture (){
        //productsFromFuture = new List<String>{'a','b','c'};
        //productsFromFuture = (new BCProductsViewCon()).getProductsList();
        System.debug('========in fetchProductsFromFuture==========BCStore=====');
        if(!isApexTest){
            productsFromFuture = (new BCProductsViewCon()).getProductsList();
        }else{
            
            HttpRequest httpReq = new HttpRequest();
            mockResponse = (new BCHTTPMockGenerator()).respond(httpReq);        
        }
            
        //responseForTestOnly = bcStore.getStoreProducts(true);
        //productsFromFuture = generateResourcesList(responseForTestOnly.getBody(), 'Product');
        
    }
    
    public static List<String> getMockResponse(){
        return new List<String>{'a','b'};
    }
    
    public static List<String> generateResourcesList(String responseJSON, String resource){ 
    	System.debug('======generateResourcesList==responseJSON===' + responseJSON );
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
    
    public List<BCProduct> getProductsList(){
        return bcStore.getStoreProducts();        
    }
    
    /*
    @future(callout = True)
    public static void getProductsList(String isCallout){
        List<String> bcStore.getStoreProducts();        
    }*/
    
    public List<String> getCustomersList(){     
        return bcStore.getStoreCustomers();
    }
    
    /*
    * Returns the list of views
    */
    public List<SelectOption> getResources() {

        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('none', '---None---'));
        options.add(new SelectOption('products', 'Products'));
        options.add(new SelectOption('customers', 'Customers'));
        
        return options;
    }
    public PageReference justRefresh(){
        return null;
    }
    
    public String createBCProduct(){
        return null;
    }
}