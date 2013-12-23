/************************************************
* This class is used for calling out APEX WS on 
* a button click..
*
***********************************************/

@RestResource(urlMapping='/getGGeocode/*')
global class VWContactsMapHelper{
    
    public static final String GEOCODING_URI_BASE = 'https://maps.googleapis.com/maps/api/geocode/json?sensor=false&address=';    
    // For purposes of this demo I'll geocode only couple of addresses server-side. Real code can use the commented out value.
    public static final Integer MAX_CALLOUTS_FROM_APEX = 3; // Limits.getLimitCallouts()
    
    @HttpGet
    global static String doGet() {
        RestRequest req = RestContext.request;
        //RestResponse res = RestContext.response;
        String contactId ;//= req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
		contactId = '0039000000SDJnk';
        List<Contact> contactsList = [SELECT Id, Name, Department FROM Contact WHERE Id =: contactId LIMIT 1];
        if(contactsList != null && contactsList.size() > 0){
        	contactsList[0].Department = 'contactsDepartment';
            try{
            	update contactsList[0];
            }catch(Exception exp){
            	return 'An Error Occurred' + exp;
            }
        }
        return 'SUCCESS';
    }
    
    @HttpPost
    global static String doPost(String contactId, String contactsDepartment) {
        List<Contact> contactsList = [SELECT Id, Name, Department FROM Contact WHERE Id =: contactId LIMIT 1];
        if(contactsList != null && contactsList.size() > 0){
        	contactsList[0].Department = contactsDepartment;
            try{
            	update contactsList[0];
            }catch(Exception exp){
            	return 'An Error Occurred' + exp;
            }
        }
        return 'SUCCESS';
    }
    
    
    public static void serverSideGeocode(Set<Id> contactIdsfromtrigger){   
        Http h = new Http();  
        HttpRequest req = new HttpRequest();
        req.setMethod('GET'); 
        req.setTimeout(10000);
        System.debug('=======in  serverSideGeocode()===contactIdsfromtrigger=====' + contactIdsfromtrigger);
        List<Contact> contactsToUpdate = new List<Contact>();
       
        List<Contact> contactsFromDB = [  SELECT Id, Name, Email, Account.Name,
                                              MailingStreet, MailingCity, MailingPostalCode, MailingState, MailingCountry, 
                                              Location__Latitude__s, Location__Longitude__s FROM Contact WHERE id =: contactIdsfromtrigger];
        for(Contact c : contactsFromDB){
            if((c.Location__Latitude__s == null || c.Location__Longitude__s == null)){
                String address = c.MailingStreet != null ? c.MailingStreet + ' ' : '' +
                    c.MailingCity != null ? c.MailingCity + ' ' : '' +
                    c.MailingState != null ? c.MailingState + ' ' : '' +
                    c.MailingPostalCode != null ? c.MailingPostalCode + ' ' : '' +
                    c.MailingCountry != null ? c.MailingCountry : '';
                if(address != ''){
                    req.setEndpoint(GEOCODING_URI_BASE + EncodingUtil.urlEncode(address, 'UTF-8'));
                    try{
                        HttpResponse res = h.send(req);
                        GResponse gr = (GResponse) JSON.deserialize(res.getBody(), VWGoogleGeoCodingController.GResponse.class);
                        if(gr.status == 'OK'){
                            LatLng ll = gr.results[0].geometry.location;
                            c.Location__Latitude__s = ll.lat;
                            c.Location__Longitude__s = ll.lng;
                            contactsToUpdate.add(c);
                        } else {
                            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Geocoding of "' + address + '" failed:' + gr.status));
                        }
                    }catch(Exception e){
                       //ApexPages.addMessages(e);                       
                    }
                }
                // Bail out if we've reached limit of callouts (not all contacts might have been processed).
                if(Limits.getCallouts() == MAX_CALLOUTS_FROM_APEX) {
                    break;
                }
            }
        }
        if(!contactsToUpdate.isEmpty()) {
            System.debug('=======just before updating a db====contactsToUpdate=====' + contactsToUpdate);
            Database.update(contactsToUpdate, false); // some data in Developer editions is invalid (on purpose I think).
            // If update fails because "vaibhav@gmail.com"
        }
    } 
      
    // Helper class - template into which results of lookup will be parsed. Some fields are skipped!
    // Visit https://developers.google.com/maps/documentation/geocoding/#Results if you need to create full mapping.
    public class GResponse{
        public String status;
        public GComponents[] results;
    }
    public class GComponents{
       public String formatted_address;
       public GGeometry geometry;
    }
    public class GGeometry {
        public LatLng location;
    }
    public class LatLng{
        public Double lat, lng;
    }
}