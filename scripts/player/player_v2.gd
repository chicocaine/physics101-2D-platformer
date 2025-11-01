extends CharacterBody2D

@export var pixels_per_unit := 16.0

@export var move_speed_units := 8.0
@export var jump_height_units := 4.0

@export var time_to_max_speed_ground := 0.2
@export var time_to_max_speed_air := 0.8
@export var time_to_apex := 0.4
@export var time_to_stop_ground := 0.15
@export var time_to_stop_air := 1.5

@onready var move_speed = move_speed_units * pixels_per_unit
@onready var jump_height = jump_height_units * pixels_per_unit

@onready var gravity = (2.0 * jump_height) / pow(time_to_apex, 2)
@onready var jump_velocity = -sqrt(2.0 * gravity * jump_height)
@onready var ground_accel = move_speed / time_to_max_speed_ground
@onready var air_accel = move_speed / time_to_max_speed_air
@onready var ground_friction = move_speed / time_to_stop_ground
@onready var air_friction = move_speed / time_to_stop_air

@onready var animated_sprite = $AnimatedSprite2D

func _ready() -> void:
	velocity = Vector2.ZERO

func _physics_process(delta : float) -> void:
	var input_dir = Input.get_axis("move_left", "move_right")
	var accel = ground_accel if is_on_floor() else air_accel
	var friction = ground_friction if is_on_floor() else air_friction
	
	if input_dir > 0:
		animated_sprite.flip_h = false
	elif input_dir < 0:
		animated_sprite.flip_h = true

	if velocity.x == 0:
		animated_sprite.play("idle")
	else:
		animated_sprite.play("walk")

	if input_dir != 0:
		velocity.x = move_toward(velocity.x, input_dir * move_speed, accel * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, friction * delta)
	
	if not is_on_floor():
		animated_sprite.play("jump")
		velocity.y += gravity * delta
	else:
		if Input.is_action_just_pressed("jump"):
			velocity.y = jump_velocity
	
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= 0.5
	
	move_and_slide()
