class_name SwingController
extends Node2D

@onready var swing_detector := $SwingDetector

@export var swing_cooldown := 0.2

var is_swinging := false
var current_rope: RigidBody2D = null

var _joint: PinJoint2D = null
var _swing_cooldown_timer := 0.0
var _parent_body: RigidBody2D
var _sprite: AnimatedSprite2D

func _ready() -> void:
	_parent_body = get_parent() as RigidBody2D
	_sprite = _parent_body.get_node_or_null("AnimatedSprite2D")
	
	if swing_detector:
		swing_detector.body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
	if _swing_cooldown_timer > 0:
		_swing_cooldown_timer -= delta
	
	if is_swinging and is_instance_valid(current_rope):
		_sprite.play("hold")

		var target_rotation = current_rope.global_rotation
		_sprite.global_rotation = lerp_angle(_sprite.global_rotation, target_rotation, 30.0 * delta)

		var dir_multiplier = -1.0 if _sprite.flip_h else 1.0
		var target_x = -12.0 * dir_multiplier
		var target_y = 4.0

		_sprite.offset.x = target_x 
		_sprite.offset.y = lerp(_sprite.offset.y, target_y, 10.0 * delta)
		
	else:
		if _sprite.global_rotation != 0.0:
			_sprite.global_rotation = lerp_angle(_sprite.global_rotation, 0.0, 15.0 * delta)
		
		if _sprite.offset != Vector2.ZERO:
			_sprite.offset = _sprite.offset.lerp(Vector2.ZERO, 15.0 * delta)

func process_swing(state: PhysicsDirectBodyState2D, 
					input_dir: float, 
					jump_pressed: bool,
					jump_velocity: float) -> void:
	if not is_instance_valid(current_rope):
		detach()
		return
	
	if is_swinging:
		if current_rope.has_method("apply_swing"):
			current_rope.apply_swing(input_dir)

		if jump_pressed:
			var rope_ref = current_rope
			detach() 
			state.apply_central_impulse(Vector2(0, -jump_velocity * _parent_body.mass))
			rope_ref.apply_central_impulse(Vector2(-input_dir * 100, 0))
			return

		return

func _on_body_entered(body: RigidBody2D) -> void:
	if is_swinging:
		return
	
	if body.is_in_group("Swingable") and _swing_cooldown_timer <= 0:
		_attach(body)

func _attach(rope: RigidBody2D) -> void:
	current_rope = rope
	is_swinging = true
	_joint = PinJoint2D.new()
	
	_joint.global_position = global_position
	_joint.node_a = _parent_body.get_path() # Player
	_joint.node_b = rope.get_path() # Rope
	
	_joint.disable_collision = true 
	
	get_tree().current_scene.add_child(_joint)
	print("hanged onto", current_rope)

func detach() -> void:
	is_swinging = false
	current_rope = null
	
	_joint.queue_free()
	_joint = null
	_swing_cooldown_timer = swing_cooldown
	_sprite.offset = Vector2.ZERO
	_sprite.play("fall")
