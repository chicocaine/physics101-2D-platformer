class_name LevelManager extends Node

func _ready() -> void:
	Global.level_manager = self

func unload_level(level_instance: Control) -> int:
	if (!is_instance_valid(level_instance)):
		return 1
	level_instance.queue_free()
	return 0

func load_level(level_name: String) -> int:
	var level_path := "res://levels/%s.tscn" % level_name
	var level_resource := load(level_path)
	if (!level_resource):
		return 1
	var level_instance = level_resource.instantiate()
	if (!level_instance):
		return 1
	Global.main_manager._main2D.add_child(level_instance)
	return 0
