@tool
@icon("uid://ccsr3d0yurota")

class_name Sound extends Resource

@export var stream : AudioStream
@export_range(-40, 40, 0.01, "suffix:dB") var volume_offset_db : float = 0.0
@export_range(0, 40, 0.01, "suffix:dB") var random_volume_offset_db : float = 0.0
@export_range(-24, 24, 0.001, "suffix:Semitones") var random_pitch : float = 0.0
@export_range(0, 24, 0.01, "suffix:Semitones") var random_pitch_semitones : float = 0.0


@export_category("Preview")

## Customized harness for sound toolbar editor
@export var clamor_toolbar_section : int
	
func get_stream() -> AudioStream:
	return stream
