extends StaticBody2D

var _animated_sprite : AnimatedSprite2D
var _piston_zone : Area2D

@export var impulse_strength : float = 500.0
@export var piston_rotation : float = 0.0

var piston_rotation_rad : float
var pushable : Array[RigidBody2D]

func _ready() -> void:
	_animated_sprite = $AnimatedSprite2D
	_piston_zone = $PistonZone
	
	self.piston_rotation_rad = -self.piston_rotation * PI / 180
	self.pushable = []
	self.rotate(piston_rotation_rad)
	
	_piston_zone.body_entered.connect(_on_body_entered_piston_area)
	_piston_zone.body_exited.connect(_on_body_exited_piston_area)

func activate() -> void:
	var direction : Vector2 = Vector2(cos(self.piston_rotation_rad), sin(self.piston_rotation_rad))
	_animated_sprite.speed_scale = 2.0
	_animated_sprite.play("activate")
	for node in pushable:
		node.apply_impulse(direction.normalized() * impulse_strength)

func _on_body_entered_piston_area(body: Node2D) -> void:
	if (body is RigidBody2D):
		pushable.append(body)

func _on_body_exited_piston_area(body: Node2D) -> void:
	if (body is RigidBody2D):
		var index = pushable.find(body)
		if (index != -1):
			pushable.remove_at(index)
