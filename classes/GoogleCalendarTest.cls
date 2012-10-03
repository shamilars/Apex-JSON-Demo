@isTest
private class GoogleCalendarTest {

    static testMethod void testGoogleCalendar() {
        GoogleCalendar gCalOne = GoogleCalendarTestUtils.createGoogleCalendar();                      
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
		System.assertEquals(gCalOne.summaryOverride, gCalTwo.summaryOverride);
		System.assertEquals(gCalOne.colorId, gCalTwo.colorId);
		System.assertEquals(gCalOne.hidden, gCalTwo.hidden);
		System.assertEquals(gCalOne.selected, gCalTwo.selected);
		for(Integer i=0; i<gCalOne.defaultReminders.size(); i++){
			System.assertEquals(gCalOne.defaultReminders[i].method, gCalTwo.defaultReminders[i].method);
			System.assertEquals(gCalOne.defaultReminders[i].minutes, gCalTwo.defaultReminders[i].minutes);
		}
    }
}