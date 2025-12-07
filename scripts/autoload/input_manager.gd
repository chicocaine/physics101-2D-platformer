extends Node

func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("interact")):
		Global.interaction_manager.handle_interact_is_action_pressed()

	if (event.is_action_pressed("up")):
		MessageBus.up_is_pressed.emit()
