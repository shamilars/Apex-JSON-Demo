public class GoogleCalendarTestUtils {
	
	public static GoogleCalendar createGoogleCalendar() {
		GoogleCalendar gCal = new GoogleCalendar();
        gCal.id = 'id';
        gCal.kind = 'kind';
        gCal.etag = 'etag';
        gCal.summary = 'summary';
        gCal.description = 'description';
        gCal.location = 'location';
        gCal.timeZone = 'timeZone';
        gCal.summaryOverride = 'summaryOverride';
        gCal.colorId = 'colorId';
        gCal.hidden = false;
        gCal.selected = false;
        gCal.defaultReminders.add(new GoogleReminderOverride('email',1));
        gCal.defaultReminders.add(new GoogleReminderOverride('popup',2));           
        
        return gCal;   
	}
	
	public static GoogleCalendarList createGoogleCalendarList() {
		GoogleCalendarList gCalList = new GoogleCalendarList();
        gCalList.kind = 'kind';
        gCalList.etag = 'etag';
        gCalList.nextPageToken = 'nextPageToken';
        for(Integer i=0; i<2; i++){
        	GoogleCalendar gCal = new GoogleCalendar();
        	gCal.id = String.valueOf(i);
        	gCalList.items.add(gCal);
        }
        
        return gCalList;
	}
	
	public static GoogleCalendarEvent createGoogleCalendarEvent() {
		//create GoogleCalendarEvent object
		GoogleCalendarEvent gCalEvent = new GoogleCalendarEvent();
		gCalEvent.summary = 'My new event';
		gCalEvent.location = 'Mountain View, CA';
		gCalEvent.start = new GoogleEventTime();
		gCalEvent.start.gDatetime = System.now().addDays(1);
		gCalEvent.gEnd = new GoogleEventTime();
		gCalEvent.gEnd.gDatetime = System.now().addDays(1).addHours(1);
		//add reminders
		gCalEvent.reminders = new GoogleReminder();
		gCalEvent.reminders.useDefault = false;		
		gCalEvent.reminders.overrides = new List<GoogleReminderOverride>();
		for(Integer i=1; i<=2; i++){
			gCalEvent.reminders.overrides.add(new GoogleReminderOverride('email', i)); //reminder in 'i' minutes				
		}		
		//add attendees
		gCalEvent.attendees = new List<GoogleEventAttendee>();
		for(Integer i=0; i<2; i++){			
			GoogleEventAttendee gEventAttendee = new GoogleEventAttendee();
			gEventAttendee.email = 'testemail-' + i + '@test.com';
			gEventAttendee.optional = Math.mod(i,2) == 0 ? true : false;	//true for even, false for odd
			gEventAttendee.additionalGuests = i+1;	//additional guests
			gCalEvent.attendees.add(gEventAttendee);	
		}
		return gCalEvent;
	}
}