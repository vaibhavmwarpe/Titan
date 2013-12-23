@isTest
public class BCProductsViewConTest{
    
    public static testMethod void testFutureProductsFetch(){
        // Helper class makes a call-out to Bigcommerce service
        // Callouts are not allowed from testmethods
        // So need to define a mock response class which implements HTTPCalloutMock interface
     
    	Test.setMock(System.HttpCalloutMock.class, new BCHTTPMockGenerator());
        
        PageReference pgref = Page.BCProductsViewPage;
        Test.setCurrentPage(pgref);
        
        BCProductsViewCon tempCon = new BCProductsViewCon();
        
        //HttpResponse httpRes =
        Test.startTest();
        BCProductsViewCon.fetchProductsFromFuture();
        Test.stopTest();        
        System.assertNotEquals(BCProductsViewCon.mockResponse , null);
        /*System.assert(BCProductsViewCon.productsFromFuture != null, True);
        System.assert(BCProductsViewCon.productsFromFuture.size() > 0, True );*/
        
    }

}/*-----------For reference


====================================================================================================================================================
@isTest
private class IncidentCouncilUpdaterTest {

	static testMethod void testFutureCallSuccess(){
	    Incident__c Inc1 = new Incident__c(name='Other', latitude__c='53.54489', longitude__c='-2.44467');
	    insert Inc1;
	    String StrEndPoint = 'http://www.uk-postcodes.com/latlng/' + Inc1.latitude__c + ',' + Inc1.longitude__c + '.xml';
	    IncidentCouncilUpdater.isApexTest = true;
	    Test.startTest();
	    	IncidentCouncilUpdater.updateIncident(Inc1.ID);
	    Test.stopTest();
	}
	static testMethod void testFutureCallFail(){
	    Incident__c Inc1 = new Incident__c(name='Other', latitude__c='53.54489', longitude__c='-2.44467');
	    insert Inc1;
	    String StrEndPoint = 'http://www.uk-postcodes.com/latlng/' + Inc1.latitude__c + ',' + Inc1.longitude__c + '.xml';
	    IncidentCouncilUpdater.isApexTest = false;
	    Test.startTest();
	    	IncidentCouncilUpdater.updateIncident(Inc1.ID);
	    Test.stopTest();
	}
	
	static testMethod void testgetResponseBody() {
	    Incident__c Inc1 = new Incident__c(name='Other', latitude__c='53.54489', longitude__c='-2.44467');
	    insert Inc1;
	    IncidentCouncilUpdater i= new IncidentCouncilUpdater();
	    String StrEndPoint = 'http://www.uk-postcodes.com/latlng/' + Inc1.latitude__c + ',' + Inc1.longitude__c + '.xml';
	    IncidentCouncilUpdater.isApexTest = false;
	    String path = Inc1.latitude__c + ',' + Inc1.longitude__c;
	    
	    Test.startTest();
	    	HttpResponse r = new HttpResponse();
		    HttpRequest ireq = i.createRequest('GET', '' + path);
	    	i.getResponseBody(r, ireq);
	    Test.stopTest();
	}

}
========================================================================================================================================================
Actual class:
=============

public virtual class IncidentCouncilUpdater {

   public static boolean isApexTest = false;
   private static HttpRequest req = new HttpRequest();
   private static HttpResponse res = new HttpResponse();
   private static Http http = new Http();
   private static String resBody= '';
   private static String URLprefix;
   private static String path;
   private static Integer StatusCode;

   public IncidentCouncilUpdater() {}
  	
   public virtual HttpRequest createRequest(String imethod, String ipath) {
        system.debug('Inside createRequest, method= ' + imethod + ', path=' + ipath);
        req = new HttpRequest();
        URLprefix = 'http://www.uk-postcodes.com/latlng/';
        
        req.setEndpoint(URLprefix + ipath + '.xml');
        req.setMethod('GET');
        req.setCompressed(true); // otherwise we hit a limit of 32000
        req.setTimeout(60000); // timeout in milliseconds
        return req;
    }

    protected virtual HttpResponse execute(HttpRequest ireq) {
        System.debug(LoggingLevel.FINE, '\n\nReq: \n' + ireq + '\n\n');
        HttpResponse ires = http.send(ireq);
        String iresBody = getResponseBody(ires, ireq);
        System.debug(LoggingLevel.FINE, '\n\nResp: \n' + iresBody);
        return ires;
    }
    
    protected virtual HttpResponse executeAsync(HttpRequest ireq) {
		HttpResponse r = new HttpResponse();
		return r;
	}	

    public virtual String getResponseBody(HttpResponse r, HttpRequest ireq) {
        return r.getBody(); 
    }
  
  	protected virtual String getResponseBodyAsync(HttpResponse r, HttpRequest ireq) {
		String ep = ireq.getEndpoint();
   		URLprefix = 'http://www.uk-postcodes.com/latlng/';

    	System.debug('Inside getResponseBodyAsync, URLPrefix=' + URLPrefix);
		System.debug('GET RESPONSE FOR * ' + ep + ' *\n\n');
		String body = '';

		if((ep.equals(URLprefix + '53.54489,-2.44467.xml')) )	 {
				//http://www.uk-postcodes.com/latlng/53.54489,-2.44467.xml
			body = checkIncidentQuery();
		}
			
		System.debug(LoggingLevel.INFO, '\n\nReturning body: \n' + body + '\n\n');
			return body;
	}

  //Future annotation to mark the method as async.
  @Future(callout=true)
  public static void updateIncident(ID IncidentID) {
	  Incident__c myCoordinates = [SELECT latitude__c, longitude__c
	                             FROM Incident__c
	                             WHERE Id = :IncidentID];  
	  System.debug('myCoordinates: ' + myCoordinates);  
	  
	  String myLat = myCoordinates.latitude__c;
	  String myLong = myCoordinates.longitude__c;          
	  System.debug('myLat: ' + myLat);
	  System.debug('myLong: ' + myLong);     
	  
	  IncidentCouncilUpdater i = new IncidentCouncilUpdater();
	  IncidentCouncilUpdater.path = myCoordinates.latitude__c + ',' + myCoordinates.longitude__c;
	  IncidentCouncilUpdater.req = i.createRequest('GET', '' + path);
	  system.debug('isApexTest=' + IncidentCouncilUpdater.isApexTest + ', req=' + req.toString());
	  if (!IncidentCouncilUpdater.isApexTest) {
	  	IncidentCouncilUpdater.res = i.execute(req); 
	  } else {
	  	IncidentCouncilUpdater.res = i.executeAsync(req);
	  }
	  system.debug('res=' + IncidentCouncilUpdater.res.toString());
	  IncidentCouncilUpdater.StatusCode = IncidentCouncilUpdater.res.getStatusCode();
	  system.debug('StatusCode=' + IncidentCouncilUpdater.StatusCode + ', isApexTest=' + IncidentCouncilUpdater.isApexTest);
	  if (IncidentCouncilUpdater.isApexTest) {
		IncidentCouncilUpdater.resBody = i.getResponseBodyAsync(res, req);
	  } else {
		if (StatusCode == 200)
			IncidentCouncilUpdater.resBody = i.getResponseBody(res, req);
	  }
	  Dom.Document domDoc = new Dom.Document();
        domDoc.load(IncidentCouncilUpdater.resBody);
        // print out specific elements by finding the node address 
	     dom.XmlNode location = domDoc.getRootElement()
	      .getChildElement('administrative',null)
	      .getChildElement('district',null);  
	      System.debug('location: ' + location);   
	
	      // print out specific elements by finding the node address 
	      dom.XmlNode location2 = domDoc.getRootElement();
	      System.debug('location2: ' + location2); 
	   
	      // gets the content from the XML
	      String district_title;
	      String postcode;
	      district_title = location.getChildElement('title', null).getText();
	      postcode = location2.getChildElement('postcode', null).getText();
	      System.debug('district_title: ' + district_title);  
	      System.debug('postcode: ' + postcode);
	
	      //update Incident
	      Incident__c Inc = new Incident__c(Id=IncidentID);
	      Inc.Council_Name_Text__c = district_title;
	      Inc.Incident_Postcode__c = postcode;
	      update Inc;  
          system.debug('********************Inc1 after (Callout & Update)=' + Inc);
	   }			
   
	  static String checkIncidentQuery() {
	    return '<result>' +
					'<postcode>BL5  1AL</postcode>' +
					'<geo>' +
						'<lat>53.545105</lat>' +
						'<lng>-2.44607</lng>' +
						'<easting>370538</easting>' +
						'<northing>405477</northing>' +
						'<geohash>http://geohash.org/gcw287dff7n0</geohash>' +
					'</geo>' +
					'<administrative>' +
						'<constituency>' +
							'<title>Bolton West</title>' +
							'<uri>http://statistics.data.gov.uk/id/parliamentary-constituency/053</uri>' +
							'<code>053</code>' +
						'</constituency>' +
						'<district>' +
							'<title>Bolton Borough Council</title>' +
							'<uri>http://statistics.data.gov.uk/id/local-authority/00BL</uri>' +
							'<snac>00BL</snac>' +
						'</district>' +
						'<ward>' +
							'<title>Hulton</title>' +
							'<uri>http://statistics.data.gov.uk/id/electoral-ward/00BLGK</uri>' +
							'<snac>00BLGK</snac>' +
						'</ward>' +
					'</administrative>' +
				'</result>';
	  } 
  
}
====================================================================================================================================================*/