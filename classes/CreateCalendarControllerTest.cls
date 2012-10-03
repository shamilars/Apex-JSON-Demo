@isTest
private class CreateCalendarControllerTest {

    static testMethod void testCreateCalendarController() {
    	CreateCalendarController con = new CreateCalendarController();
    	System.assert(con.inputCalendar != null);
    	con.inputCalendar = GoogleCalendarTestUtils.createGoogleCalendar();
    	con.createCalendar();
    	System.assert(con.responseCalendar != null);
    	System.assertEquals(con.isResponseReady, true);
    }
}