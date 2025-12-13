extends Node2D

@export var action_name : String = ""
@export var target_nodes : Array[Node2D]

var _interaction_area : InteractionArea
var _animated_sprite : AnimatedSprite2D

func _ready() -> void:
	_interaction_area = $InteractionArea
	_animated_sprite = $AnimatedSprite2D
	
	if (_animated_sprite):
		_animated_sprite.play("default")
	
	_interaction_area.interact = Callable(self, "_on_interact")
	_interaction_area.action_name = self.action_name
	
	MessageBus.closest_player_updated.connect(_handle_closest_player_updated)
	_interaction_area.body_entered.connect(_handle_interaction_body_entered)
	_interaction_area.body_exited.connect(_handle_interaction_body_exited)

func _on_interact() -> void:
	for node in self.target_nodes:
		if (node and node.has_method("activate")):
			AudioManager.sfx_controller.play_sfx_2d("test", self.global_position, "environment")
			await node.activate()

func _handle_closest_player_updated() -> void:
	_highlight_check()

func _handle_interaction_body_entered(_body: Node2D) -> void:
	_highlight_check()

func _handle_interaction_body_exited(_body: Node2D) -> void:
	_highlight_check()

func _highlight_check() -> void:
	if (_interaction_area.is_closest_to_player and _interaction_area.is_player_in_area):
		_animated_sprite.modulate = Color(1, 1, 0.5)
	else:
		_animated_sprite.modulate = Color.WHITE
