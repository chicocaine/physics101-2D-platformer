class_name InteractionArea extends Area2D

@export var action_name : String = "interact"
@export var is_interactable : bool = true

var _interaction_manager : InteractionManager
var is_closest_to_player : bool
var interact : Callable = func():
	pass

func _ready() -> void:
	_interaction_manager = Global.interaction_manager
	self.is_closest_to_player = false
	self.set_collision_layer_value(2, true)
	self.set_collision_mask_value(4, true)
	self.body_entered.connect(_handle_body_entered)
	self.body_exited.connect(_handle_body_exited)
	MessageBus.closest_player_updated.connect(_handle_closest_player_updated)

func _handle_body_entered(body: Node2D) -> void:
	if (body.name == "Player"):
		_interaction_manager.register_interaction(self)

func _handle_body_exited(body: Node2D) -> void:
	if (body.name == "Player"):
		_interaction_manager.unregister_interaction(self)

func _handle_closest_player_updated() -> void:
	var active_interactions : Array[InteractionArea] = _interaction_manager.active_interactions
	if (active_interactions.is_empty() or _interaction_manager.active_interactions[0] != self):
		self.is_closest_to_player = false
	else:
		self.is_closest_to_player = true
