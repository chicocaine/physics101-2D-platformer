class_name LevelManager extends Node

var _player_spawnpoint : Node2D
var _next_level : Area2D
var _key_count : int
var _key_collected_count : int

func _ready() -> void:
	Global.level_manager = self

func unload_level(level_instance: Node2D) -> int:
	if (!is_instance_valid(level_instance)):
		return 1
	level_instance.queue_free()
	
	await level_instance.tree_exited
	
	Global.current_level_2D = null
	self._player_spawnpoint = null
	self._next_level = null
	return 0

func load_level(level_name: String) -> int:
	var level_path := "res://scenes/levels/%s.tscn" % level_name
	var level_resource := load(level_path)
	if (!level_resource):
		return 1
	var level_instance = level_resource.instantiate()
	if (!level_instance):
		return 1
	Global.main_manager._main2D.add_child(level_instance)
	Global.current_level_2D = level_instance
	_init_next_level()
	_init_player_spawnpoint()
	_count_level_keys()
	_reset_collected_count()
	
	print("Key count: ", _key_count)
	print("Keys collected: ", _key_collected_count)
	return 0

func switch_level(level_name: String) -> int:
	if (Global.current_level_2D):
		remove_player()
		unload_level(Global.current_level_2D)
	load_level(level_name)
	spawn_player()
	return 0

func spawn_player() -> int:
	var level = Global.current_level_2D
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
	var level = Global.current_level_2D
	if (!level or !level.has_node("Player")):
		return 1
	level.remove_child(Global.player)
	return 0

func _init_player_spawnpoint() -> int:
	var level = Global.current_level_2D
	if (!level):
		return 1
	var player_spawnpoint : Node2D = level.get_node("PlayerSpawnpoint")
	if (!player_spawnpoint):
		return 1
	self._player_spawnpoint = player_spawnpoint
	return 0

func _init_next_level() -> int:
	var level = Global.current_level_2D
	if (!level):
		return 1
	var next_level : Area2D = level.get_node("NextLevel")
	if (!next_level):
		return 1
	self._next_level = next_level
	return 0

func _count_level_keys() -> int:
	var level = Global.current_level_2D
	if (!level):
		return 1
	var count : int = 0
	for node in level.get_node("Keys").get_children():
		if node.is_in_group("Keys"):
			count += 1
	self._key_count = count
	return 0

func _add_collected_count() -> void:
	self._key_collected_count += 1
	
func _sub_collected_count() -> void:
	self._key_collected_count -= 1

func _reset_collected_count() -> void:
	self._key_collected_count = 0
