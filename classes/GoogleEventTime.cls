/*
*	Represents the start time, end time for timed events
*/
public class GoogleEventTime {
	//corresponding JSON fieldName is 'date', which is an Apex reserved keyword, hence renaming
	public Date gDate {get;set;}
	//reserved 'datetime' keyword renamed				
	public DateTime gDatetime {get;set;}		
	public Date timeZone {get;set;}
}