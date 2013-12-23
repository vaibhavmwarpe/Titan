public with sharing class VWDummyCon1 {
    public DateTime nontransientTime;
    public DateTime transientTime;
    /*public DateTime nontransientTime { 
        get{        
            if(nontransientTime == null)
                nontransientTime = System.now();
            return nontransientTime;
        } 
        set; 
    }
    public Transient DateTime transientTime {        
        get{        
            if(transientTime == null)
                transientTime = System.now();
            return transientTime;
        } 
        set; }*/
    public String getNontransientTime (){
        if(nontransientTime == null)
            nontransientTime = System.now();
        return '' + nontransientTime;
    }
    
    public String getTransientTime (){
        if(transientTime == null)
            transientTime = System.now();
        return '' + transientTime;
    }
    public VWDummyCon1(){
        
    }
}