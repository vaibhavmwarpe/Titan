public with sharing class VWDummyPageCon {
    String timesNow= String.valueOf(System.now());
    Integer thecounter = 1;
    public PageReference showCounter(){
        thecounter = thecounter + 1;
        return null;
    }                   
    
    public Integer getThecounter(){
        return thecounter;
    }         
    public PageReference showCurrentTime() {
            timesNow = String.valueOf(System.now());
            return null;
    }
                        
    public String getTimesNow() {
        return timesNow ;
    }
}