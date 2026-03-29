@tool

class_name ClamorSettings extends Resource

static func get_settings() -> ClamorSettings:
	return Clamor.get_settings()
	
@export var pool_size : int = 50
@export var sound_libraries : Array[SoundLibrary]

func get_sound_identifiers() -> Array[String]:
	var out : Array[String] = []
	for library in sound_libraries:
		for sound_name in library.sounds.keys():
			out.append(library.name + ": " + sound_name)
	out.sort()
	return out
	
func get_library_by_name(name : String) -> SoundLibrary:
	for library in sound_libraries:
		if library.name == name:
			return library
	return null
