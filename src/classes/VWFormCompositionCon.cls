public with sharing class VWFormCompositionCon {

    public String selectedMealOpt { get; set; }
    public Boolean selectedGender { get; set; }
    public String selectedAge {get; set; }
    
    public List<SelectOption> getAgeRanges () {
        List<SelectOption> ageOpts = new List<SelectOption> ();
        ageOpts.add(new SelectOption('below10','Below 10 yrs'));
        ageOpts.add(new SelectOption('within10-15','10 - 15'));
        ageOpts.add(new SelectOption('within15-35','15 - 35'));
        ageOpts.add(new SelectOption('within35-60','35 - 60'));
        ageOpts.add(new SelectOption('above60','Above 60'));

        return ageOpts ;
    }
    public List<SelectOption> getAvailableMealOpts () {
        List<SelectOption> mealOpts = new List<SelectOption>();
        mealOpts.add(new SelectOption('veg','VEG'));
        mealOpts.add(new SelectOption('nonveg','NON-VEG'));
        mealOpts.add(new SelectOption('mexican','MEXICAN'));
        mealOpts.add(new SelectOption('chinese','CHINESE'));
        mealOpts.add(new SelectOption('thai','THAI'));
        
        return mealOpts ;
    }


    public Boolean showGreeting {get; set;}
    public String name {get; set;}
    public Integer age {get; set;}
    public String meal {get; set;}
    public String color {get; set;}
    
    
    public PageReference save() {
        showGreeting = true;
        return null;
    }
    
    public PageReference cancel() {
        return null;
    }


}