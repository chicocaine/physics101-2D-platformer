class_name LevelManager extends Node

var _player_spawnpoint : Node2D
var current_level_2D : Node2D
var current_level_2D_file_name : String

func _init() -> void:
	if (!Global.level_manager):
		Global.level_manager = self

func unload_level(level_instance: Node2D) -> int:
	if !is_instance_valid(level_instance):
		return 1
	Global.main_manager._main2D.call_deferred("remove_child", level_instance)
	level_instance.call_deferred("queue_free")
	self.current_level_2D = null
	self.current_level_2D_file_name = ""
	_player_spawnpoint = null
	return 0
	
func load_level(level_name: String) -> int:
	var level_path := "res://scenes/levels/%s.tscn" % level_name
	var level_resource := load(level_path)
	if (!level_resource):
		return 1
	var level_instance : Node2D = level_resource.instantiate()
	if (!level_instance):
		return 1
	Global.main_manager._main2D.call_deferred("add_child", level_instance)
	self.current_level_2D = level_instance
	self.current_level_2D_file_name = level_name
	_init_player_spawnpoint() 
	
	return 0

func switch_level(level_name: String) -> int:
	if (self.current_level_2D):
		remove_player()
		unload_level(self.current_level_2D)
	load_level(level_name)
	return 0

func spawn_player() -> int:
	var level = self.current_level_2D
	if (!level or !Global.player):
		return 1
	var player_spawnpoint = level.get_node("PlayerSpawnpoint")
	level.add_child(Global.player)
	level.move_child(Global.player, -1)
	if (!player_spawnpoint):
		return 1
	Global.player.global_position = player_spawnpoint.global_position
	return 0

func remove_player() -> int:
	var level = self.current_level_2D
	if (!level or !level.has_node("Player")):
		return 1
	level.remove_child(Global.player)
	return 0

func _init_player_spawnpoint() -> int:
	var level = self.current_level_2D
	if (!level):
		return 1
	var player_spawnpoint : Node2D = level.get_node("PlayerSpawnpoint")
	if (!player_spawnpoint):
		return 1
	_player_spawnpoint = player_spawnpoint
	return 0
