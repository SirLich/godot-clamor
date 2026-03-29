extends EditorProperty

signal library_selected(text: String)
signal sound_selected(text: String)

var control : Control

func get_library_names():
	return ClamorSettings.get_settings().sound_libraries.map(func(library : SoundLibrary): return library.name) 
	
func get_sound_names():
	var current_library = ClamorSettings.get_settings().get_library_by_name(get_library_id())
	var sound_options = []

	if current_library:
		sound_options = current_library.sounds.keys()
	print("Sound options: ")
	print(sound_options)
	return sound_options

func configure_library_options(button: OptionButton):
	button.add_item("None")
	for library_name in get_library_names():
		button.add_item(library_name)

func configure_sound_options(button: OptionButton):
	button.clear()
	button.add_item("None")
	for sound_name in get_sound_names():
		print(sound_name)
		button.add_item(sound_name)

func select_item_from_text(option_button: OptionButton, item_text: String) -> void:
	for i in option_button.get_item_count():
		if option_button.get_item_text(i) == item_text:
			option_button.select(i)
			break

func get_library_id():
	return get_edited_object().get(get_edited_property()).get("library_id")

func get_sound_id():
	return get_edited_object().get(get_edited_property()).get("sound_id")
	
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
	configure_library_options(library_option)
	hbox_container.add_child(library_option)
	library_option.item_selected.connect(func(index: int): library_selected.emit(library_option.get_item_text(index)))
	select_item_from_text(library_option, get_library_id())

	var sound_option := OptionButton.new()
	configure_sound_options(sound_option)
	sound_option.item_selected.connect(func(index: int): sound_selected.emit(sound_option.get_item_text(index)))
	hbox_container.add_child(sound_option)
	
	library_option.item_selected.connect(func(index: int): configure_sound_options(sound_option))

	select_item_from_text(sound_option, get_sound_id())

	return control
	

var line_edit:LineEdit = LineEdit.new()


func _enter_tree() -> void:
	var value = get_edited_object().get(get_edited_property())
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
