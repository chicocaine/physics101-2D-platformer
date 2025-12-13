class_name MainManager extends Node

var _main2D : Node2D
var _gui : Control

var _level_manager : LevelManager
var _gui_manager : GUIManager
var _camera_controller : CameraController

func _ready() -> void:	
	Global.main_manager = self
	_main2D = $Main2D
	_gui = $GUI
	_level_manager = Global.level_manager
	_gui_manager = Global.gui_manager
	_camera_controller = Global.camera_controller
	
	_init_signals()
	_setup_camera()
	_start()

func _start() -> void:
	_gui_manager.load_gui("main_menu")

func _setup_camera() -> void:
	_camera_controller.cam_process_callback = Util.CamProcessCallback.PHYSICS
	_camera_controller.set_zoom_value(Vector2(1.5, 1.5))

func _camera_follow_player() -> void:
	_camera_controller.set_target(Global.player)
	_camera_controller.follow_target = true

func _camera_release_player_focus() -> void:
	_camera_controller.release_focus()
	_camera_controller.follow_target = false

func _process(_delta: float) -> void:
	for node in get_tree().get_nodes_in_group("Hangable"):
		print(node)

func _init_signals() -> void:
	MessageBus.player_next_level_attempt.connect(_handle_next_level_attempt)
	MessageBus.player_entered_kill_zone.connect(_handle_player_entered_killzone)
	MessageBus.play_game_requested.connect(_start_play)
	MessageBus.lab_requested.connect(_start_lab)
	MessageBus.settings_requested.connect(_go_to_settings)
	MessageBus.quit_requested.connect(_quit_game)

func _load_initial_level() -> int:
	if (Global.dev_mode == Util.DevMode.TEST):
		var s = _level_manager.load_level("dev_test_level")
		if(s == 1):
			return 1
		print("Test Level Loaded")
		return 0
	if (Global.dev_mode == Util.DevMode.DEV):
		var s = _level_manager.load_level("level_01_intro")
		if(s == 1):
			return 1
		print("Dev Level Loaded")
		return 0
	if (Global.dev_mode == Util.DevMode.PROD):
		var s = _level_manager.load_level("level_01_intro")
		if(s == 1):
			return 1
		print("Production")
		return 0
	return 0

func _start_play() -> void:
	if (_load_initial_level() == 0):
		_level_manager.spawn_player()
	_camera_follow_player()

func _start_lab() -> void:
	if (_level_manager.load_level("level_00_laboratory") == 0):
		_level_manager.spawn_player()
	_camera_follow_player()

func _go_to_settings() -> void:
	pass

func _quit_game() -> void:
	get_tree().quit()

func _handle_next_level_attempt(next_level_name: String) -> void:
	_level_manager.switch_level(next_level_name)

func _handle_player_entered_killzone() -> void:
	_camera_release_player_focus()
	_level_manager.reset_level()
	_camera_follow_player()
