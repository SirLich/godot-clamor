@tool

class_name Sound extends Resource

@export var stream : AudioStream
@export var volume_offset_db : float
@export_range(-20, 20) var volume_offset_randomization : float
@export var pitch_offset_db : float
@export_range(-5, 5) var pitch_offset_randomization : float

func get_stream() -> AudioStream:
	return stream
