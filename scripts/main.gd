class_name MainManager extends Node

var _player : Player
var _main2D : Node2D
var _gui : Control

var _level_manager : LevelManager
var _gui_manager : GUIManager
var _camera_controller : CameraController

var _player_in_next_level_exit : bool
var levels : Array[String] = [
		"dev_test_level",
		"dev_test_level_1"
	]
var current_level_idx : int

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
	
	_camera_controller.set_target(_player)
	_camera_controller.follow_target = true
	_camera_controller.cam_process_callback = Util.CamProcessCallback.PHYSICS
	_camera_controller._set_level_size()
	
	_handle_signals()

func _process(_delta: float) -> void:
	pass

func load_initial_level() -> int:
	if (Global.dev_mode == Util.DevMode.TEST):
		var s = _level_manager.load_level(levels[current_level_idx])
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

func _handle_signals() -> void:
	_level_manager._next_level.body_entered.connect(_next_level_body_entered)
	_level_manager._next_level.body_exited.connect(_next_level_body_exited)
	
	for key in (Global.current_level_2D.get_tree().get_nodes_in_group("Keys")):
		key.key_collected.connect(_handle_key_collected)

func _next_level_body_entered(body: Node2D) -> void:
	if (body.name == "Player"):
		_player_in_next_level_exit = true

func _next_level_body_exited(body: Node2D) -> void:
	if (body.name == "Player"):
		_player_in_next_level_exit = false

func _handle_next_level() -> void:
	var key_count : int = _level_manager._key_count
	var key_collected_count : int = _level_manager._key_collected_count
	if (key_count != key_collected_count):
		print("Denied Entry: Not enough keys")
		return
	self.current_level_idx += 1
	print(self.current_level_idx)
	_level_manager.switch_level(levels[current_level_idx])

func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("up") and _player_in_next_level_exit):
		_handle_next_level()

func _handle_key_collected() -> void:
	_level_manager._add_collected_count()
