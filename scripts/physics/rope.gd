extends Node2D

@export var segment_scene: PackedScene
@export var segment_count = 0
@export var segment_length = 0.0

var segments: Array = []

func _ready() -> void:
	create_rope()

func _process(delta: float) -> void:
	pass

func create_rope():
	pass
