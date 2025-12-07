extends Node2D

@export var segment_scene: PackedScene
@export var target_segment_length = 18.0

@onready var start_anchor: StaticBody2D = $StartAnchor
@onready var end_anchor: StaticBody2D = $EndAnchor
@onready var rope_line: Line2D = $RopeLine

var segments: Array = []

func _ready() -> void:
	create_rope()

func create_rope() -> void:
	var start_pos = start_anchor.global_position
	var end_pos = end_anchor.global_position
	var diff_vector = end_pos - start_pos
	var total_distance = diff_vector.length()

	var segment_count = round(total_distance / target_segment_length)
	if segment_count == 0: segment_count = 1

	var exact_length = total_distance / segment_count
	
	var spawn_angle = diff_vector.angle() - (PI / 2)
	
	var prev_body = start_anchor
	
	for i in range(segment_count):
		var new_segment = add_segment(prev_body, i, spawn_angle, exact_length)
		segments.append(new_segment)
		prev_body = new_segment

		if i == segment_count - 1:
			var end_joint = end_anchor.get_node("Joint") as PinJoint2D
			end_joint.global_position = end_anchor.global_position
			end_joint.node_a = end_anchor.get_path()
			end_joint.node_b = new_segment.get_path()

func add_segment(parent: Node2D, id: int, spawn_angle: float, length: float) -> RigidBody2D:
	var new_segment = segment_scene.instantiate() as RigidBody2D
	var parent_joint = parent.get_node("Joint") as PinJoint2D
	
	add_child(new_segment)
	new_segment.global_position = parent_joint.global_position
	new_segment.rotation = spawn_angle
	new_segment.id = id
	new_segment.rope_instance = self
	
	var my_joint = new_segment.get_node("Joint")
	my_joint.position = Vector2(0, length)
	
	parent_joint.node_a = parent.get_path()
	parent_joint.node_b = new_segment.get_path()
	
	return new_segment

func _physics_process(_delta: float) -> void:
	if segments.size() > 0:
		var points = []
		points.append(to_local(start_anchor.get_node("Joint").global_position))
		for seg in segments:
			points.append(to_local(seg.get_node("Joint").global_position))
		points.append(to_local(end_anchor.get_node("Joint").global_position))
		rope_line.points = PackedVector2Array(points)
