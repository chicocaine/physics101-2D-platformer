class_name TraverseController
extends Node2D

@onready var traverse_detector := $TraverseDetector

@export var traverse_speed := 10.0
@export var traverse_cooldown := 1.0
@export var jump_off_force := 400.0
@export var attached_mass := 3

var is_traversing := false
var current_rope: Node2D = null 
var current_segment_index: int = 0
var segment_progress: float = 0.5 

var _added_mass := 0.0
var _traverse_cooldown_timer := 0.0
var _parent_body: RigidBody2D
var _sprite: AnimatedSprite2D 

func _ready() -> void:
	_parent_body = get_parent() as RigidBody2D
	_sprite = _parent_body.get_node_or_null("AnimatedSprite2D")
	
	if traverse_detector:
		traverse_detector.body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
	if _traverse_cooldown_timer > 0:
		_traverse_cooldown_timer -= delta
	
	if is_traversing:
		_sprite.play("hold")

func process_traverse(state: PhysicsDirectBodyState2D, input_dir: float, jump_pressed: bool, jump_velocity: float):
	if input_dir != 0:
		segment_progress += input_dir * traverse_speed * state.step
		
		if input_dir < 0:
			_sprite.flip_h = true
		else:
			_sprite.flip_h = false
	
	if _sprite.flip_h:
		_sprite.offset = Vector2(10, 0) # HACK
	else:
		_sprite.offset = Vector2(-20, 0) # HACK
		
	var segments = current_rope.segments
	var previous_index = current_segment_index
	
	if segment_progress > 1.0:
		if current_segment_index < segments.size() - 1:
			current_segment_index += 1
			segment_progress = 0.0
		else:
			segment_progress = 1.0 
			
	elif segment_progress < 0.0:
		if current_segment_index > 0:
			current_segment_index -= 1
			segment_progress = 1.0 
		else:
			segment_progress = 0.0 
	
	# remove fake mass, TODO: ease in mass removal
	if current_segment_index != previous_index:
		segments[previous_index].mass -= _added_mass

		segments[current_segment_index].mass += _added_mass
		segments[current_segment_index].sleeping = false
	
	var current_segment = segments[current_segment_index]
	
	var start_pos = current_segment.global_position + traverse_detector.position
	var end_pos = current_segment.get_node("Joint").global_position + traverse_detector.position
	
	var target_pos = start_pos.lerp(end_pos, segment_progress)
	
	state.transform.origin = target_pos - Vector2(-10, -40) # HACK: offset hand to rope
	state.linear_velocity = Vector2.ZERO
	
	if jump_pressed:
		_detach()
		state.apply_central_impulse(Vector2(0, -jump_velocity * _parent_body.mass))
		current_segment.apply_central_impulse(Vector2(-input_dir * 100, 0))

func _on_body_entered(body: Node) -> void:
	if is_traversing or _traverse_cooldown_timer > 0:
		return
	
	if body.is_in_group("Traversable") and _traverse_cooldown_timer <= 0:
		_attach(body, body.global_position)

func _attach(segment: Object, hit_pos: Vector2):
	is_traversing = true
	current_rope = segment.rope_instance
	current_segment_index = segment.id
	
	# fake mass TODO: ease in mass addition
	_added_mass = _parent_body.mass + attached_mass
	segment.sleeping = false
	segment.mass += _added_mass

	var segment_start_pos = segment.global_position
	var segment_end_pos = segment.get_node("Joint").global_position
	var segment_length_squared = segment_start_pos.distance_squared_to(segment_end_pos)
	
	if segment_length_squared > 0:
		var project = (hit_pos - segment_start_pos).dot(segment_end_pos - segment_start_pos) / segment_length_squared
		segment_progress = clamp(project, 0.0, 1.0)
	else:
		segment_progress = 0.5

func _detach():
	if current_rope != null:
		var segments = current_rope.segments
		segments[current_segment_index].mass -= _added_mass
	is_traversing = false
	current_rope = null
	_traverse_cooldown_timer = traverse_cooldown
	_sprite.offset = Vector2.ZERO
	_sprite.play("fall")

func _get_player_pos_on_rope():
	return current_rope.segments[current_segment_index].global_position - traverse_detector.position
