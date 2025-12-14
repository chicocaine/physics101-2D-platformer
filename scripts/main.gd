class_name MainManager extends Node

var _main2D : Node2D
var _gui : Control

var _level_manager : LevelManager
var _gui_manager : GUIManager
var _camera_controller : CameraController

func _ready() -> void:
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	Global.main_manager = self
	_main2D = $Main2D
	_gui = $GUI
	_level_manager = Global.level_manager
	_gui_manager = Global.gui_manager
	_camera_controller = Global.camera_controller
	
	_init_signals()
	_setup_camera()
	_load_gui()
	_start()

func _start() -> void:
	_gui_manager.push_active_gui("main_menu")

func _setup_camera() -> void:
	_camera_controller.cam_process_callback = Util.CamProcessCallback.PHYSICS
	_camera_controller.set_zoom_value(Vector2(1.5, 1.5))

func _load_gui() -> void:
	_gui_manager.load_gui("settings")
	_gui_manager.load_gui("pause_menu")
	_gui_manager.load_gui("main_menu")
	_gui_manager.load_gui("HUD")

func _camera_follow_player() -> void:
	_camera_controller.set_target(Global.player)
	_camera_controller.follow_target = true

func _camera_release_player_focus() -> void:
	_camera_controller.release_focus()
	_camera_controller.follow_target = false

func _process(_delta: float) -> void:
	pass

func _init_signals() -> void:
	MessageBus.player_next_level_attempt.connect(_handle_next_level_attempt)
	MessageBus.player_entered_kill_zone.connect(_handle_player_entered_killzone)
	MessageBus.play_game_requested.connect(_start_play)
	MessageBus.lab_requested.connect(_start_lab)
	MessageBus.settings_requested.connect(_go_to_settings)
	MessageBus.quit_requested.connect(_quit_game)
	MessageBus.back_gui_requested.connect(_gui_handle_back_pressed)
	MessageBus.resume_game_requested.connect(_handle_resume_game)
	MessageBus.main_menu_requested.connect(_handle_main_menu_request)
	MessageBus.restart_level_requested.connect(_handle_restart_level_request)
	MessageBus.escape_is_pressed.connect(_handle_escape_pressed)

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
	_gui_manager.push_active_gui("HUD")
	if (_load_initial_level() == 0):
		_level_manager.spawn_player()
	_camera_follow_player()

func _start_lab() -> void:
	_gui_manager.push_active_gui("HUD")
	if (_level_manager.load_level("level_00_laboratory") == 0):
		_level_manager.spawn_player()
	_camera_follow_player()

func _go_to_settings() -> void:
	_gui_manager.push_active_gui("settings")

func _gui_handle_back_pressed() -> void:
	_gui_manager.pop_active_gui()

func _handle_resume_game() -> void:
	_resume_game()

func _handle_restart_level_request() -> void:
	_reset_current_level()

func _handle_escape_pressed() -> void:
	var current_gui : String = _gui_manager.current_top_gui_name()
	match current_gui:
		"main_menu":
			return
		"HUD":
			_pause_game()
		"pause_menu":
			_resume_game()
		"settings":
			_gui_manager.clear_active_gui()

func _pause_game() -> void:
	if (get_tree().paused == false):
		_gui_manager.push_active_gui("pause_menu")
		get_tree().paused = true

func _resume_game() -> void:
	if (get_tree().paused == true):
		_gui_manager.pop_active_gui()
		get_tree().paused = false

func _handle_main_menu_request() -> void:
	_resume_game()
	_level_manager.remove_player()
	_level_manager.unload_level(_level_manager.current_level_2D)
	_gui_manager.clear_active_gui()
	_gui_manager.push_active_gui("main_menu")
	pass

func _quit_game() -> void:
	get_tree().quit()

func _handle_next_level_attempt(next_level_name: String) -> void:
	_camera_release_player_focus()
	_level_manager.switch_level(next_level_name)
	if (is_instance_valid(_level_manager.current_level_2D)):
		_level_manager.spawn_player()
		_camera_follow_player()
		MessageBus.level_switched.emit()

func _reset_current_level() -> void:
	_resume_game()
	if (!_level_manager.current_level_2D):
		return
	var current_level_file_name : String = _level_manager.current_level_2D_file_name
	_level_manager.remove_player()
	_level_manager.unload_level(_level_manager.current_level_2D)
	_level_manager.load_level(current_level_file_name)
	_level_manager.spawn_player()
	MessageBus.level_restarted.emit()

func _handle_player_entered_killzone() -> void:
	_camera_release_player_focus()
	_reset_current_level()
	_camera_follow_player()
