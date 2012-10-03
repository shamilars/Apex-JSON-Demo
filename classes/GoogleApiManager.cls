/*
* Hanldes Google API interaction
*/
public abstract class GoogleApiManager {
	public static final String CALENDAR_URL = 'https://www.googleapis.com/calendar/v3/calendars';
	public static final String EVENT_URL = '/events';  //URL to create (POST) and read (GET) events, should be preceeded with CALENDAR_URL
	public static final String CALENADRLIST_URL = 'https://www.googleapis.com/calendar/v3/users/me/calendarList';
	public static final String AUTH_ERR = 'AUTHENTICATION ERROR. Please authenticate';
	public static final String GENERIC_ERR = 'AN ERROR HAS OCCURRED. ';
	
	public String accesstoken;
	public Boolean isApiError; //indicates if an API error has occurred, value is set in doAPICall method
	
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
		    String errorChkMsg = checkForError(result);
		    isApiError = false;
		    if(errorChkMsg != ''){
		    	result = errorChkMsg;
		    	isApiError = true;
		    }		    
		}
		else if(Test.isRunningTest()){
			isApiError = false;
		}
		else {
			result = AUTH_ERR;
			isApiError = true;
		}
			
	    return result;
	}
	
	private String checkForError(String jsonString){
		JSONParser parser = JSON.createParser(jsonString);
		Boolean isError = false;
		String result = GENERIC_ERR;
		String reason, message;
		while (parser.nextToken() != null) {
			if(parser.getCurrentToken() == JSONToken.START_OBJECT && !isError){
				parser.nextToken();
				if(parser.getText() == 'error'){ //if first element in the json string is 'error'
					isError = true;					
				}
			}			
			else if ((parser.getCurrentToken() == JSONToken.FIELD_NAME && isError)){ //if the response is truly an error
				String fieldName = parser.getText();
				parser.nextToken();
		    	if(fieldName == 'reason') {
					reason = parser.getText();
		   		}
		   		else if(fieldName == 'message'){
		   			message = parser.getText();
		   		}
			}
		}
		if(reason != null && message != null)
			result += reason + ': ' + message;
		else
			result = '';
		
		return result;	
	}
	
	//hardcoded JSON strings for testing
	public String testEventJson = '{'+
									' "kind": "calendar#event",'+
									' "etag": "SPUNBk0sndD4x2lsWFWD68ggJ8Q0tqcmt2dlhKaEdCZ1FBQUFBQUFBQT09",'+
									' "id": "6dnv54i9sv3k130brkbqemfimc",'+
									' "status": "confirmed",'+
									' "htmlLink": "https://www.google.com/calendar/event?eid=NmRudjU0aTlzdjNrMTMwYnJrYnFlbWZpbWMgZ3BsdXN1c2Vyb25lQG0",'+
									' "created": "2012-02-15T05:03:21.000Z",'+
									' "updated": "2012-02-15T05:03:21.000Z",'+
									' "summary": "My new event",'+
									' "location": "Mountain View, CA",'+
									' "creator": {'+
									'  "email": "gplususerone@gmail.com"'+
									' },'+
									' "organizer": {'+
									'  "email": "gplususerone@gmail.com"'+
									' },'+
									' "start": {'+
									'  "dateTime": "2012-02-15T21:03:21-08:00"'+
									' },'+
									' "end": {'+
									'  "dateTime": "2012-02-15T22:03:21-08:00"'+
									' },'+
									' "iCalUID": "6dnv54i9sv3k130brkbqemfimc@google.com",'+
									' "sequence": 0,'+
									' "attendees": ['+
									'  {'+
									'   "email": "testemail-1@test.com",'+
									'   "responseStatus": "needsAction"'+
									'  },'+
									'  {'+
									'   "email": "testemail-0@test.com",'+
									'   "optional": true,'+
									'   "responseStatus": "needsAction"'+
									'  }'+
									' ],'+
									' "reminders": {'+
									'  "useDefault": false,'+
									'  "overrides": ['+
									'   {'+
									'    "method": "email",'+
									'    "minutes": 1'+
									'   },'+
									'   {'+
									'    "method": "email",'+
									'    "minutes": 2'+
									'   }'+
									'  ]'+
									' }'+
									'}';
	
	 
	public String testCalendarJson = '{'+
									 '"kind": "calendar#calendar",'+
									 '"etag": "jSPUNBk0sndD4x2lsWFWD68ggJ8_27plY7T75kWzAIeBhcAIjJAN5k",'+
									 '"id": "jr07dhbnscupjck80405j4iuq8@group.calendar.google.com",'+
									 '"summary": "My hours calendar",'+
									 '"description": "Calendar to keep track of working hours",'+
									 '"location": "San Francisco",'+
									 '"timeZone": "America/Los_Angeles"'+
									'}';
									
	public String testCalendarListJson = 	'{'+
											' "kind": "calendar#calendarList",'+
											' "etag": "HC5GdknGDiyM7v9MNXjtQAF4M9k/rUdeEsQygY4G4XNRNwH7uK8llUM",'+
											' "items": ['+
											'  {'+
											'   "kind": "calendar#calendarListEntry",'+
											'   "etag": "HC5GdknGDiyM7v9MNXjtQAF4M9k/wcIGap8wbytSPhVwA2b7N_FS-6g",'+
											'   "id": "gplususerone@gmail.com",'+
											'   "summary": "gplususerone@gmail.com",'+
											'   "timeZone": "America/Los_Angeles",'+
											'   "colorId": "15",'+
											'   "selected": true,'+
											'   "accessRole": "owner",'+
											'   "defaultReminders": ['+
											'    {'+
											'     "method": "email",'+
											'     "minutes": 10'+
											'    },'+
											'    {'+
											'     "method": "popup",'+
											'     "minutes": 10'+
											'    }'+
											'   ]'+
											'  }'+
											' ]'+
											'}';
}