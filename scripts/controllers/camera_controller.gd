class_name CameraController extends Camera2D

# note: will add clamping in the future

var follow_speed : float = 8.0
var _target_node : Node2D
var _lock_target: Node2D

var zoom_speed : float = 6.0
var player_offset : Vector2 = Vector2(0.0, -20.0)
var default_zoom : Vector2 = Vector2(2.0, 2.0)
var _zoom_target : Vector2

var shake_time : float = 0.0
var shake_strength : float = 0.0

var _level_size : Vector2

var follow_target : bool = false
var cam_process_callback : Util.CamProcessCallback = Util.CamProcessCallback.IDLE

func _ready() -> void:
	Global.camera_controller = self
	self.zoom = default_zoom
	self._zoom_target = default_zoom
	self.make_current()

func _process(delta: float) -> void:
	if (follow_target and cam_process_callback == Util.CamProcessCallback.IDLE):
		_update_follow(delta)
		_update_zoom(delta)
	if (shake_time > 0 and cam_process_callback == Util.CamProcessCallback.IDLE):
		_apply_screen_shake(delta)	

func _physics_process(delta: float) -> void:
	if (follow_target and cam_process_callback == Util.CamProcessCallback.PHYSICS):
		_update_follow(delta)
		_update_zoom(delta)
	if (shake_time > 0 and cam_process_callback == Util.CamProcessCallback.PHYSICS):
		_apply_screen_shake(delta)

func _update_follow(delta : float) -> void:
	var target_pos : Vector2 = _target_node.global_position + player_offset
	self.global_position = self.global_position.lerp(target_pos, delta * follow_speed)

func set_target(_target : Node2D) -> void:
	self._target_node = _target

func _update_zoom(delta: float) -> void:
	self.zoom = self.zoom.lerp(_zoom_target, delta * zoom_speed)

func set_zoom_value(value: Vector2) -> void:
	_zoom_target = value

func reset_zoom_value() -> void:
	_zoom_target = default_zoom

func shake(duration: float, strength: float = 16.0):
	shake_time = duration
	shake_strength = strength

func _apply_screen_shake(delta):
	shake_time -= delta
	var _offset = Vector2(
		randf_range(-shake_strength, shake_strength),
		randf_range(-shake_strength, shake_strength)
	)
	self.offset = _offset
	
	if shake_time <= 0:
		self.offset = player_offset

func focus_on(node: Node2D, speed := 3.0):
	_lock_target = node
	follow_speed = speed
	_target_node = node

func release_focus():
	_lock_target = null
	_target_node = null

func _set_level_size() -> void:
	var tilemap : TileMapLayer = Global.current_level_2D.get_node("Tiles/TileMapLayer")
	var rect : Rect2i = tilemap.get_used_rect()
	var tile_size = tilemap.tile_set.tile_size
	
	_level_size = rect.size * tile_size
