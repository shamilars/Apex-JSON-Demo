/*
 * Handles OAuth 2.0 login to Google APIs
 */
public class GoogleLoginController {
	//URL for step 1 of the authentication
	String googleOauthUrl = 'https://accounts.google.com/o/oauth2/auth';
	//URL for step 2 of the authentication	
	String googleTokenUrl = 'https://accounts.google.com/o/oauth2/token';	
  	public  string accessToken { get; set; }
  	public  string clientID { get; set; }
	public  string clientSecret { get; set; }
  	public  string code { get; set; }
  	//SFDC record id of the Google_App__c record that stores the authentication-specific information
  	public  string recordId { get; set; }
  	//name of the Google_App__c record that stores the authentication-specific information
  	public  string appName { get; set; }
	//constructor  
  	public GoogleLoginController(){
    	if(recordId == null)
      		recordId = ApexPages.currentPage().getParameters().get('id'); 
	}
  	/**
  	*	Handles the OAuth 2.0 authentication with Google APIs
  	*/  
	public PageReference login(){
    	Google_App__c googleApp;
    	PageReference authPage;
    	//first request
    	if(ApexPages.currentPage().getParameters().containsKey('id')){
      		googleApp = [select clientID__c, clientSecret__c, Scope__c from Google_App__c where id = :recordId];
	      	String scope = '';
	      	if(googleApp.Scope__c != null && googleApp.Scope__c != ''){
	        	scope = '&scope='+googleApp.Scope__c;
	      	}
	      	String rediruri = 'https://'+ApexPages.currentPage().getHeaders().get('Host')+'/apex/GoogleLogin';
	      	System.debug('host:'+rediruri);
	      	String authuri = googleOauthUrl + '?client_id=' + googleApp.clientID__c + 
	              							'&redirect_uri=' + rediruri + scope + 
	              							'&state=' + recordID + 
	              							'&approval_prompt=force&response_type=code';
	    	authPage = new PageReference(authuri);
    	}
	    else if(ApexPages.currentPage().getParameters().containsKey('code')){	//if authiri returned back code
	      String rid = ApexPages.currentPage().getParameters().get('state');
	      googleApp = [select Name, clientID__c, Code__c, accessToken__c, clientSecret__c,Scope__c, ExpiresIn__c from Google_App__c where id = :rid];
	      googleApp.Code__c = ApexPages.currentPage().getParameters().get('code');
		  String scope = '';
	      if(googleApp.Scope__c != null && googleApp.Scope__c != ''){
	        scope = '&scope='+googleApp.Scope__c;
	      }
	      String rediruri = 'https://'+ApexPages.currentPage().getHeaders().get('Host')+'/apex/GoogleLogin';
	      String body = 'client_id=' + 	googleApp.clientID__c + 
	  									'&redirect_uri=' + rediruri + scope + 
	  									'&client_secret=' + googleApp.clientSecret__c + 
	  									'&code=' + googleApp.Code__c +
	  									'&grant_type=authorization_code';        
	      if(!Test.isRunningTest())
	      	doFinalHttpRequest(googleTokenUrl, body, googleApp);
	      recordId = rid;
	      appName = googleApp.Name;
	    }
	    return authPage;
    
  }
  /**
  *	Makes final HTTP request to get the access token
  */
  private void doFinalHttpRequest(String uri, String body, Google_App__c googleApp) {
    Http h = new Http();
    HttpRequest req = new HttpRequest();
    req.setEndpoint(uri);
    req.setMethod('POST');
    req.setBody(body);
    HttpResponse res = h.send(req);
    String resp = res.getBody();
    System.debug('FINAL RESP IS:'+resp);
    String accesstoken = '';
    Integer expiresIn;
    //response comes back as a JSON string
	JSONParser parser = JSON.createParser(resp);
	while (parser.nextToken() != null) {
		if ((parser.getCurrentToken() == JSONToken.FIELD_NAME)){
			String fieldName = parser.getText();
			parser.nextToken();
	    	if(fieldName == 'access_token') {
				accesstoken = parser.getText();
	   		}
	   		else if(fieldName == 'expires_in'){
	   			expiresIn = parser.getIntegerValue();
	   		}
		}
	}

	googleApp.AccessToken__c = accesstoken;
    googleApp.ExpiresIn__c = expiresIn;
    System.debug('Access token:'+accesstoken);
    update googleApp;
  }
}