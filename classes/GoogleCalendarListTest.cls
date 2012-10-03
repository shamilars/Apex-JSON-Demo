@isTest
private class GoogleCalendarListTest {

    static testMethod void testGoogleCalendarList() {
    	GoogleCalendarList gCalListOne = GoogleCalendarTestUtils.createGoogleCalendarList();        
        //serialize
		String gCalListJsonInput = gCalListOne.serialize();
		//deserialize using the same jsonString
		GoogleCalendarList gCalListTwo = new GoogleCalendarList();
		gCalListTwo.deserialize(gCalListJsonInput);
		System.assertEquals(gCalListOne.kind, gCalListTwo.kind);
		System.assertEquals(gCalListOne.etag, gCalListTwo.etag);
		System.assertEquals(gCalListOne.nextPageToken, gCalListTwo.nextPageToken);
		for(Integer i=0; i<gCalListOne.items.size(); i++){
			System.assertEquals(gCalListOne.items[i].id, gCalListTwo.items[i].id);
		}
        
    }
}