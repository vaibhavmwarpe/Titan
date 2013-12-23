/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class TestClasses {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        Account acc = new Account(Name='Test');
        insert acc;
        EntitySubscription newSub = new EntitySubscription(SubscriberId =UserInfo.getUserId(),ParentId = acc.id);
        insert newSub;
        Contact newContact = new Contact(LastName = 'Test' , AccountId = acc.id);
        insert newContact;
        EntitySubscription newSubscription = new EntitySubscription(SubscriberId =UserInfo.getUserId(),ParentId = newContact.id);
        insert newSubscription;
        Task newTask = new Task(Subject ='Test', ActivityDate = system.today() ,WhoId = newContact.id, WhatId=acc.id, Description = 'Test');
        Event newEvent = new Event(Subject ='Test',  StartDateTime= system.now() ,EndDateTime=system.now(),WhoId = newContact.id, WhatId=acc.id,Description = 'Test');
        insert newTask;
        insert newEvent;
        PostTaskOnChatter.postToChatter(newTask.id);
        system.assertEquals('Test',newTask.Subject);
        PostEventOnChatter.postToChatter(newEvent.id);
        system.assertEquals('Test',newEvent.Subject);
        system.assertEquals(newSubscription.ParentId,newContact.id);
        system.assertEquals(newSub.ParentId,acc.id);
       
    }
}