extends Node2D

@export var segment_scene: PackedScene
@export var segment_count = 10
@export var segment_length = 18.0

@onready var anchor: StaticBody2D = $Anchor
@onready var anchor_joint: PinJoint2D = $Anchor/Joint
@onready var rope_line: Line2D = $RopeLine

var segments: Array = []

func _ready() -> void:
	create_rope()

func _physics_process(_delta: float) -> void:
	get_rope_points()

func create_rope() -> void:
	var prev_segment = anchor
	
	for i in range(segment_count):
		var new_segment = segment_scene.instantiate()
		var joint = prev_segment.get_node_or_null("Joint") as PinJoint2D
		var current_segment = new_segment
		
		new_segment.position = prev_segment.position + Vector2(0, segment_length)
		add_child(new_segment)
		segments.append(new_segment)
		joint.node_b = joint.get_path_to(current_segment)
		
		prev_segment = current_segment

func get_rope_points() -> void:
	var rope_points: PackedVector2Array = []
	rope_points.append(to_local(anchor_joint.global_position))
	
	for i in segments:
		var joint = i.get_node_or_null("Joint") as PinJoint2D
		rope_points.append(to_local(joint.global_position))
	
	rope_line.points = rope_points
