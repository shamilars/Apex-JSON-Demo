public class JSONDemoApp extends GoogleApiManager {	
	private static final String CALENDAR_URL = 'https://www.googleapis.com/calendar/v3/calendars';
	private static final String EVENT_URL = '/events';  //URL to create (POST) and read (GET) events, should be preceeded with CALENDAR_URL
	
	/*
	* Method goes through the following scenario:
	*	1. Create a new calendar
	*		- Serialize Apex object into JSON (System.JSON)
	*		- Pass JSON string to the API
	*		- Deserialize the returned JSON response from the API (System.JSON)
	*	2. Create a new calendar event for the calendar crated at step 1
	*		- Serialize Apex object into JSON (JSONGenerator)
	*		- Pass JSON string to the API
	*		- Deserialize the returned JSON response from the API (JSONParser)
	*/
	
	public void runJsonScenario(){
		//create a calendar by calling the API, get JSON response back
		String calendarJson = createCalendar();
		if(calendarJson != 'AUTHENTICATION ERROR'){
 			//process the returned JSON string, deserialize the calendar
			GoogleCalendar responseCalendar = new GoogleCalendar();
			responseCalendar.deserialize(calendarJson);
			//create a calendar event for the newly created calendar
			String eventJson = createCalendarEvent(responseCalendar.id);
			//process the returned JSON string, deserialize the calendar event
			GoogleCalendarEvent responseCalendarEvent = new GoogleCalendarEvent();
			responseCalendarEvent.deserialize(eventJson);
		}
	}
	
	/**
	* Creates a GoogleCalendar object, serializes it, passes it to the API and returns the JSON response
	*/
	private String createCalendar(){
		GoogleCalendar gCal = new GoogleCalendar('My hours calendar', 'Calendar to keep track of working hours', 'San Francisco', 'America/Los_Angeles');
		String calendarJsonInput = gCal.serialize();	
		System.debug('calendarJsonInput: ' + calendarJsonInput);
		String calendarJsonOutput;
		//no callouts in test mode
		if(!Test.isRunningTest())
			calendarJsonOutput = doAPICall(CALENDAR_URL, calendarJsonInput, 'POST');
		else{
			doAPICall(CALENDAR_URL, calendarJsonInput, 'POST');
			calendarJsonOutput = testCalendarJson;
		}
		System.debug('calendarJsonOutput: ' + calendarJsonOutput);

		return calendarJsonOutput;
	}
	
	/**
	* Creates a GoogleCalendarEvent object, serializes it, passes it to the API and returns the JSON response
	*/
	private String createCalendarEvent(String calendarId){
		//create GoogleCalendarEvent object
		GoogleCalendarEvent gCalEvent = new GoogleCalendarEvent();
		gCalEvent.summary = 'My new event';
		gCalEvent.location = 'Mountain View, CA';
		gCalEvent.start = new GoogleCalendarEvent.GoogleEventTime();
		//start in one day
		gCalEvent.start.gDatetime = System.now().addDays(1);
		gCalEvent.gEnd = new GoogleCalendarEvent.GoogleEventTime();
		//end in an hour
		gCalEvent.gEnd.gDatetime = System.now().addDays(1).addHours(1);
		//add reminders
		gCalEvent.reminders = new GoogleCalendarEvent.GoogleReminder();
		//don't use default reminders
		gCalEvent.reminders.useDefault = false;
		//instead create your own reminders		
		gCalEvent.reminders.overrides = new List<GoogleCalendarEvent.GoogleReminderOverride>(); 
		for(Integer i=1; i<=2; i++){
			//reminder in 'i' minutes
			gCalEvent.reminders.overrides.add(new GoogleCalendarEvent.GoogleReminderOverride('email', i)); 				
		}		
		//add attendees
		gCalEvent.attendees = new List<GoogleCalendarEvent.GoogleEventAttendee>();
		for(Integer i=0; i<2; i++){			
			GoogleCalendarEvent.GoogleEventAttendee gEventAttendee = new GoogleCalendarEvent.GoogleEventAttendee();
			gEventAttendee.email = 'testemail-' + i + '@test.com';
			//true for even, false for odd
			gEventAttendee.optional = Math.mod(i,2) == 0 ? true : false;
			//additional guests	
			gEventAttendee.additionalGuests = i+1;	
			gCalEvent.attendees.add(gEventAttendee);	
		}
		String eventJsonInput = gCalEvent.serialize();
		System.debug('eventJsonInput: ' + eventJsonInput);
		String eventJsonOutput;
		//no callouts in test mode
		if(!Test.isRunningTest())
			eventJsonOutput = doAPICall(CALENDAR_URL + '/' + calendarId + EVENT_URL, eventJsonInput, 'POST');
		else{
			doAPICall(CALENDAR_URL + '/' + calendarId + EVENT_URL, eventJsonInput, 'POST');
			eventJsonOutput = testEventJson;
		}
		System.debug('eventJsonOutput: ' + eventJsonOutput);

		return	eventJsonOutput;
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
}