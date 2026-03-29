@tool
extends EditorPlugin
class_name Clamor

static var _settings_path = "addons/clamor/settings-path"

var sound_reference_editor_inspector_plugin : EditorInspectorPlugin
		
func _enter_tree() -> void:
	sound_reference_editor_inspector_plugin = load("uid://3srcdqbyo7qi").new()
	add_inspector_plugin(sound_reference_editor_inspector_plugin)
	add_autoload_singleton("SoundManager", "sound_manager.gd")
	initialize_settings()

func _exit_tree() -> void:
	if is_instance_valid(sound_reference_editor_inspector_plugin):
		remove_inspector_plugin(sound_reference_editor_inspector_plugin)
		sound_reference_editor_inspector_plugin = null
		
	remove_autoload_singleton("SoundManager")

func initialize_settings():
	print("Initializing Clamor!")
	if !ProjectSettings.has_setting(_settings_path):
		print("Settings added.")
		ProjectSettings.set_setting(_settings_path, "")
	ProjectSettings.set_initial_value(_settings_path, "")
	ProjectSettings.add_property_info({
		"name": _settings_path,
		"type": TYPE_STRING,
		"hint": PROPERTY_HINT_FILE,
		"hint_string": "*.tres"
	})
	

	
static func get_settings() -> ClamorSettings:
	var settings_path = ProjectSettings.get_setting(_settings_path) as String
	if settings_path.is_empty():
		push_error("Settings path is empty. Assign in Project settings.")
		return ClamorSettings.new()
	
	if not FileAccess.file_exists(settings_path):
		push_error("Settings path is ill-defined.")
	
	var settings = load(settings_path)
	if settings:
		return settings
	push_error("Clamor settings couldn't be loaded")
	return ClamorSettings.new()
	
