extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -320.0
const RUN_MULTIPLIER = 1.5
const COMBO_RESET_TIME = 0.8
const COYOTE_TIME = 0.2
const PUSH_FORCE = 20
const MAX_VELOCITY = 100

@onready var animated_sprite = $AnimatedSprite2D
var attack_string = ["attack_1", "attack_2", "attack_3"]
var attack_string_counter = 0
var is_attacking = false
var combo_timer = 0.0
var coyote_timer = 0.0

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	movement()
	combo_reset_timer(delta)
	move_and_slide()
	coyote_time(delta)
	push()

func _ready() -> void:
	pass 

func _input(event):
	if event.is_action_pressed("attack"):
		handle_attack()

func _on_animation_finished() -> void:
	if animated_sprite.animation in attack_string:
		is_attacking = false

func handle_attack():
	if is_on_floor() and is_attacking == false:
		is_attacking = true
		combo_timer = COMBO_RESET_TIME
		animated_sprite.play(attack_string[attack_string_counter])
		attack_string_counter = (attack_string_counter + 1) % attack_string.size()

func movement():
	var direction := Input.get_axis("move_left", "move_right")
	
	var current_speed = SPEED
	
	if Input.is_action_pressed("run"):
		current_speed *= RUN_MULTIPLIER
	
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	
	if not is_attacking:
		if Input.is_action_just_pressed("jump") and coyote_timer > 0:
			velocity.y = JUMP_VELOCITY
			coyote_timer = 0
		if not is_on_floor():
			animated_sprite.play("jump")
		elif direction == 0:
			animated_sprite.play("idle")
		else:
			if Input.is_action_pressed("run"):
				animated_sprite.play("run")
			else:
				animated_sprite.play("walk")
	
	if is_attacking:
		velocity.x = 0
	else:
		if direction:
			velocity.x = direction * current_speed
		else:
			velocity.x = move_toward(velocity.x, 0, current_speed)

func combo_reset_timer(delta):
	if combo_timer > 0.0:
		combo_timer -= delta
		if combo_timer <= 0.0:
			attack_string_counter = 0

func coyote_time(delta):
	if is_on_floor():
		coyote_timer = COYOTE_TIME
	else:
		coyote_timer -= delta

func push():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collision_object = collision.get_collider()
		
		if collision_object.is_in_group("Pushable") and abs(collision_object.get_linear_velocity().x) < MAX_VELOCITY:
			collision_object.apply_impulse(collision.get_normal() * -PUSH_FORCE)
