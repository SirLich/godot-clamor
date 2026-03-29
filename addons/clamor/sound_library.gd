@tool

class_name SoundLibrary extends Resource

@export var name : String
@export var bus : String
@export var sounds : Dictionary[String, Sound]

func get_sound_by_id(sound_id: String) -> Sound:
	if sounds.has(sound_id):
		return sounds.get(sound_id)
	push_error("Sound ID % doesn't exist in library %" % [sound_id, name])
	return Sound.new()
