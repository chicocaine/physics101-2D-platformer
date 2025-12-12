extends Node2D

@export var move_offset: Vector2 = Vector2(0, 160)
@export var duration: float = 0.5

@onready var closed_pos: Vector2 = position
@onready var open_pos: Vector2 = position + move_offset

var tween: Tween

func activate():
	move_to(open_pos)

func deactivate():
	move_to(closed_pos)

func move_to(target_position: Vector2):
	if tween:
		tween.kill()

	tween = create_tween()
	
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)

	tween.tween_property(self, "position", target_position, duration)
