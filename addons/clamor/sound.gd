@tool

class_name Sound extends Resource

@export var name : String

## The unique ID of the sound, generated on creation
@export var id : String = ClamorID.v4()

@export var stream : AudioStream
@export var volume_offset_db : float
@export_range(-20, 20) var volume_offset_randomization : float
@export var pitch_offset_db : float
@export_range(-5, 5) var pitch_offset_randomization : float

func _validate_property(property: Dictionary) -> void:
	if property.name == "id":
		property.usage = PROPERTY_USAGE_READ_ONLY | PROPERTY_USAGE_EDITOR
	
func get_stream() -> AudioStream:
	return stream
