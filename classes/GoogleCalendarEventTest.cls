@isTest
private class GoogleCalendarEventTest {

    static testMethod void testGoogleCalendarEvent() {
        //create GoogleCalendarEvent object
		GoogleCalendarEvent gCalEventOne = new GoogleCalendarEvent();
		gCalEventOne.summary = 'My new event';
		gCalEventOne.location = 'Mountain View, CA';
		gCalEventOne.start = new GoogleEventTime();
		gCalEventOne.start.gDatetime = System.now().addDays(1);
		gCalEventOne.gEnd = new GoogleEventTime();
		gCalEventOne.gEnd.gDatetime = System.now().addDays(1).addHours(1);
		//add reminders
		gCalEventOne.reminders = new GoogleReminder();
		gCalEventOne.reminders.useDefault = false;		
		gCalEventOne.reminders.overrides = new List<GoogleReminderOverride>();
		for(Integer i=1; i<=2; i++){
			gCalEventOne.reminders.overrides.add(new GoogleReminderOverride('email', i)); //reminder in 'i' minutes				
		}		
		//add attendees
		gCalEventOne.attendees = new List<GoogleEventAttendee>();
		for(Integer i=0; i<2; i++){			
			GoogleEventAttendee gEventAttendee = new GoogleEventAttendee();
			gEventAttendee.email = 'testemail-' + i + '@test.com';
			gEventAttendee.optional = Math.mod(i,2) == 0 ? true : false;	//true for even, false for odd
			gEventAttendee.additionalGuests = i+1;	//additional guests
			gCalEventOne.attendees.add(gEventAttendee);	
		}
		String eventJsonInput = gCalEventOne.serialize();
		//deserialize the event
		String eventJsonOutput = 	'{'+
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
									'  "dateTime": "' + gCalEventOne.start.gDatetime.format('yyyy-MM-dd\'T\'HH:mm:ssZ') +  '"'+
									' },'+
									' "end": {'+
									'  "dateTime": "'+ gCalEventOne.gEnd.gDatetime.format('yyyy-MM-dd\'T\'HH:mm:ssZ') +  '"'+
									' },'+
									' "iCalUID": "6dnv54i9sv3k130brkbqemfimc@google.com",'+
									' "sequence": 0,'+
									' "attendees": ['+
									'  {'+
									'   "email": "testemail-0@test.com",'+
									'   "optional": true,'+
									'   "responseStatus": "needsAction"'+
									'  },'+
									'  {'+
									'   "email": "testemail-1@test.com",'+
									'   "optional": false,'+
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
		
		GoogleCalendarEvent gCalEventTwo = new GoogleCalendarEvent();
		gCalEventTwo.deserialize(eventJsonOutput);
		//assertions
		System.assertEquals(gCalEventOne.summary, gCalEventTwo.summary);
		System.assertEquals(gCalEventOne.location, gCalEventTwo.location);
		System.assertEquals(gCalEventOne.start.gDatetime, gCalEventTwo.start.gDatetime);
		System.assertEquals(gCalEventOne.gEnd.gDatetime, gCalEventTwo.gEnd.gDatetime);
		System.assertEquals(gCalEventOne.reminders.useDefault, gCalEventTwo.reminders.useDefault);
		for(Integer i=0; i<gCalEventOne.reminders.overrides.size(); i++){
			System.assertEquals(gCalEventOne.reminders.overrides[i].minutes, gCalEventTwo.reminders.overrides[i].minutes);
			System.assertEquals(gCalEventOne.reminders.overrides[i].method, gCalEventTwo.reminders.overrides[i].method);
		}		
		for(Integer i=0; i<gCalEventOne.attendees.size(); i++){
			System.assertEquals(gCalEventOne.attendees[i].email, gCalEventTwo.attendees[i].email);
			System.assertEquals(gCalEventOne.attendees[i].optional, gCalEventTwo.attendees[i].optional);
		}
    }
}