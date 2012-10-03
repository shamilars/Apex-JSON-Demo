/**
* Controller for the CreateCalendar VF page
* Creates a Google Calendar by making an API call go Google Calendar API and processes the response back
*/
public class CreateCalendarController extends GoogleApiManager {	
	//calendar object to be serialized and passed to the API
	public GoogleCalendar inputCalendar {
		get {
			if(inputCalendar == null)
				inputCalendar = new GoogleCalendar();
			return inputCalendar;
		}
		set;
	}
	//calendar object to be deserialized from the API response
	public GoogleCalendar responseCalendar{
		get {
			if(responseCalendar == null)
				responseCalendar = new GoogleCalendar();
			return responseCalendar;
		}
		set;
	}
	
	public Boolean isResponseReady {
		get { return responseCalendar.id != null; }
		set;
	}
	
	public PageReference createCalendar(){
		try{
			String calendarJsonInput = inputCalendar.serialize();	
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
			System.debug('isAPIError: ' + isAPIError);
			if(isAPIError)
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, calendarJsonOutput));
			else{
				responseCalendar.deserialize(calendarJsonOutput);
			}
		}
		catch(Exception e){
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, e.getMessage()));
			System.debug(e);
		}
		return null;
	}
}