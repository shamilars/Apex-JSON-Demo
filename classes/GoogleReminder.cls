/**
*	Represents the calendar reminder
*/	
public class GoogleReminder {
	public Boolean useDefault {get;set;}
	public List<GoogleReminderOverride> overrides {	
		get {
			if(overrides == null)
				overrides = new List<GoogleReminderOverride>();
			return overrides;
		}
		set;
	}		
}