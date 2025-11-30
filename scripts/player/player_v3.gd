extends RigidBody2D
class_name Player

@export_category("Environment Scaling")
@export var use_environment_gravity := true
@export var gravity_scale_override := 1.0

@export_category("Player Physical Properties")
@export var mass_override := 1.0
@export var friction_coeff := 0.3
@export var restitution := 0.0
@export var linear_drag := 0.05
@export var air_drag := 0.01

@export_category("Control Forces")
@export var move_force := 600.0
@export var jump_impulse := 250.0
@export var air_control_factor := 0.5
@export var run_multiplier := 1.5

@export_category("Speed Limits")
@export var max_horizontal_speed := 300.0
@export var max_fall_speed := 1200.0     
@export var max_rise_speed := 600.0      

@export_category("Slopes")
@export var max_slope_angle := 40.0

## Still Temporary
@export_category("Acceleration")
@export var accel_ground := 2400.0
@export var accel_air := 1200.0
@export var decel_ground := 3000.0
@export var decel_air := 1500.0

@export_category("Timers")
@export var jump_input_buffer := 0.1
@export var coyote_time := 0.1

@onready var shape: CollisionShape2D = $CollisionShape2D
@onready var ground_ray: RayCast2D = $GroundRay
@onready var _animated_sprite = $AnimatedSprite2D
@onready var _hang_detector: Area2D = $HangDetector

# Internal
var _is_grounded := false
var _was_grounded := false
var _is_running := false
var _is_hanging := false
var _input_dir := 0.0

var _env_gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

var _jump_buffer_timer := 0.0
var _coyote_timer := 0.0

func _ready() -> void:
	mass = mass_override
	inertia = mass_override
	lock_rotation = true

	physics_material_override = PhysicsMaterial.new()
	physics_material_override.friction = friction_coeff
	physics_material_override.bounce = restitution
	
	if not _hang_detector.area_entered.is_connected(_on_hang_area_entered):
		_hang_detector.area_entered.connect(_on_hang_area_entered)
	if not _hang_detector.area_exited.is_connected(_on_hang_area_exited):
		_hang_detector.area_exited.connect(_on_hang_area_exited)

func _physics_process(_delta: float) -> void:
	if _input_dir > 0:
		_animated_sprite.flip_h = false
	elif _input_dir < 0:
		_animated_sprite.flip_h = true

	if _is_grounded:
		if abs(linear_velocity.x) > 0.1:
			if _is_running:
				if _animated_sprite.animation != "run":
					_animated_sprite.play("run")
			else:
				if _animated_sprite.animation != "walk":
					_animated_sprite.play("walk")
		else:
			if _animated_sprite.animation != "idle":
				_animated_sprite.play("idle")

	if _was_grounded and not _is_grounded:
		if linear_velocity.y < 0:
			if _animated_sprite.animation != "jump-air":
				_animated_sprite.play("jump-air")
			elif _animated_sprite.animation != "fall":
				_animated_sprite.play("fall")	

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	_was_grounded = _is_grounded
	_is_grounded = _check_ground(state)

	_update_timers(state, _was_grounded)
	_handle_input()

	if _is_hanging:
		_handle_hanging(state)

	var force := Vector2.ZERO
	if _input_dir != 0.0:
		var control := move_force if _is_grounded else move_force * air_control_factor
		force.x = _input_dir * control

		if _is_running:
			force.x *= run_multiplier

	if Input.is_action_just_pressed("jump"):
		_jump_buffer_timer = jump_input_buffer
	
	var can_jump := _was_grounded or _coyote_timer > 0.0

	if can_jump and _jump_buffer_timer > 0.0:
		state.apply_central_impulse(Vector2(0, -jump_impulse))
		_jump_buffer_timer = 0.0
		_coyote_timer = 0.0

	var final_gravity := _env_gravity * gravity_scale_override if use_environment_gravity else _env_gravity
	state.apply_central_force(Vector2(0, final_gravity * mass))

	_apply_drag(state)
	state.apply_central_force(force)
	_clamp_velocity(state)


func _update_timers(state: PhysicsDirectBodyState2D, was_grounded : bool) -> void:
	if _jump_buffer_timer > 0.0:
		_jump_buffer_timer -= state.step

	if _is_grounded and was_grounded:
		_coyote_timer = coyote_time
	elif _coyote_timer > 0.0:
		_coyote_timer -= state.step

func _handle_input() -> void:
	_input_dir = Input.get_axis("move_left", "move_right")
	_is_running = Input.is_action_pressed("run")

func _apply_drag(state: PhysicsDirectBodyState2D) -> void:
	var drag := linear_drag if _is_grounded else air_drag
	var vel := state.linear_velocity

	vel.x = lerp(vel.x, 0.0, drag * state.step * 60.0)
	state.linear_velocity = vel

func _check_ground(state: PhysicsDirectBodyState2D) -> bool:
	var threshold := _slope_dot_threshold()

	# Check contacts
	for i in range(state.get_contact_count()):
		var n := state.get_contact_local_normal(i)

		# Rotation locked → Vector2.UP is the character's local up
		if n.dot(Vector2.UP) >= threshold:
			return true

	# Fallback ray (world-space normal)
	if ground_ray.is_colliding():
		var rn := ground_ray.get_collision_normal()
		if rn.dot(Vector2.UP) >= threshold:
			return true

	return false

func _clamp_velocity(state: PhysicsDirectBodyState2D) -> void:
	var vel := state.linear_velocity
	vel.x = clamp(vel.x, -max_horizontal_speed, max_horizontal_speed)
	if vel.y > max_fall_speed:
		vel.y = max_fall_speed
	elif vel.y < -max_rise_speed:
		vel.y = -max_rise_speed

	state.linear_velocity = vel

func _slope_dot_threshold() -> float:
	return cos(deg_to_rad(max_slope_angle))

func _is_slope_too_steep(normal: Vector2) -> bool:
	return normal.dot(Vector2.UP) < _slope_dot_threshold()

func _on_hang_area_entered(area: Area2D) -> void:
	print("Detected hang area: ", area)
	if area.is_in_group("Hangable"):
		_is_hanging = true

func _on_hang_area_exited(area: Area2D) -> void:
	print("Left")
	if area:
		_is_hanging = false

func _handle_hanging(_state: PhysicsDirectBodyState2D) -> void:
	# handle hanging
	return
