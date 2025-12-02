class_name MainManager extends Node

var _player : Player
var _main2D : Node2D
var _gui : Control

var _level_manager : LevelManager
var _gui_manager : GUIManager
var _camera_controller : CameraController

func _ready() -> void:	
	Global.main_manager = self
	_main2D = $Main2D
	_gui = $GUI
	_player = Global.player
	_level_manager = Global.level_manager
	_gui_manager = Global.gui_manager
	_camera_controller = Global.camera_controller
	
	if (load_initial_level() == 0):
		_level_manager.spawn_player()
	
	_init_signals()
	
	_camera_controller.set_target(_player)
	_camera_controller.follow_target = true
	_camera_controller.cam_process_callback = Util.CamProcessCallback.PHYSICS
	_camera_controller._set_level_size()

func _process(_delta: float) -> void:
	pass

func _input(_event: InputEvent) -> void:
	pass

func _init_signals() -> void:
	MessageBus.player_exit_attempt.connect(_handle_level_exit)

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

func _handle_level_exit(node : Node2D) -> void:
	if (node.is_in_group("LevelExits")):
		_level_manager.switch_level(node.next_level_name)
