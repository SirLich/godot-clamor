@tool

class_name RandomizedSound extends Sound

@export var streams : Array[AudioStream]
@export_file var filepath = ""

func _validate_property(property: Dictionary) -> void:
	print(property)
	if property.name == "stream":
		property.usage = PROPERTY_USAGE_NO_EDITOR
		
func get_stream() -> AudioStream:
	return streams.pick_random()
	
