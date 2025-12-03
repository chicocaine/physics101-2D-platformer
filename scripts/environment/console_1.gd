extends Node2D

@export var action_name : String = ""
var _interaction_area : InteractionArea
var _animated_sprite : AnimatedSprite2D

func _ready() -> void:
	_interaction_area = $InteractionArea
	_animated_sprite = $AnimatedSprite2D
	
	if (_animated_sprite):
		_animated_sprite.play("default")
	
	_interaction_area.interact = Callable(self, "_on_interact")
	_interaction_area.action_name = self.action_name

func _on_interact() -> void:
	print(self.action_name, ": Interacted")
