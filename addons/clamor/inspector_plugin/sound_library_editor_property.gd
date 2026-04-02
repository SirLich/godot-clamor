extends EditorProperty

var control : Control

func get_sounds() -> Array[Sound]:
	var results : Array[Sound] = []
	results.assign(get_edited_object()["sounds"])
	return results 
	
func create_control():
	var control := Control.new()
	control.set_anchors_and_offsets_preset(LayoutPreset.PRESET_FULL_RECT)
	control.custom_minimum_size = Vector2(0, 200)
	control.size_flags_vertical = Control.SIZE_EXPAND_FILL
	
	var editor = Panel.new()
	editor.set_anchors_and_offsets_preset(PRESET_FULL_RECT)
	editor.size_flags_vertical = Control.SIZE_EXPAND_FILL
	control.add_child(editor)
	
	
	var box = VBoxContainer.new()
	box.size_flags_vertical = Control.SIZE_EXPAND_FILL
	editor.add_child(box)
	box.set_anchors_and_offsets_preset(LayoutPreset.PRESET_FULL_RECT)
	
	for sound in get_sounds():
		create_sound_editor(box, sound)

	editor.set_anchor(SIDE_LEFT, -1, false, false)
	return control

func create_sound_editor(root : Control, sound: Sound):
	if sound:
		var label = Label.new()
		label.text = sound.name
		root.add_child(label)

	var use_sound = get_edited_object()["sound"]
	print(use_sound)
	var inspector = EditorInspector.instantiate_property_editor(use_sound, TYPE_OBJECT, "sound",PROPERTY_HINT_RESOURCE_TYPE, "Sound", 4102)
	inspector.set_object_and_property(use_sound, "sound")
	inspector.update_property()
	inspector.set_anchors_and_offsets_preset(LayoutPreset.PRESET_FULL_RECT)
	inspector.custom_minimum_size = Vector2(0, 20)
		
	root.add_child(inspector)
	
func _enter_tree() -> void:
	var value = get_edited_object().get(get_edited_property())
		
	control = create_control()
	add_child(control)

func _exit_tree() -> void:
	remove_child(control)
