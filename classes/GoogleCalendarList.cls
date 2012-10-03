/**
* Represents a list of calendars
*/
public class GoogleCalendarList implements JSONSerializable {
	public String kind {get;set;}
	public String etag {get;set;}
	public String nextPageToken {get;set;}
	public List<GoogleCalendar> items {
		get {
			if(items == null)
				items = new List<GoogleCalendar>();
			return items;
		}
		set;	
	}
	/*
	* Serializes the current object using System.JSON
	*/
	public String serialize(){
		return JSON.serialize(this);
	}
	/*
	* Deserializes the current object using System.JSON
	*/
	public void deserialize(String jsonString) {
		GoogleCalendarList gCalList = (GoogleCalendarList) JSON.deserialize(jsonString, GoogleCalendarList.class);
		this.kind = gCalList.kind;
		this.etag = gCalList.etag;
		this.nextPageToken = gCalList.nextPageToken;
		this.items = gCalList.items;
	}
}