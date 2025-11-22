extends Node
class_name EnvironmentController

signal environment_updated(gravity_value: float)

@export var gravity_value : float = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready() -> void:
	Engine.time_scale = 1.0

func set_gravity(value : float) -> void:
	gravity_value = value
	emit_signal("environment_updated", gravity_value)
