/**
* 	Represents the event attendee object
*/	
public class GoogleEventAttendee {
	public String email {get;set;}
	public String displayName {get;set;}
	public Boolean organizer {get;set;}
	public Boolean self {get;set;}
	public Boolean resource {get;set;}
	public Boolean optional {get;set;}
	public String responseStatus {get;set;}
	public String comment {get;set;}
	public Integer additionalGuests {get;set;}
}