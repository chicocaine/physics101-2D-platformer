class_name GUIManager extends Node

var active_gui_stack : Array[Control] = []
var gui_dict : Dictionary = {}

func _init() -> void:
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	if (!Global.gui_manager):
		Global.gui_manager = self

func unload_gui(gui_instance: Control) -> int:
	if (!is_instance_valid(gui_instance)):
		return 1
	var key : String = self.gui_dict.find_key(gui_instance)
	self.gui_dict.erase(key)
	gui_instance.queue_free()
	return 0

func load_gui(gui_name: String) -> int:
	var gui_path := "res://gui/%s.tscn" % gui_name
	var gui_resource := load(gui_path)
	if (!gui_resource):
		return 1
	var gui_instance : Control = gui_resource.instantiate()
	if (!gui_instance):
		return 1
	Global.main_manager._gui.get_child(0).add_child(gui_instance)
	self.gui_dict[gui_name] = gui_instance
	self.hide_gui(gui_instance)
	return 0

func push_active_gui(gui_key: String) -> void:
	var gui_instance : Control = gui_dict.get(gui_key)
	if (!is_instance_valid(gui_instance)):
		return
	if (!self.active_gui_stack.is_empty()):
		var curr_top_gui_instance = active_gui_stack[0]
		if (curr_top_gui_instance):
			self.hide_gui(curr_top_gui_instance)
	active_gui_stack.push_front(gui_instance)
	self.show_gui(gui_instance)

func pop_active_gui() -> void:
	var gui_instance : Control = self.active_gui_stack.pop_front()
	self.hide_gui(gui_instance)
	if (!self.active_gui_stack.is_empty()):
		var new_top_gui_instance = active_gui_stack[0]
		if (new_top_gui_instance):
			self.show_gui(new_top_gui_instance)

func clear_active_gui() -> void:
	for gui in self.active_gui_stack:
		self.hide_gui(gui)
	self.active_gui_stack.clear()

func current_top_gui_name() -> String:
	return self.gui_dict.find_key(self.active_gui_stack[0])

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
