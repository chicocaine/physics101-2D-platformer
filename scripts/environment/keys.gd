extends Node2D

@export var key_type : Util.KeyType
var _animated_sprite_2d : AnimatedSprite2D
var _collider_area : Area2D
var is_collected : bool

func _ready() -> void:
	self.add_to_group("Keys")
	
	self.is_collected = false
	self.visible = true
	
	_animated_sprite_2d = $AnimatedSprite2D
	_collider_area = $Area2D
	_animated_sprite_2d.play("default")
	
	_collider_area.body_entered.connect(_handle_body_entered)

func _handle_body_entered(body: Node2D) -> void:
	if (body.name == "Player"):
		_handle_collected()

func _handle_collected() -> void:
	if (!is_collected):
		self.is_collected = true
		_animated_sprite_2d.stop()
		self.visible = false
		MessageBus.key_collected.emit(self)
