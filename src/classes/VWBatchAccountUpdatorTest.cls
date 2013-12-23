@isTest(seeAllData = False)
public class VWBatchAccountUpdatorTest{
    public static testMethod void testAccountsBatch(){
        String queryString = 'SELECT id, Name, Description FROM Account';
        Id processId;
    	VWBatchAccountUpdator accountBatch = new VWBatchAccountUpdator(queryString);
        Test.startTest();
        try{
			processId = Database.executeBatch(accountBatch);	
            Test.stopTest();
        }catch(Exception exp){
        	System.debug('======An exception occurred in testAccountsBatch()=====' + exp);
        }
    }    
}