class_name MainManager extends Node

var _player : Player
var _main2D : Node2D
var _gui : Control

var _level_manager : LevelManager
var _gui_manager : GUIManager

func _ready() -> void:	
	Global.game_manager = self
	_main2D = $Main2D
	_gui = $GUI
	_level_manager = Global.level_manager
	_gui_manager = Global.gui_manager

func load_initial_level() -> int:
	if(Global.dev_mode == Util.DevMode.TEST):
		var s = _level_manager.load_level("dev_test_level")
		if(!s):
			return 1
		print("Test Level Loaded")
		return 0
	if(Global.dev_mode == Util.DevMode.DEV):
		print("Dev Level Loaded")
		return 0
	if(Global.dev_mode == Util.DevMode.PROD):
		print("Production")
		return 0
	return 0
