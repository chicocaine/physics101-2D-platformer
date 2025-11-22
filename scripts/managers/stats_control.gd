extends CanvasLayer

@export var player_path : NodePath
var _player_ref

func _ready() -> void:
	_player_ref = player_path

func get_player_path():
	return _player_ref
