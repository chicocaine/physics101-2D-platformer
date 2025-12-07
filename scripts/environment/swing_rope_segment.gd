extends RigidBody2D

@export var swing_force = 500.0

func _ready() -> void:
	self.add_to_group("Swingable")

func apply_swing(direction: float):
	if direction == 0:
		return

	var swing_direction = global_transform.x
	apply_central_force(swing_direction * direction * swing_force)
