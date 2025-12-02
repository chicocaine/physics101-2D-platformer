class_name Killzone extends Area2D

func _ready() -> void:
	self.add_to_group("Killzones")
	self.body_entered.connect(_handle_body_entered_killzone)
	self.set_collision_layer_value(1, false)
	self.set_collision_mask_value(4, true)

func _handle_body_entered_killzone(body: Node2D) -> void:
	if (body.name == "Player" and body is Player):
		MessageBus.player_entered_kill_zone.emit()
