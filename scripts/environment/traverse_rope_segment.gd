extends RigidBody2D

var id := -1
var rope_instance: Node2D = null

func _ready() -> void:
	self.add_to_group("Traversable")
