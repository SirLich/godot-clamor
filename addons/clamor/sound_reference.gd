@tool 

class_name SoundReference extends Resource

@export var library_id : String
@export var sound_id : String

class StreamData:
	var stream : AudioStream
	
	func print():
		return "Stream: " + str(stream)
	
func get_stream_data() -> StreamData:
	## TODO: Add volume and stuff
	var data = StreamData.new()
	data.stream = ClamorSettings.get_settings().get_library_by_name(library_id).get_sound_by_id(sound_id).get_stream()
	return data
	
