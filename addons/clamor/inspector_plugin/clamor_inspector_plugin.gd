@tool
extends EditorPlugin


var my_inspector_plugin:MyInspectorPlugin

func _enter_tree() -> void:
	my_inspector_plugin = MyInspectorPlugin.new()
	add_inspector_plugin(my_inspector_plugin)



func _exit_tree() -> void:
	# Clean up nodes
	if is_instance_valid(my_inspector_plugin):
		remove_inspector_plugin(my_inspector_plugin)
		my_inspector_plugin = null
