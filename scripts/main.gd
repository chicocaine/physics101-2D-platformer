class_name MainManager extends Node

var _player : Player
var _main2D : Node2D
var _gui : Control

var _level_manager : LevelManager
var _gui_manager : GUIManager

func _ready() -> void:	
	Global.main_manager = self
	_main2D = $Main2D
	_gui = $GUI
	_player = Global.player
	_level_manager = Global.level_manager
	_gui_manager = Global.gui_manager
	
	if (load_initial_level() == 0):
		spawn_player()

func load_initial_level() -> int:
	if (Global.dev_mode == Util.DevMode.TEST):
		var s = _level_manager.load_level("dev_test_level")
		if(s == 1):
			return 1
		print("Test Level Loaded")
		return 0
	if (Global.dev_mode == Util.DevMode.DEV):
		print("Dev Level Loaded")
		return 0
	if (Global.dev_mode == Util.DevMode.PROD):
		print("Production")
		return 0
	return 0

func spawn_player() -> int:
	var level = Global.current_level_2D
	if (!level or !_player):
		return 1
	var player_spawnpoint = level.get_node("PlayerSpawnpoint")
	level.add_child(_player)
	level.move_child(_player, -1)
	if (!player_spawnpoint):
		return 1
	_player.global_position = player_spawnpoint.global_position
	return 0

func remove_player() -> int:
	var level = Global.current_level_2D
	if (!level.has_node("Player")):
		return 1
	level.remove_child(level.get_node("Player"))
	return 0
