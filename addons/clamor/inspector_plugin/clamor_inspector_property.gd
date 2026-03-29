extends EditorProperty

signal text_changed(text:String)

var line_edit:LineEdit = LineEdit.new()


func _enter_tree() -> void:
	line_edit.text_changed.connect(func(text:String): text_changed.emit(text))
	add_child(line_edit)

	
func setup(value:float) -> void:
	if not is_node_ready():
		await ready
	line_edit.text = str(value)

	
func _exit_tree() -> void:
	remove_child(line_edit)
