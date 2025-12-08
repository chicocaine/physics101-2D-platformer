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

func _ready():
	self.sprite.frame = current_color
	
	self.body_entered.connect(_on_body_entered)
	self.body_exited.connect(_on_body_exited)
	
	if target_node:
		if target_node.has_method("activate"):
			MessageBus.stepped_on.connect(target_node.activate)
		if target_node.has_method("deactivate"):
			MessageBus.stepped_off.connect(target_node.deactivate)

func _on_body_entered(_body):
	MessageBus.stepped_on.emit()
	sprite.frame = current_color + DOWN_OFFSET

func _on_body_exited(_body):
	MessageBus.stepped_off.emit()
	sprite.frame = current_color
