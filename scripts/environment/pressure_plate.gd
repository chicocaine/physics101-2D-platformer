extends Area2D

@onready var sprite: Sprite2D = $Sprite2D

enum PlateColor {
	RED = 0,
	GREEN = 1,
	BLUE = 2,
	YELLOW = 3
}
@export var current_color: PlateColor = PlateColor.RED
@export var target_node: Node2D

const DOWN_OFFSET = 4

signal stepped_on
signal stepped_off

func _ready():
	sprite.frame = current_color
	
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	if target_node:
		if target_node.has_method("activate"):
			stepped_on.connect(target_node.activate)
		if target_node.has_method("deactivate"):
			stepped_off.connect(target_node.deactivate)

func _on_body_entered(_body):
	print("Pressure plate stepped on")
	emit_signal("stepped_on")

	sprite.frame = current_color + DOWN_OFFSET

func _on_body_exited(_body):
	print("Pressure plate stepped off of")
	emit_signal("stepped_off")

	sprite.frame = current_color
