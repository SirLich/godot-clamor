@tool

extends EditorInspectorPlugin

const SoundToolbarEditorProperty = preload("uid://djnyk1wx284ur")

func _can_handle(object: Object) -> bool:
	return true

func _parse_property(object: Object, type: Variant.Type, name: String, hint_type: PropertyHint, hint_string: String, usage_flags: int, wide: bool) -> bool:		
	if name == "clamor_toolbar_section":
		var control = SoundToolbarEditorProperty.new()
		add_property_editor(name, control)
		return true

	return false
