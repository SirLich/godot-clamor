extends EditorInspectorPlugin

## Get the script class name from an object
## Returns the class_name defined in the script, or empty string if none
func _get_script_class_name(object: Object) -> String:
	var script: Script = object.get_script()
	if not script:
		return ""

	# Get the global class name if defined
	var global_name: String = script.get_global_name()
	if not global_name.is_empty():
		return global_name

	return ""
func _can_handle(object: Object) -> bool:
	return true

func _parse_property(object: Object, type: Variant.Type, name: String, hint_type: PropertyHint, hint_string: String, usage_flags: int, wide: bool) -> bool:		
	if hint_string == "SoundReference":
		var control = load("uid://c1cgosdafqfmy").new()
		control.library_selected.connect(func(library_id: String): object[name].set("library_id", library_id))
		control.sound_selected.connect(func(sound_id: String): object[name].set("sound_id", sound_id))
		#control.setup(object.get(name))
		add_property_editor(name, control)
		return false

	return false
