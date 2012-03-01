public abstract class GoogleApiManager {
		
	public String accesstoken;
	/**
	 * Check if the user is authenticated in the app.
	 */
	public boolean isAuthenticated(){
		List<Google_App__c> googleApps = [SELECT AccessToken__c, LastModifiedDate, ExpiresIn__c FROM Google_App__c LIMIT 1];
		if(googleApps.size() == 0){
			System.debug('AUTHENTICATION FAILED. GOOGLE APP RECORD NOT FOUND');
			return false;
		}
		Google_App__c googleApp = googleApps[0];
		//authentication token lasts typically for 1 hour
		if(googleApp.AccessToken__c != null && !hasTokenExpired(googleApp.lastModifiedDate, googleApp.ExpiresIn__c)){			
			this.accesstoken = googleApp.AccessToken__c;
			return true;
		}
		else {
			return false;
		}
	}
	
	private boolean hasTokenExpired(Datetime lastmod, Decimal expiresIn) {
		if(lastmod.addSeconds(expiresIn.intValue()) >= System.now()) {
			System.debug('GOOGLE ACCESS TOKEN IS OK');
			return false;
		}
		else {
			System.debug('GOOGLE ACCESS TOKEN HAS EXPIRED');
			return true;
		}
	}
	
	public String doAPICall(String url, String data, String method){
		String result;
		if(this.isAuthenticated() && !Test.isRunningTest()){
			Http h = new Http();
		    HttpRequest req = new HttpRequest();
		    //Must-specify, otherwise  "This API does not support parsing form-encoded input" error is returned!
		    req.setHeader('Content-Type', 'application/json'); 
		    req.setEndpoint(url + '?access_token=' + this.accesstoken);
		    req.setMethod(method);
		    if(method == 'POST') {
		    	req.setBody(data);
		    }
		    HttpResponse res = h.send(req);
		    result = res.getBody();
		}
		else
			result = 'AUTHENTICATION ERROR';
			
	    return result;
	}
}