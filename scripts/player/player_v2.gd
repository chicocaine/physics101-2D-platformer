extends CharacterBody2D

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

var _move_speed
var _jump_height
var _mass
var _strength
var _run_mul

var _gravity
var _jump_velocity
var _ground_accel
var _air_accel
var _ground_friction
var _air_friction

var _animated_sprite_offset

const DEFAULT_PUSHABLE_BODY_MASS = 20.0

@onready var _animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var _hang_detector : Area2D = $HangDetector

var _jump_input_timer := 0.0
var _coyote_timer := 0.0
var _was_on_floor := false

var _is_running := false
var _is_hanging := false
var _hang_target : Area2D = null

func _ready() -> void:
	velocity = Vector2.ZERO
	_animated_sprite_offset = -_animated_sprite.position.y
	_calc_player_stats()
	
	if not _hang_detector.area_entered.is_connected(_on_hang_area_entered):
		_hang_detector.area_entered.connect(_on_hang_area_entered)
	if not _hang_detector.area_exited.is_connected(_on_hang_area_exited):
		_hang_detector.area_exited.connect(_on_hang_area_exited)

func _process(_delta : float) -> void:
	pass

func _physics_process(delta : float) -> void:
	_update_timers(delta)
	if is_on_floor():
		_coyote_timer = coyote_time
		_was_on_floor = true
	elif _was_on_floor and not is_on_floor():
		_was_on_floor = false
	
	_is_running = Input.is_action_pressed("run")

	if Input.is_action_just_pressed("jump"):
		_jump_input_timer = input_buffer
	
	if _is_hanging and _hang_target:
		velocity = Vector2.ZERO
		global_position = Vector2(
			_hang_target.global_position.x, 
			_hang_target.global_position.y + _animated_sprite_offset
		)
		
		if Input.is_action_just_pressed("jump"):
			_detach_and_jump()
		elif Input.is_action_just_pressed("down"):
			_detach()
		
		if _animated_sprite.animation != "hold":
			_animated_sprite.play("hold")
		return

	var input_dir = Input.get_axis("move_left", "move_right")
	var accel = _ground_accel if is_on_floor() else _air_accel
	var friction = _ground_friction if is_on_floor() else _air_friction

	if velocity.x > 0:
		_animated_sprite.flip_h = false
	elif velocity.x < 0:
		_animated_sprite.flip_h = true

	if is_on_floor():
		if velocity.x == 0:
			if _animated_sprite.animation != "idle":
				_animated_sprite.play("idle")
		else:
			if _is_running:
				if _animated_sprite.animation != "run":
					_animated_sprite.play("run")
			else:
				if _animated_sprite.animation != "walk":
					_animated_sprite.play("walk")

	var current_move_speed = _get_move_speed()

	if input_dir != 0:
		velocity.x = move_toward(velocity.x, input_dir * current_move_speed, accel * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, friction * delta)
	
	var can_jump = is_on_floor() or _coyote_timer > 0
	var wants_to_jump = _jump_input_timer > 0
	
	if can_jump and wants_to_jump:
		velocity.y = _jump_velocity
		_jump_input_timer = 0.0  
		_coyote_timer = 0.0      
	
	if not _was_on_floor and not is_on_floor():
		if velocity.y < 0:
			if _animated_sprite.animation != "jump-air":
				_animated_sprite.play("jump-air")
		elif velocity.y > 0:
			if _animated_sprite.animation != "fall":
				_animated_sprite.play("fall")
		velocity.y += _gravity * delta
	
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= 0.5
	
	move_and_slide()

func _update_timers(delta : float) -> void:
	_jump_input_timer -= delta
	_coyote_timer -= delta

func _calc_player_stats() -> void:
	_move_speed = move_speed_units * pixels_per_unit
	_jump_height = jump_height_units * pixels_per_unit

	_mass = player_mass
	_strength = player_strength
	_run_mul = running_multiplier

	_gravity = (2.0 * _jump_height) / pow(time_to_apex, 2)
	_jump_velocity = -sqrt(2.0 * _gravity * _jump_height)
	_ground_accel = _move_speed / time_to_max_speed_ground
	_air_accel = _move_speed / time_to_max_speed_air
	_ground_friction = _move_speed / time_to_stop_ground
	_air_friction = _move_speed / time_to_stop_air

func _on_hang_area_entered(area : Area2D) -> void:
	if area.is_in_group("Hangable"):
		_hang_target = area
		_is_hanging = true
		# print("hanged onto", _hang_target)

func _on_hang_area_exited(area : Area2D) -> void:
	if area == _hang_target:
		_is_hanging = false
		# print("Unhanged", _hang_target)
		_hang_target = null	

func _detach() -> void:
	_is_hanging = false
	_hang_target = null
	print("Detached from hang target")

func _detach_and_jump() -> void:
	_detach()
	velocity.y = _jump_velocity
	print("Detached and jumped")

func _get_move_speed() -> float:
	if _is_running:
		return _move_speed * _run_mul
	return _move_speed
