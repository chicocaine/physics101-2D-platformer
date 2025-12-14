extends Node2D

var _animated_sprite : AnimatedSprite2D
var _level_exit_area : Area2D

@export var key_type_requirement : Util.KeyType
@export var key_count_requirement : int

var is_unlocked : bool
var is_open : bool
var is_player_in_exit_area : bool
var can_play_animation : bool

@export var door_pair : Node2D

func _ready() -> void:
	self.add_to_group("LevelExits")
	_animated_sprite = $AnimatedSprite2D
	_level_exit_area = $LevelExitArea
	
	if (_animated_sprite):
		_animated_sprite.play("close")
		self.can_play_animation = false
		await _animated_sprite.animation_finished
		self.can_play_animation = true
	
	if (_level_exit_area):
		_level_exit_area.set_collision_layer_value(1, false)
		_level_exit_area.set_collision_mask_value(1, false)
		_level_exit_area.set_collision_mask_value(4, true)
	
	self.is_open = false
	_check_unlock_requirement()
	
	_level_exit_area.body_entered.connect(_exit_area_body_entered)
	_level_exit_area.body_exited.connect(_exit_area_body_exited)
	MessageBus.key_collected.connect(_handle_key_collected)
	MessageBus.up_is_pressed.connect(_handle_up_action_pressed)

func _handle_up_action_pressed() -> void:
	if (is_player_in_exit_area and self.is_unlocked):
		Global.player.visible = false
		Global.player.global_position = self.door_pair.global_position
		Global.player.visible = true

func _close_door() -> void:
	if (self.is_open and self.can_play_animation):
		_animated_sprite.play("close")
		self.can_play_animation = false
		await _animated_sprite.animation_finished
		self.can_play_animation = true
		self.is_open = false

func _open_door() -> void:
	if (!self.is_open and self.can_play_animation):
		_animated_sprite.play("open")
		self.can_play_animation = false
		await _animated_sprite.animation_finished
		self.can_play_animation = true
		self.is_open = true

func _exit_area_body_entered(body: Node2D):
	if (body.name == "Player"):
		if (self.is_unlocked and !self.is_open):
			_open_door()
		self.is_player_in_exit_area = true

func _exit_area_body_exited(body: Node2D):
	if (body.name == "Player"):
		if (self.is_unlocked and self.is_open):
			_close_door()
		self.is_player_in_exit_area = false

func _handle_key_collected(key_type: Util.KeyType):
	if (key_type == self.key_type_requirement):
		self.key_count_requirement -= 1
		_check_unlock_requirement()

func _check_unlock_requirement():
	self.is_unlocked = true if (self.key_count_requirement == 0) else false
