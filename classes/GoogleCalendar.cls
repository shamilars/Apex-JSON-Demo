/*
*	Represents the Google Calendar 
*	Implements JSONSerializable interface (serialize() and deserialize() methods) using System.JSON
*/
public class GoogleCalendar implements JSONSerializable {
	//fields
	public String id {get;set;}
	public String kind {get;set;}
	public String etag {get;set;}
	public String summary {get;set;}
	public String description {get;set;}
	public String location {get;set;}
	public String timeZone {get;set;}
	//constructors
	public GoogleCalendar() {}
	public GoogleCalendar(String summary, String description, String location, String timeZone) {
		this.summary = summary;
		this.description = description;
		this.location = location;
		this.timeZone = timeZone;
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
		//Note: every field in the JSON calendar object must have its corresponding field in the GoogleCalendar Apex class
		//otherwise System.JSONException: Unknown field: <field_name> is raised
		GoogleCalendar gCal = (GoogleCalendar) JSON.deserialize(jsonString, GoogleCalendar.class);
		this.id = gCal.id;
		this.kind = gCal.kind;
		this.etag = gCal.etag;
		this.summary = gCal.summary;
		this.description = gCal.description;
		this.location = gCal.location;
		this.timeZone = gCal.timeZone;
	}
}