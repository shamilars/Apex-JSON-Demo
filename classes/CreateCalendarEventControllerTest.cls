@isTest
private class CreateCalendarEventControllerTest {

    static testMethod void testCreateCalendarEventController() {
		CreateCalendarEventController con = new CreateCalendarEventController();
    	System.assert(con.inputCalendarEvent != null);
    	con.inputCalendarEvent = GoogleCalendarTestUtils.createGoogleCalendarEvent();
    	con.createCalendarEvent();
    	System.assert(con.responseCalendarEvent != null);
    	System.assertEquals(con.isResponseReady, true);
    }
}