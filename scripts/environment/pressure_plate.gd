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
@export var deactivate_delay: float = 0.0

signal stepped_on
signal stepped_off

const DOWN_OFFSET = 4

var _timer: Timer

func _ready():
	self.sprite.frame = current_color
	
	self.body_entered.connect(_on_body_entered)
	self.body_exited.connect(_on_body_exited)
	
	_timer = Timer.new()
	_timer.one_shot = true
	_timer.timeout.connect(_perform_deactivate)
	add_child(_timer)
	
	if target_node:
		if target_node.has_method("activate"):
			self.stepped_on.connect(target_node.activate)
		if target_node.has_method("deactivate"):
			self.stepped_off.connect(target_node.deactivate)

func _on_body_entered(_body):

	if not _timer.is_stopped():
		_timer.stop()
	
	if get_overlapping_bodies().size() == 1:
		self.stepped_on.emit()
		sprite.frame = current_color + DOWN_OFFSET

func _on_body_exited(_body):
	if not has_overlapping_bodies():
		if deactivate_delay > 0:
			_timer.start(deactivate_delay)
		else:
			_perform_deactivate()

func _perform_deactivate():
	self.stepped_off.emit()
	sprite.frame = current_color
