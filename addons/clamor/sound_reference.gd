@tool 

class_name SoundReference extends Resource

# Human readable names
@export var library_name : String
@export var sound_name : String

# The persistant IDs
@export var library_id : String
@export var sound_id : String

class StreamData:
	var stream : AudioStream
	
func get_stream_data() -> StreamData:
	var data = StreamData.new()
	data.stream = ClamorSettings.get_settings().get_library_by_id(library_id).get_sound_by_name(sound_name).get_stream()
	return data
	
