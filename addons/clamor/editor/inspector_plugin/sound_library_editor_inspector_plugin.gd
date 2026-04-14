extends EditorInspectorPlugin
func _can_handle(object: Object) -> bool:
	return object is SoundLibrary

func _parse_property(object: Object, type: Variant.Type, name: String, hint_type: PropertyHint, hint_string: String, usage_flags: int, wide: bool) -> bool:		
	if name == "sound":
		print(object)
		print(type)
		print(name)
		print(hint_type)
		print(hint_string)
		print(usage_flags)

	if name == "sounds":
		var control = load("uid://5rk8t1g1mbno").new()
		add_property_editor(name, control)
		return false

	return false
