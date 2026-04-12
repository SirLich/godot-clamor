@tool

extends PanelContainer

@export var stop_button: Button
@export var play_from_start_button: Button
@export var play_button: Button

@export var time_label: Label
@export var progress_slider: HSlider

var sound : Sound
var local_audio_player : AudioStreamPlayer
var is_scrubbing = false

func get_editor_icon(icon_name: String) -> Texture2D:
	return EditorInterface.get_editor_theme().get_icon(icon_name, &"EditorIcons")

func configure(sound_object : Sound) -> void:
	sound = sound_object
	
	stop_button.icon = get_editor_icon("Stop")
	play_from_start_button.icon = get_editor_icon("PlayStart")
	play_button.icon = get_editor_icon("Play")
	
	play_from_start_button.pressed.connect(play_from_start)
	play_button.pressed.connect(play_from_progress)
	stop_button.pressed.connect(stop_editor_sound)
	progress_slider.drag_ended.connect(drag_ended)
	progress_slider.drag_started.connect(drag_started)
	
func _process(delta: float) -> void:
	if is_scrubbing:
		return 
		
	if local_audio_player:
		var ratio = local_audio_player.get_playback_position() / local_audio_player.stream.get_length()
		progress_slider.value = ratio

func drag_started():
	is_scrubbing = true
	
func drag_ended(value_changed):
	is_scrubbing = false
	play_from_progress()
	
func stop_editor_sound():
	if local_audio_player:
		local_audio_player.stop()
		local_audio_player.queue_free()

func play_from_start():
	play_editor_sound(0.0)

func play_from_progress():
	create_stream()
	var progress = progress_slider.value * local_audio_player.stream.get_length()
	play_editor_sound(progress)

func create_stream():
	if not local_audio_player:
		local_audio_player = AudioStreamPlayer.new()
		add_child(local_audio_player)
	
	local_audio_player.volume_db = sound.volume_offset_db + randf_range(-sound.volume_offset_randomization, sound.volume_offset_randomization)
	local_audio_player.pitch_scale = 1 + sound.pitch_offset_db + randf_range(-sound.pitch_offset_randomization, sound.pitch_offset_randomization)
	local_audio_player.stream = sound.get_stream()

func play_editor_sound(progress):
	create_stream()
	local_audio_player.play(progress)
	
