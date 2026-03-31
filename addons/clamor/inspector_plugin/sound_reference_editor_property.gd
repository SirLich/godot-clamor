extends EditorProperty

signal library_selected(name: String, id: String)
signal sound_selected(text: String)

var control : Control

func get_library_names():
	return ClamorSettings.get_settings().sound_libraries.map(func(library : SoundLibrary): return library.name) 
	
func get_sound_names():
	var current_library = ClamorSettings.get_settings().get_library_by_id(get_library_id())
	var sound_options = []

	if current_library:
		sound_options = current_library.sound_dictionary.keys()
	return sound_options

## Maps: Name -> ID
var library_names : Array[String]
var library_ids : Array[String]

func configure_library_options(button: OptionButton):
	button.add_item("None")
	for library in ClamorSettings.get_settings().sound_libraries:
		library_names.append(library.name)
		library_ids.append(library.id)
		button.add_item(library.name)

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

func get_sound_reference() -> SoundReference:
	var reference : SoundReference =  get_edited_object().get(get_edited_property())
	return reference
	
func get_library_id():
	return get_sound_reference().library_id

func get_sound_id():
	return get_sound_reference().sound_id

func play_editor_sound(stream_data : SoundReference.StreamData):
	if not stream_data.stream:
		push_warning("Stream is null!")
		return 
		
	var player = AudioStreamPlayer.new()
	player.stream = stream_data.stream
	EditorInterface.get_base_control().add_child(player)
	player.play()
	player.finished.connect(func(): player.queue_free())

func emit_library_selected(index: int) -> void:
	if index == 0:
		library_selected.emit("", "")
		return
	var lookup_index = index - 1
	library_selected.emit(library_names[lookup_index], library_ids[lookup_index])
	
func create_control():
	library_ids.clear()
	library_names.clear()
	
	var hbox_container := HBoxContainer.new()
	hbox_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	#hbox_container.clip_children = CanvasItem.CLIP_CHILDREN_AND_DRAW
	#hbox_container.clip_contents = true
	#hbox_container.add_theme_constant_override("separation", 20)
	
	var play_button = Button.new()
	play_button.icon = EditorInterface.get_base_control().get_theme_icon("Play", "EditorIcons")
	play_button.pressed.connect(func(): play_editor_sound(get_sound_reference().get_stream_data()))
	play_button.theme_type_variation = "EditorInspectorButton"
	hbox_container.add_child(play_button)
	
	var library_option := OptionButton.new()
	library_option.clip_text = true
	library_option.fit_to_longest_item = true
	library_option.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	library_option.theme_type_variation = "EditorInspectorButton"
	configure_library_options(library_option)
	hbox_container.add_child(library_option)
	library_option.item_selected.connect(emit_library_selected)
	var selected_index = library_ids.find(get_library_id()) + 1
	print(get_library_id())
	library_option.select(selected_index)

	var sound_option := OptionButton.new()
	sound_option.clip_text = true
	sound_option.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	sound_option.fit_to_longest_item = true
	sound_option.theme_type_variation = "EditorInspectorButton"

	configure_sound_options(sound_option)
	sound_option.item_selected.connect(func(index: int): sound_selected.emit(sound_option.get_item_text(index)))
	hbox_container.add_child(sound_option)
	
	library_option.item_selected.connect(func(index: int): configure_sound_options(sound_option))

	select_item_from_text(sound_option, get_sound_id())

	return hbox_container
	

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
