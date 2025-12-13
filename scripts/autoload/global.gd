extends Node

const PLAYER = preload("res://scenes/player/player_v3.tscn")

var player : Player
var main_manager : MainManager
var level_manager : LevelManager
var gui_manager : GUIManager
var interaction_manager : InteractionManager
var camera_controller : CameraController

var dev_mode : int 

func _ready() -> void:
	player = PLAYER.instantiate()
	player.name = "Player"
	
	dev_mode = Util.DevMode.DEV
	gui_manager = GUIManager.new()
	level_manager = LevelManager.new()
	interaction_manager = InteractionManager.new()
	

func _process(_delta: float) -> void:
	_services()

func _services() -> void:
	interaction_manager.interaction_service_loop()
