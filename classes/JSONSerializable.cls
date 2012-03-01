public interface JSONSerializable {
	//method for serialization, returns JSON string
	String serialize(); 
	//method for deserialization, JSON string into Apex object
	void deserialize(String jsonString);
}