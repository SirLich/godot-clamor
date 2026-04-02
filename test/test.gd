extends Control

@export var click_sound : SoundReference
@export var button: Button

func _ready() -> void:
	button.pressed.connect(on_pressed)

func on_pressed():
	SoundManager.play(click_sound)
