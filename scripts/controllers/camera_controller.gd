class_name CameraController extends Camera2D

var player : Player

func _ready() -> void:
	Global.camera_controller = self
	if (Global.player):
		player = Global.player
