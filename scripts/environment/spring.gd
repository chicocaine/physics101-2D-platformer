extends Area2D

@export var stiffness : float = 1500.0
@export var damping : float = 0.8
@export var spring_rotation : float = 90

var spring_rotation_rad : float
var direction_norm : Vector2
var spring_bodies : Array[RigidBody2D] = []

@onready var _spring_rest_length_mark : Node2D = $SpringRestLengthMark

func _ready() -> void:
	self.spring_rotation_rad = -self.spring_rotation * PI / 180
	self.direction_norm = Vector2(cos(spring_rotation_rad), sin(spring_rotation_rad)).normalized()
	self.rotate(spring_rotation_rad)

	self.body_entered.connect(_on_body_entered_spring_block)
	self.body_exited.connect(_on_body_exited_spring_block)

func _physics_process(_delta: float) -> void:
	var valid_bodies: Array[RigidBody2D] = []
	for body in spring_bodies:
		if !is_instance_valid(body):
			continue
		valid_bodies.append(body)
		_apply_spring_force(body)
	spring_bodies = valid_bodies

func _apply_spring_force(body: RigidBody2D) -> void:
	var to_body = body.global_position - _spring_rest_length_mark.global_position
	var compression = -to_body.dot(self.direction_norm)
	
	if (compression <= 0):
		return

	var v_rel = -body.linear_velocity.dot(self.direction_norm)
	var force_mag = (self.stiffness * compression) + (self.damping * v_rel)
	var force = self.direction_norm * force_mag
	body.apply_force(force)

func _on_body_entered_spring_block(body) -> void:
	if (body is RigidBody2D):
		spring_bodies.append(body)

func _on_body_exited_spring_block(body) -> void:
	var index : int = spring_bodies.find(body)
	if (index != -1):
		spring_bodies.remove_at(index)
