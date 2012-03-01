@isTest
private class GoogleCalendarTest {

    static testMethod void testGoogleCalendar() {
        GoogleCalendar gCalOne = new GoogleCalendar('My hours calendar', 'Calendar to keep track of working hours', 'San Francisco', 'America/Los_Angeles');
        //serialize
		String calendarJsonInput = gCalOne.serialize();
		//deserialize using the same jsonString
		GoogleCalendar gCalTwo = new GoogleCalendar();
		gCalTwo.deserialize(calendarJsonInput);
		System.assertEquals(gCalOne.id, gCalTwo.id);
		System.assertEquals(gCalOne.kind, gCalTwo.kind);
		System.assertEquals(gCalOne.etag, gCalTwo.etag);
		System.assertEquals(gCalOne.summary, gCalTwo.summary);
		System.assertEquals(gCalOne.description, gCalTwo.description);
		System.assertEquals(gCalOne.location, gCalTwo.location);
		System.assertEquals(gCalOne.timeZone, gCalTwo.timeZone);
    }
}