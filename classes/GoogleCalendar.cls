/*
*	Represents Google Calendar resource 
*	Implements JSONSerializable interface (serialize() and deserialize() methods) using System.JSON
*/
public class GoogleCalendar implements JSONSerializable {
	public String id {get;set;}
	public String kind {get;set;}
	public String etag {get;set;}
	public String summary {get;set;}
	public String description {get;set;}
	public String location {get;set;}
	public String timeZone {get;set;}
	public String summaryOverride {get;set;}
	public String colorId {get;set;}
	public Boolean hidden {get;set;}
	public Boolean selected {get;set;}
	public String accessRole {get;set;}
	public List<GoogleReminderOverride> defaultReminders { 
		get {
			if(defaultReminders == null)
				defaultReminders = new List<GoogleReminderOverride>();
			return defaultReminders;
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
		GoogleCalendar gCalendar = (GoogleCalendar) JSON.deserialize(jsonString, GoogleCalendar.class);
		this.id = gCalendar.id;
		this.kind = gCalendar.kind;
		this.etag = gCalendar.etag;
		this.summary = gCalendar.summary;
		this.description = gCalendar.description;
		this.location = gCalendar.location;
		this.timeZone = gCalendar.timeZone;
		this.summaryOverride = gCalendar.summaryOverride;
		this.colorId = gCalendar.colorId;
		this.hidden = gCalendar.hidden;
		this.selected = gCalendar.selected;
		this.accessRole = gCalendar.accessRole;
		this.defaultReminders = gCalendar.defaultReminders;
	}
}