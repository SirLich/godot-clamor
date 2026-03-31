@tool

class_name ClamorSettings extends Resource

static func get_settings() -> ClamorSettings:
	return Clamor.get_settings()
	
@export var pool_size : int = 50
@export var sound_libraries : Array[SoundLibrary]
	
func get_library_by_id(id : String) -> SoundLibrary:
	for library in sound_libraries:
		if library.id == id:
			return library
	return null
