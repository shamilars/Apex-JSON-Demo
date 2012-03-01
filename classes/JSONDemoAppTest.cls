@isTest
private class JSONDemoAppTest {
    static testMethod void testJSONDemoApp() {
    	//clean Google_App__c existing
    	delete [select id from Google_App__c];
    	//create Google_App__c record
    	Google_App__c gApp = new Google_App__c();
    	gApp.AccessToken__c = 'test';
    	gApp.clientID__c = 'test';
    	gApp.clientSecret__c = 'test';
    	gApp.Code__c = 'test';
    	gApp.expiresIn__c = 100000;
    	gApp.Name = 'test';
    	insert gApp;
    	
    	JSONDemoApp jsonDemo = new JSONDemoApp();
    	jsonDemo.runJsonScenario();
    }
}