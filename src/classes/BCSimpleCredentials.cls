/**
*	A class that implements BCCredentials and provides methods definitions
*/

public class BCSimpleCredentials implements BCCredentials {
	private String username;
    private String apiKey;    
    
    public BCSimpleCredentials(){
        this('','');
    }
    
    public BCSimpleCredentials(String username, String apiKey){
    	this.username = username;
        this.apiKey = apiKey;
    }
    
    public String getUsername(){
    	return this.username;
    }
    
    public String getApiKey(){
    	return this.apiKey;
    }
}