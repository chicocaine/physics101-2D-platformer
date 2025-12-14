extends Node

func _ready() -> void:
	self.process_mode = Node.PROCESS_MODE_ALWAYS

func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("interact")):
		MessageBus.interact_is_pressed.emit()

	if (event.is_action_pressed("up")):
		MessageBus.up_is_pressed.emit()
	
	if (event.is_action_pressed("escape")):
		MessageBus.escape_is_pressed.emit()
