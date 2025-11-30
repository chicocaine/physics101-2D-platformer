class_name GUIManager extends Node

func _ready() -> void:
	Global.gui_manager = self

func unload_gui(gui_instance: Control) -> int:
	if (!is_instance_valid(gui_instance)):
		return 1
	gui_instance.queue_free()
	return 0

func load_gui(gui_name: String) -> int:
	var gui_path := "res://gui/%s.tscn" % gui_name
	var gui_resource := load(gui_path)
	if (!gui_resource):
		return 1
	var gui_instance = gui_resource.instantiate()
	if (!gui_instance):
		return 1
	Global.main_manager._gui.add_child(gui_instance)
	return 0

func show_gui(gui_instance: Control) -> int:
	if (!is_instance_valid(gui_instance)):
		return 1
	if (gui_instance.is_visible_in_tree()):
		return 0
	gui_instance.visible = true 
	return 0

func hide_gui(gui_instance: Control) -> int:
	if (!is_instance_valid(gui_instance)):
		return 1
	if (!gui_instance.is_visible_in_tree()):
		return 0
	gui_instance.visible = false
	return 0
