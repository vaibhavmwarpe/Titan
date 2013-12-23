public with sharing class VWDeviceDetectionCon {
    public Map<String, String> userAgent {get;set;}
    public Boolean isDevice {get;set;}
    public VWDeviceDetectionCon (){
        userAgent = ApexPages.currentPage().getHeaders();
        System.debug('=======userAgent =======' + userAgent );
        
    }
    public PageReference redirectDevice(){
        //userAgent = ApexPages.currentPage().getHeaders().get('USER-AGENT');
        userAgent = ApexPages.currentPage().getHeaders();
        System.debug('=======userAgent =======' + userAgent );
        //& some devices use custom headers for the user-agent.
        /*if (userAgent==null || userAgent.length()==0){
            userAgent = ApexPages.currentPage().getHeaders().get('HTTP_X_OPERAMINI_PHONE_UA');
        }       
        if (userAgent==null || userAgent.length()==0){
            userAgent = ApexPages.currentPage().getHeaders().get('HTTP_X_SKYFIRE_PHONE');
        }
                 
        //& replace with custom setting - using (?i) case insensitive mode.     
        String deviceReg = '(?i)(iphone|ipod|ipad|blackberry|android|palm|windows\\s+ce)';
        String desktopReg = '(?i)(windows|linux|os\\s+[x9]|solaris|bsd)';
        String botReg = '(?i)(spider|crawl|slurp|bot)';
         
        isDevice=false; Boolean isDesktop=false;Boolean isBot=false;
         
        Matcher m = Pattern.compile(deviceReg).matcher(userAgent);
        if (m.find()){
            isDevice = true;
        } else {
            //& don't compile the patterns unless required.
            m = Pattern.compile(desktopReg).matcher(userAgent);
            if (m.find()) isDesktop = true;
             
            m = Pattern.compile(botReg).matcher(userAgent);
            if (m.find()) isBot = true;
        }
        //& Default is mobile - unless a desktop or bot user-agent identified.                  
        if (!isDevice && (isDesktop || isBot)) return null; //& no redirect.                        
        return new PageReference('/apex/MobileIndex'); //& redirect.*/
        return null;
    }

}