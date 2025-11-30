extends Node

const PLAYER = preload("res://scenes/player/player_v3.tscn")

var player : Player
var main_manager : MainManager
var level_manager : LevelManager
var gui_manager : GUIManager
var camera_controller : CameraController

var dev_mode : int 

var current_gui : Control
var current_level_2D : Node2D


func _ready() -> void:
	dev_mode = Util.DevMode.TEST
	gui_manager = GUIManager.new()
	level_manager = LevelManager.new()
	
	player = PLAYER.instantiate()
	player.name = "Player"
