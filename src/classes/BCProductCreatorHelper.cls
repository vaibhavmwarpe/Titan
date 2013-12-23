public class BCProductCreatorHelper{
    
    static String store_url = 'https://store-vsk88k.mybigcommerce.com/api/v2/';
    static String products_url = 'https://store-vsk88k.mybigcommerce.com/api/v2/products.json';
    static String api_key = '494d85ceef9acb1698b0edd37df40f9c39a87c8e';
    static String api_username = 'admin';    
    
    private static BCStore initStore(){
        BCSimpleCredentials creds = new BCSimpleCredentials(api_username, api_key);
        BCStore bcStore = new BCStore(store_url, creds);        
        return bcStore;
    } 
    
    public BCProductCreatorHelper(){ 
        //this.bcStore = initStore();
        initStore();
    } 
    
    @future(callout=TRUE)
    public static void doCreateBCProduct(Set<Id> productIdsList){
        List<Product2> productsList = [SELECT Id, Name, Availability__c, Category__c, Price__c, Type__c, Weight__c
                                       FROM Product2 
                                       WHERE Id IN :productIdsList];
        // below line calls out a Bigcommerce store to create products...
        BCStore bcStore = initStore();
        System.debug('=======in doCreateBCProduct===productsList===' + productsList);
        System.debug('=======in doCreateBCProduct===JSON(productsList)===' + JSON.serialize(productsList));
        
        bcStore.postStoreProducts('products', convertToJSON(productsList));       
    }
    
    @future(callout=TRUE)
    public static void doUpdateBCProduct(Set<Id> oldProductIdsList, Set<Id> newProductIdsList){
        List<Product2> productsList = [SELECT Id, Name FROM Product2 WHERE Id IN :newProductIdsList];
    }   
    
    private static String convertToJSON(List<SObject> sObjectsList){      
		 	
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        //this corresponds to an instance of the GoogleCalendarEvent class	
        gen.writeObjectField('name', sObjectsList[0].get('Name'));
        gen.writeObjectField('price', sObjectsList[0].get('Price__c'));
        gen.writeFieldName('categories');
            gen.writeStartArray();
                gen.writeNumber(Integer.valueOf(sObjectsList[0].get('Category__c')));
            gen.writeEndArray();        
        gen.writeObjectField('type', String.valueOf(sObjectsList[0].get('Type__c')).toLowerCase());
        gen.writeObjectField('weight', sObjectsList[0].get('Weight__c'));
        gen.writeObjectField('availability', String.valueOf(sObjectsList[0].get('Availability__c')).toLowerCase());        
        gen.writeEndObject();       
        System.debug('====in convertToJSON======gen.getAsString()========' + gen.getAsString());
        return gen.getAsString();
    }

    
}

/*
//===============Products create=============================   
String products_url = 'https://store-vsk88k.mybigcommerce.com/api/v2/products.json';
String api_key = '494d85ceef9acb1698b0edd37df40f9c39a87c8e';
String api_username = 'admin';
String AUTH_MODE = 'Basic ';

String token = api_username + ':' + api_key;   
String encodedToken = EncodingUtil.base64Encode(Blob.valueOf(token));
String data = '{"name":"ThePantaloons","price":19.99,"categories":[1],"type":"physical","weight":10, "availability":"available"}';
  
HttpRequest req = new HttpRequest(); 
Http http = new Http();

req.setMethod('POST');  
req.setHeader('Authorization', AUTH_MODE + encodedToken);
req.setHeader('Content-Type', 'application/json');
req.setEndpoint(products_url);
req.setBody(data);

try {
	HTTPResponse res = http.send(req);  
	System.debug('=====Response body is:::============' + res.getBody()); 
	
} catch(System.CalloutException e) {
	//Exception handling goes here....
	System.debug('e=======:'+e.getMessage ());
}

//===============Products fetch=============================   
String store_url = 'https://store-vsk88k.mybigcommerce.com/api/v2/';
String api_key = '494d85ceef9acb1698b0edd37df40f9c39a87c8e';
String api_username = 'admin';

HttpRequest req = new HttpRequest(); 
req.setMethod('GET');

String token = api_username + ':' + api_key;
String encodedToken = EncodingUtil.base64Encode(Blob.valueOf(token));

req.setHeader('Authorization', 'Basic ' + encodedToken);
req.setHeader('Content-Type', 'application/xml');
req.setEndpoint(store_url);

Http http = new Http();
try {
	//Execute web service call here		
	HTTPResponse res = http.send(req);	
	//Helpful debug messages
    System.debug('=====res.getBody()==============' + res.getBody());
	System.debug(res.toString());
	System.debug('STATUS:'+res.getStatus());
	System.debug('STATUS_CODE:'+res.getStatusCode());
	
} catch(System.CalloutException e) {
	//Exception handling goes here....
	System.debug('e=======:'+e.getMessage ());
}

	//instantiate the generator
	List<SObject> sObjectsList = [SELECT Id, Name, Availability__c, Category__c, Price__c, Type__c, Weight__c
								   FROM Product2 
								   WHERE Id = '01t90000002QEXC'];
	JSONGenerator gen = JSON.createGenerator(true);
	gen.writeStartObject();
	//this corresponds to an instance of the GoogleCalendarEvent class	
	gen.writeStringField('name', sObjectsList[0].Name);
	gen.writeStringField('price', sObjectsList[0].Price__c);
	gen.writeStringField('categories', sObjectsList[0].Category__c);
	gen.writeStringField('type', sObjectsList[0].Type__c);
	gen.writeStringField('weight', sObjectsList[0].Weight__c);
	gen.writeStringField('availability', sObjectsList[0].Availability__c);
	
	gen.writeEndObject();
	
	System.debug('=====DnG Fabrics=========' + gen.getAsString());
	return jsonString;

http://wiki.developerforce.com/page/Getting_Started_with_Apex_JSON
*/