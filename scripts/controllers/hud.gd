class_name HUDController extends Control

@onready var label = $PanelContainer/HBoxContainer/Label

var _current_key_collected_count : int = 0

func _ready() -> void:
	self.label.text = "%d" % [_current_key_collected_count]
	MessageBus.key_collected.connect(_handle_key_collected)
	MessageBus.level_restarted.connect(reset_key_count)
	MessageBus.level_switched.connect(reset_key_count)

func _handle_key_collected(_key: int) -> void:
	_current_key_collected_count += 1
	_update_key_count()

func _update_key_count() -> void:
	self.label.text = "%d" % [_current_key_collected_count]

func reset_key_count() -> void:
	_current_key_collected_count = 0
	_update_key_count()
