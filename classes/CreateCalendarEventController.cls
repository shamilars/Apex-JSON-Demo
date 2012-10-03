/**
* Controller for the CreateCalendarEvent VF page
* Creates a Google Calendar Event by making an API call go Google Calendar API and processes the response back
*/
public class CreateCalendarEventController extends GoogleApiManager{
	
	public CreateCalendarEventController(){
		List<SelectOption> tmpCalendars = calendars; //only purpose of this line is to call the calendars property and display error message when present
	}
	
	public Boolean isResponseReady {
			get {
				return responseCalendarEvent.id != null;
			}
			set;
		}	
	//calendar event object to be serialized and passed to the API
	public GoogleCalendarEvent inputCalendarEvent {
		get {
			if(inputCalendarEvent == null){
				inputCalendarEvent = new GoogleCalendarEvent();
				//pre-populate start and end time
				inputCalendarEvent.start = new GoogleEventTime();
				//start in one day
				inputCalendarEvent.start.gDatetime = System.now().addDays(1);
				inputCalendarEvent.gEnd = new GoogleEventTime();
				//end in an hour
				inputCalendarEvent.gEnd.gDatetime = System.now().addDays(1).addHours(1);
				//don't use default reminders
				inputCalendarEvent.reminders.useDefault = false;
				//instead create your own reminders		
				for(Integer i=1; i<=2; i++){
					//reminder in 'i' minutes
					inputCalendarEvent.reminders.overrides.add(new GoogleReminderOverride()); 				
				}		
				//add attendees
				for(Integer i=0; i<2; i++){			
					GoogleEventAttendee gEventAttendee = new GoogleEventAttendee();
					inputCalendarEvent.attendees.add(gEventAttendee);
				}
			}
			return inputCalendarEvent;
		}
		set;
	}
	//calendar event object to be deserialized from the API response
	public GoogleCalendarEvent responseCalendarEvent{
		get {
			if(responseCalendarEvent == null)
				responseCalendarEvent = new GoogleCalendarEvent();
			return responseCalendarEvent;
		}
		set;
	}
	
	public String selectedCalendarId { get;set; }
	
	public List<SelectOption> calendars {
		get {			
			if(calendars == null){
				//get a list of calendars
				GoogleCalendarList gCalList = getCalendarList();
				calendars  = new List<SelectOption>();
				for(GoogleCalendar gCal: gCalList.items){
					if(gCal.accessRole == 'owner') //present calendars where I'm the owner
						calendars.add(new SelectOption(gCal.id, gCal.summary));
				}
			}
			return calendars;
		}
		set;
	}
	
	private GoogleCalendarList getCalendarList() {
		String calendarListJson;
		if(!Test.isRunningTest())
			calendarListJson = doAPICall(CALENADRLIST_URL, null, 'GET');
		else{
			calendarListJson = testCalendarListJson;
			doAPICall(CALENADRLIST_URL, null, 'GET');
		}
		System.debug('calendarListJson: ' + calendarListJson);
		GoogleCalendarList gCalList = new GoogleCalendarList();
		if(isAPIError)
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, calendarListJson));
		else{
			gCalList.deserialize(calendarListJson);
		}
		System.debug('gCalList: ' + gCalList);
		return gCalList;
	}
	
	public PageReference createCalendarEvent(){
		try{
			String calendarEventJsonInput = inputCalendarEvent.serialize();	
			System.debug('calendarEventJsonInput: ' + calendarEventJsonInput);
			String calendarEventJsonOutput;
			//no callouts in test mode
			if(!Test.isRunningTest())
				calendarEventJsonOutput = doAPICall(CALENDAR_URL + '/' + selectedCalendarId + EVENT_URL, calendarEventJsonInput, 'POST');
			else{
				doAPICall(CALENDAR_URL + '/' + selectedCalendarId + EVENT_URL, calendarEventJsonInput, 'POST');
				calendarEventJsonOutput = testEventJson;
			}
			System.debug('calendarEventJsonOutput: ' + calendarEventJsonOutput);
			if(isAPIError)
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, calendarEventJsonOutput));
			else{
				responsecalendarEvent.deserialize(calendarEventJsonOutput);
			}
		}
		catch(Exception e){
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, e.getMessage()));
			System.debug(e);
		}
		
		return null;
	}
}