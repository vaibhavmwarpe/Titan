public with sharing class VWdummyExtension {
   
    public String myNonStaticVar;
    public static String myStaticVar;
    
    public String myNonStaticProp{
            get{
                return myStaticVar;
            }            
            set;}
            
    public static String myStaticProp{
           get{
                return myStaticVar;
            }            
            set;}

    // read only, write only, read-write properties
    public String readOnlyProperty{get;}
    public String writeOnlyProperty{set;}
    public String readWriteProperty{get;set;}
    public void justForFun(){
        //readOnlyProperty = String.valueOf(40);                                error as only read prop
        //System.debug('======writeOnlyProperty=======' + writeOnlyProperty);   error as only write prop
    }

    /*public String accountID{
    get{
        accountID = ApexPages.currentPage().getParameters().get('id');
        return accountID;
    }set;}*/
    
    public String accountID;
    public String getAccountID(){
        Integer abc = 0;
        for(Integer i=0; i<99; i++){
            abc = abc + i;
        }
        //accountID = ApexPages.currentPage().getParameters().get('id');
        return accountID;
    }
    public List<Contact> contactsList {
        get{
            if(contactsList == null){
                contactsList = [SELECT Id, Name, LastName, Email, MobilePhone, Account.Name, Account.Industry FROM Contact 
                                WHERE AccountId =: ApexPages.currentPage().getParameters().get('id')];
            }
            return contactsList;
        }                
        set;}
        public VWdummyExtension(ApexPages.StandardController controller) {
         accountID = String.valueOf(System.now());
    }
    
    public PageReference cancel(){
        return null;
    }
    public PageReference save(){
        return null;
        
    }
    
    public PageReference justRefresh(){
        accountID = String.valueOf(System.now());
        return null;
    }
    /*
                <apex:pageBlock title="Account details">    
            <!--apex:pageBlockTable value="{!accs}" var="tempAccount"-->
            <apex:dataTable value="{!accs}" var="tempAccount">       
            
                <apex:column id="accNumber" value="{!tempAccount.AccountNumber}" >
                </apex:column>                    
                
                <apex:column id="accName">
                    <apex:facet name="header">Account Amigos</apex:facet>
                    <apex:outputField value="{!tempAccount.Name}"/>
                </apex:column>
                
                
                <apex:column id="accIndustry">
                    <apex:facet name="header">Industry</apex:facet>
                    <apex:facet name="footer">In-du-stry</apex:facet>
                    <apex:outputField value="{!tempAccount.Industry}">
                        <apex:inlineEditSupport event="ondblclick" showOnEdit="aSaveId,aCancelId" hideOnEdit="aEditId"/>
                    </apex:outputField>
                </apex:column>              
            
            </apex:dataTable>
            <!--apex:pageBlockTable-->
            
            <apex:pageBlockButtons >
                <apex:commandButton value="Save" action="{!save}" title="aSaveTitle" id="aSaveId"/>
                <apex:commandButton value="Cancel" action="{!cancel}" title="aCancelTitle" id="aCancelId"/>                
                <apex:commandButton value="Edit" action="{!save}" title="aEditTitle" id="aEditId"/>

            </apex:pageBlockButtons>
        </apex:pageBlock>

    
    asdf
    */
    

}