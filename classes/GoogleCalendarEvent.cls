/*
*	Represents the google calendar event
*	Implements JSONSerializable interface (serialize() and deserialize() methods) using JSONParser and JSONGenerator classes
* 	Note: Google calendar event may have more fields than the Apex class
*/
public class GoogleCalendarEvent implements JSONSerializable {
	public String id {get;set;}
	public String htmlLink {get;set;}
	public DateTime created {get;set;}
	public String summary {get;set;}
	public String description {get;set;}
	public String location {get;set;}
	public Integer sequence {get;set;}
	public GoogleEventTime start {	
		get {	
			if(start == null)
				start = new GoogleEventTime();
			return start;
		}
		set;
	}
	public GoogleEventTime gEnd {	
		get {
			if(gEnd == null)
				gEnd = new GoogleEventTime();
			return gEnd;
		}
		set;
	}
	public List<GoogleEventAttendee> attendees {	
		get {
			if(attendees == null)
				attendees = new List<GoogleEventAttendee>();
			return attendees;
		}
		set;
	}
	public GoogleReminder reminders {	
		get {
			if(reminders == null)
				reminders = new GoogleReminder();
			return reminders;
		}
		set;
	}
	/*
		Sample GoogleCalendarEvent JSON object is the following
		(full information can be found at http://code.google.com/apis/calendar/v3/using.html#creating_events):
		{
		 "kind": "calendar#event",
		 "etag": "\"jSPUNBk0sndD4x2lsWFWD68ggJ8/Q0lpeWdQYlhKaEdCZ1FBQUFBQUFBQT09\"",
		 "id": "34ibhcldel5kg06ki09151jatc",
		 "status": "confirmed",
		 "htmlLink": "https://www.google.com/calendar/event?eid=MzRpYmhjbGRlbDVrZzA2a2kwOTE1MWphdGMgZ3BsdXN1c2Vyb25lQG0",
		 "created": "2012-02-15T02:03:33.000Z",
		 "updated": "2012-02-15T02:03:33.000Z",
		 "summary": "My new event",
		 "location": "Mountain View, CA",
		 "creator": {
		  "email": "gplususerone@gmail.com"
		 },
		 "organizer": {
		  "email": "gplususerone@gmail.com"
		 },
		 "start": {
		  "dateTime": "2012-02-15T18:03:32-08:00"
		 },
		 "end": {
		  "dateTime": "2012-02-15T19:03:32-08:00"
		 },
		 "iCalUID": "34ibhcldel5kg06ki09151jatc@google.com",
		 "sequence": 0,
		 "attendees": [
		  {
		   "email": "testemail-1@test.com",
		   "responseStatus": "needsAction"
		  },
		  {
		   "email": "testemail-0@test.com",
		   "optional": true,
		   "responseStatus": "needsAction"
		  }
		 ],
		 "reminders": {
		  "useDefault": false,
		  "overrides": [
		   {
		    "method": "email",
		    "minutes": 1
		   },
		   {
		    "method": "email",
		    "minutes": 2
		   }
		  ]
		 }
		}
	*/

	/*
	* 	Serializes the current object using JSONGenerator
	*/
	public String serialize(){
		//instantiate the generator
		JSONGenerator gen = JSON.createGenerator(true);
		//start writing object
		gen.writeStartObject();
		gen.writeStringField('summary', this.summary);
		gen.writeStringField('location', this.location);
		gen.writeFieldName('start');
        gen.writeStartObject();        
        //since 'dateTime' is an Apex keyword, we cannot use the writeObject() method (the GoogleEventTime class's field is renamed to gDateTime)
        gen.writeObjectField('dateTime', this.start.gDatetime);	
        gen.writeEndObject();
        gen.writeFieldName('end');
        gen.writeStartObject();        
        //for demo pusposes writeDateTimeField() is used instead of writeObjectField() 
        gen.writeDateTimeField('dateTime', this.gEnd.gDatetime);        	
        gen.writeEndObject();
        //serialize reminders
		gen.writeFieldName('reminders');
		//writeObject() does the trick automatically since Apex object field names are the same as JSON field names
        gen.writeObject(this.reminders);
        // serialize attendees, unlike previously don't use writeObject, rather for demo purposes, write the array manually
        /*
        Format for 'attendees'
        "attendees": [
		  {
		   "email": "attendeeOne@gmail.com",
		   "responseStatus": "needsAction",
		   "optional": false,
		   "additionalGuests": 1
		  },
		  {
		   "email": "attendeeTwo@gmail.com",
		   "responseStatus": "needsAction",
		   "optional": true,
		   "additionalGuests": 2
		  },
		  ...
		  ]
		 */
        gen.writeFieldName('attendees');
        //start of the attendees array
        gen.writeStartArray();
        //for each attendee create a JSON object
        for(GoogleEventAttendee gEventAttendee: this.attendees){
        	gen.writeStartObject();
        	gen.writeStringField('email', gEventAttendee.email);        	
        	gen.writeBooleanField('optional', gEventAttendee.optional);
        	gen.writeNumberField('additionalGuests', gEventAttendee.additionalGuests);
        	gen.writeEndObject();
        }
        //end of attendees array
        gen.writeEndArray();
        //end of the parent JSON object
		gen.writeEndObject();
		String jsonString = gen.getAsString();
		System.debug('jsonString: ' + jsonString);

		return jsonString;
	}
	
