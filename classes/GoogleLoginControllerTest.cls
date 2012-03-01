@isTest
private class GoogleLoginControllerTest {

    static testMethod void testGoogleLoginControllerPathOne() {
    	Google_App__c gApp = createGoogleAppRecord();
    	PageReference p = Page.GoogleLogin;
    	Test.setCurrentPage(p);
    	ApexPages.currentPage().getParameters().put('id', gApp.id);
    	GoogleLoginController gLoginController = new GoogleLoginController();
    	System.assertNotEquals(gLoginController.login(),null);    	
    }
    
    static testMethod void testGoogleLoginControllerPathTwo() {
    	Google_App__c gApp = createGoogleAppRecord();
    	PageReference p = Page.GoogleLogin;
    	Test.setCurrentPage(p);
    	ApexPages.currentPage().getParameters().put('state', gApp.id);
    	ApexPages.currentPage().getParameters().put('code', 'test');
    	GoogleLoginController gLoginController = new GoogleLoginController();
    	System.assertEquals(gLoginController.login(),null);    	
    }
    
    private static Google_App__c createGoogleAppRecord(){
    	//clean Google_App__c existing
    	delete [select id from Google_App__c];
    	//create Google_App__c record
    	Google_App__c gApp = new Google_App__c();
    	gApp.AccessToken__c = 'test';
    	gApp.clientID__c = 'test';
    	gApp.clientSecret__c = 'test';
    	gApp.Scope__c = 'test';
    	gApp.Code__c = 'test';
    	gApp.expiresIn__c = 100000;
    	gApp.Name = 'test';
    	insert gApp;
    	return gApp;
    }
}