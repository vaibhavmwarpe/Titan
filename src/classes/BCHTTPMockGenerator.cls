@isTest
global class BCHTTPMockGenerator implements HttpCalloutMock {
    global HttpResponse respond(HttpRequest httpReq){
    	HttpResponse httpRes = new HttpResponse();
        
        if(httpReq.getHeader('Method').equalsIgnoreCase('GET')){               
                
        }
        
        httpRes.setBody('BigHello From BigCommerce');
        httpRes.setStatusCode(200);
        httpRes.setHeader('Content-Type', 'application/json');
        return httpRes;
    }
}