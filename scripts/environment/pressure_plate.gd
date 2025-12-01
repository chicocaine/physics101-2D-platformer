extends Area2D

@onready var sprite: Sprite2D = $Sprite2D

@export var target_node: Node2D

const RED_FRAME_UP: int = 0
const RED_FRAME_DOWN: int = 4
const GREEN_FRAME_UP: int = 1
const GREEN_FRAME_DOWN: int = 5
const BLUE_FRAME_UP: int = 2
const BLUE_FRAME_DOWN: int = 6
const YELLOW_FRAME_UP: int = 3
const YELLOW_FRAME_DOWN: int = 7

signal stepped_on
signal stepped_off

func _ready():
	sprite.frame = RED_FRAME_UP
	
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	if target_node:
		if target_node.has_method("activate"):
			stepped_on.connect(target_node.activate)
			
		if target_node.has_method("deactivate"):
			stepped_off.connect(target_node.deactivate)

# Mask on 5
func _on_body_entered(_body):
	print("Pressure plate stepped on")
	emit_signal("stepped_on")
	sprite.frame = RED_FRAME_DOWN

func _on_body_exited(_body):
	print("Pressure plate stepped off of")
	emit_signal("stepped_off")
	sprite.frame = RED_FRAME_UP
