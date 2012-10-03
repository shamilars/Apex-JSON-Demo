/**
*	Represents the calendar reminder's override objects
*/	
public class GoogleReminderOverride {
	public String method {get;set;}
	public Integer minutes {get;set;}
	public GoogleReminderOverride() {}
	public GoogleReminderOverride(String method, Integer minutes) {
			this.method = method;
			this.minutes = minutes;
		}
	
}