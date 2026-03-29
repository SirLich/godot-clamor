@tool
extends EditorPlugin
class_name Clamor

static var _settings_path = "addons/clamor/settings-path"

var my_inspector_plugin:MyInspectorPlugin
		
func _enter_tree() -> void:
	my_inspector_plugin = MyInspectorPlugin.new()
	add_inspector_plugin(my_inspector_plugin)
	add_autoload_singleton("SoundManager", "sound_manager.gd")
	initialize_settings()

func _exit_tree() -> void:
	if is_instance_valid(my_inspector_plugin):
		remove_inspector_plugin(my_inspector_plugin)
		my_inspector_plugin = null
		
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
	
class MyInspectorPlugin extends EditorInspectorPlugin:
	
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
			var control = MyEditorProperty.new()
			control.library_selected.connect(func(library_id: String): object[name].set("library_id", library_id))
			control.sound_selected.connect(func(sound_id: String): object[name].set("sound_id", sound_id))
			#control.setup(object.get(name))
			add_property_editor(name, control)
			return false

		return false
		
	
class MyEditorProperty extends EditorProperty:
	signal library_selected(text: String)
	signal sound_selected(text: String)

	var control : Control
	
	func get_library_names():
		ClamorSettings.get_settings().sound_libraries.map(func(library : SoundLibrary): return library.name) 
		
	func get_sound_names():
		var current_library = ClamorSettings.get_settings().get_library_by_name(get_edited_object().get("library_id"))
		var sound_options = []

		if current_library:
			sound_options = current_library.sounds.keys()
		
	func create_control():
		var theme = EditorInterface.get_base_control().theme
		var control := Control.new()
		control.theme = theme
		
		var hbox_container := HBoxContainer.new()
		control.add_child(hbox_container)
		
		var play_button = Button.new()
		play_button.icon = EditorInterface.get_base_control().get_theme_icon("Play", "EditorIcons")
		hbox_container.add_child(play_button)
		
		var library_option := OptionButton.new()
		library_option.add_item("Bobby")
		library_option.add_item("Stinky")
		hbox_container.add_child(library_option)
		library_option.item_selected.connect(func(index: int): library_selected.emit(library_option.get_item_text(index)))

		var sound_option := OptionButton.new()
		sound_option.item_selected.connect(func(index: int): sound_selected.emit(sound_option.get_item_text(index)))
		sound_option.clear()
		hbox_container.add_child(sound_option)
		
		return control
		
	
	var line_edit:LineEdit = LineEdit.new()
	
	
	func _enter_tree() -> void:
		var value = get_edited_object().get(get_edited_property())
		print(value)
		if value == null:
			var res = SoundReference.new()
			
			get_edited_object().set(get_edited_property(), res)
			# This is the correct way:
			emit_changed(get_edited_property(), res)
			
			value = res
			
		control = create_control()
		add_child(control)
		

		
		
	func setup(value:float) -> void:
		if not is_node_ready():
			await ready
		line_edit.text = str(value)

		
	func _exit_tree() -> void:
		remove_child(control)
