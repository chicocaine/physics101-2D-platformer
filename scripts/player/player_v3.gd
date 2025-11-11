extends RigidBody2D

@onready var _animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var _hang_detector : Area2D = $HangDetector
@onready var _ground_check : RayCast2D = $GroundCheck

@export_category("Visual Scale")
@export var pixels_per_unit := 16.0

@export_category("Speed and Jump")
@export var move_speed_units := 9.0
@export var jump_height_units := 4.0

@export_category("Mass and Strength")
@export var player_mass := 1.0
@export var player_strength := 100 

@export_category("Running")
@export_range(1.0, 5.0) var running_multiplier := 1.5

@export_category("Acceleration and Friction")
@export var time_to_max_speed_ground := 0.2
@export var time_to_max_speed_air := 0.8
@export var time_to_apex := 0.3
@export var time_to_stop_ground := 0.15
@export var time_to_stop_air := 1.5

@export_category("Timers")
@export var input_buffer := 0.05
@export var coyote_time := 0.1

# Derived stats
var _move_speed: float
var _jump_height: float
var _gravity: float
var _jump_velocity: float
var _ground_accel: float
var _air_accel: float
var _ground_friction: float
var _air_friction: float

var _is_running := false
var _is_grounded := false
var _input_dir := 0.0
var _run_mul := 1.0

func _ready() -> void:
	can_sleep = false
	lock_rotation = true
	
	mass = player_mass
	_calc_player_stats()

func _is_on_ground() -> bool:
	return _ground_check.is_colliding()

func _calc_player_stats() -> void:
	_move_speed = move_speed_units * pixels_per_unit
	_jump_height = jump_height_units * pixels_per_unit

	_run_mul = running_multiplier

	_gravity = (2.0 * _jump_height) / pow(time_to_apex, 2)
	_jump_velocity = -sqrt(2.0 * _gravity * _jump_height)
	_ground_accel = _move_speed / time_to_max_speed_ground
	_air_accel = _move_speed / time_to_max_speed_air
	_ground_friction = _move_speed / time_to_stop_ground
	_air_friction = _move_speed / time_to_stop_air

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	_input_dir = Input.get_axis("move_left", "move_right")
	_is_running = Input.is_action_pressed("jump")
	_is_grounded = _is_on_ground()
	
	var velocity = state.linear_velocity
	var accel = _ground_accel if _is_grounded else _air_accel
	var friction = _ground_friction if _is_grounded else _air_friction
	var target_speed = _input_dir * _run_mul * _move_speed if _is_running else _input_dir * _move_speed
	
	var speed_diff = target_speed - velocity.x
	var force = clamp(speed_diff * accel, -player_strength, player_strength)
	state.apply_central_force(Vector2(force, 0))
	
	if abs(_input_dir) < 0.1 and abs(velocity.x) > 0.1:
		var friction_force = -sign(velocity.x) * friction
		state.apply_central_force(Vector2(friction_force, 0))
		
	state.apply_central_force(Vector2(0, _gravity * mass))
	
	if _is_grounded and Input.is_action_just_pressed("jump"):
		state.apply_central_impulse(Vector2(0, _jump_velocity * mass))
		 