	/*
	* Deserializes the current object using JSONParser
	*/
	public void deserialize(String jsonString) {
		//instantiate the parser
		JSONParser parser = JSON.createParser(jsonString);
		//parse the entire jsonString
		while (parser.nextToken() != null) {
			//if current token is a field name
			if (parser.getCurrentToken() == JSONToken.FIELD_NAME){
				String fieldName = parser.getText();
				System.debug('fieldName: ' + fieldName);
				//move to token after the field name
				parser.nextToken(); 
				if(fieldName == 'id'){
					this.id = parser.getText();
				}
				else if(fieldName == 'htmlLink'){
					this.htmlLink = parser.getText();
				}
				else if(fieldName == 'summary'){
					this.summary = parser.getText();
				}
				else if(fieldName == 'location'){
					this.location = parser.getText();
				}
				else if(fieldName == 'sequence'){
					this.sequence = parser.getIntegerValue();
				}
				else if(fieldName == 'created'){
					this.created = parser.getDatetimeValue();
				}
				else if(fieldName == 'start'){	//start is a GoogleEventTime object
					if(parser.getCurrentToken() == JSONToken.START_OBJECT){
						while(parser.nextToken() != null){
							if(parser.getCurrentToken() == JSONToken.FIELD_NAME){
								if(parser.getText() == 'dateTime'){
									parser.nextToken();
									this.start.gDateTime = parser.getDatetimeValue();
									//break the inner while loop, otherwise the remaining top-level if-else statements won't execute
									break;  
								}
							}
						}
					}					
				}
				else if(fieldName == 'end'){	//end is is a GoogleEventTime object
					if(parser.getCurrentToken() == JSONToken.START_OBJECT){
						while(parser.nextToken() != null){
							if(parser.getCurrentToken() == JSONToken.FIELD_NAME){
								if(parser.getText() == 'dateTime'){
									parser.nextToken();
									this.gEnd.gDateTime = parser.getDatetimeValue();
									//break the inner while loop, otherwise the remaining top-level if-else statements won't execute
									break; 
								}
							}
						}
					}
				}
				else if(fieldName == 'attendees'){	//attendees is an array, parse it using readValueAs()
					if(parser.getCurrentToken() == JSONToken.START_ARRAY){
						while(parser.nextToken() != null){
							if(parser.getCurrentToken() == JSONToken.START_OBJECT){
								//read GoogleEventAttendee object
								GoogleEventAttendee gEventAttendee = (GoogleEventAttendee) parser.readValueAs(GoogleEventAttendee.class); 
								this.attendees.add(gEventAttendee); 
							}
							else if(parser.getCurrentToken() == JSONToken.END_ARRAY){
								break;	//break when attendees array has been processed
							}
						}
					}
				}
				else if(fieldName == 'reminders'){	//reminders is an object					
					if(parser.getCurrentToken() == JSONToken.START_OBJECT){
						//instead of reading manually, like for 'gEnd' and 'start' use readValueAs()
						GoogleReminder reminders = (GoogleReminder) parser.readValueAs(GoogleReminder.class); 
						this.reminders = reminders;
					}					
				}				
			} 
		}
		System.debug('event: ' + this);
	}
}