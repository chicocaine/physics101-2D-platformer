class_name InteractionManager extends Node

var _player : Player

var can_interact : bool = false
var active_interactions : Array[InteractionArea] 

func _init() -> void:
	_player = Global.player
	self.can_interact = true
	self.active_interactions = []

func interaction_service_loop() -> void:
	if (!self.active_interactions.is_empty() and self.can_interact):
		_sort_interactions_custom(self.active_interactions, _sort_by_distance_to_player)

func handle_interact_is_action_pressed() -> void:
	if (self.can_interact and self.active_interactions.size() > 0):
		self.can_interact = false
		await self.active_interactions[0].interact.call()
		self.can_interact = true

func register_interaction(interaction: InteractionArea) -> void:
	if (interaction.is_interactable):
		active_interactions.push_back(interaction)

func unregister_interaction(interaction: InteractionArea) -> void:
	var index = active_interactions.find(interaction)
	if (index != -1):
		active_interactions.remove_at(index)

func _sort_interactions_custom(array: Array[InteractionArea], comparator: Callable) -> void:
	if (array.is_empty()):
		MessageBus.closest_player_updated.emit()
		return
	var temp_closest_to_player = array[0]
	var n : int = array.size()
	for i in range (1, n):
		var key : InteractionArea = array[i]
		var j = i - 1
		while j >= 0 and comparator.call(key, array[j]) == false:
			array[j + 1] = array[j]
			j -= 1
		array[j + 1] = key
	if (temp_closest_to_player != array[0]):
		MessageBus.closest_player_updated.emit()

func _sort_by_distance_to_player(area1: InteractionArea, area2: InteractionArea) -> bool:
	var area1_distance_to_player = _player.global_position.distance_to(area1.global_position)
	var area2_distance_to_player = _player.global_position.distance_to(area2.global_position)
	return area1_distance_to_player > area2_distance_to_player
