@tool

class_name SoundLibrary extends Resource

@export var name : String
@export var id : String = ClamorID.v4()

@export var bus : String
@export var sounds : Array[Sound]
@export var sound : Sound

@export var sound_dict : Dictionary[String, Sound]

func _validate_property(property: Dictionary) -> void:
	if property.name == "id":
		property.usage = PROPERTY_USAGE_READ_ONLY | PROPERTY_USAGE_EDITOR
	
func get_sound_by_id(id : String) -> Sound:
	for sound in sounds:
		if sound.id == id:
			return sound
	push_error("Sound ID % doesn't exist in library %" % [id, name])
	return Sound.new()
	
func get_sound_by_name(sound_id: String) -> Sound:
	for sound in sounds:
		if sound.name == sound_id:
			return sound
	push_error("Sound ID % doesn't exist in library %" % [sound_id, name])
	return Sound.new()
