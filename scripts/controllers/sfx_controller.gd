class_name SFXController extends Node

const GLOBAL_SFX_POOL_SIZE : int = 16
const POSITIONAL_SFX_POOL_SIZE : int = 20

enum StealMode { OLDEST, QUIETEST }
const GLOBAL_STEAL_MODE : StealMode = StealMode.OLDEST
const POSITIONAL_STEAL_MODE : StealMode = StealMode.QUIETEST

var sfx_dict : Dictionary = {
	"test": preload("res://assets/audio/sfx/test.mp3")
}

var ducking_levels : Dictionary = {
	"music": -6.0
}

var global_sfx_players : Array[AudioStreamPlayer] = []
var positional_sfx_players : Array[AudioStreamPlayer2D] = []

func _init() -> void:
	_init_global_sfx_pool()
	_init_positional_sfx_pool()

func _init_global_sfx_pool() -> void:
	for i in GLOBAL_SFX_POOL_SIZE:
		var global_sfx_player : AudioStreamPlayer = AudioStreamPlayer.new()
		global_sfx_player.bus = AudioManager.BUS_TAGS.get("default")
		global_sfx_player.autoplay = false
		AudioManager.add_child(global_sfx_player)
		global_sfx_players.append(global_sfx_player)

func _init_positional_sfx_pool() -> void:
	for i in POSITIONAL_SFX_POOL_SIZE:
		var positional_sfx_player := AudioStreamPlayer2D.new()
		positional_sfx_player.bus = AudioManager.BUS_TAGS.get("default")
		positional_sfx_player.autoplay = false
		positional_sfx_player.attenuation = 1.0
		AudioManager.add_child(positional_sfx_player)
		positional_sfx_players.append(positional_sfx_player)

func play_sfx(_sfx_key: String, _sfx_tag: String, _volume_db: float = 0.0, _var_pitch: bool = false) -> void:
	duck_by_tag(_sfx_tag)
	var s : Resource = self.sfx_dict.get(_sfx_key)
	var _bus : String = AudioManager.BUS_TAGS.get(_sfx_tag, AudioManager.BUS_TAGS["default"])
	if not s:
		push_warning("Unknown SFX: " + _sfx_key)
		return
	var global_sfx_player : AudioStreamPlayer = _get_free_or_steal_global_sfx_player(GLOBAL_STEAL_MODE)
	global_sfx_player.bus = _bus
	if _var_pitch:
		global_sfx_player.pitch_scale = randf_range(0.95, 1.05)
		global_sfx_player.volume_db = _volume_db + randf_range(-1, 1)
	else:
		global_sfx_player.pitch_scale = 1.0
		global_sfx_player.volume_db = _volume_db
	global_sfx_player.stream = s
	global_sfx_player.play()

func play_sfx_2d(_sfx_key: String, _pos: Vector2, _sfx_tag: String, _volume_db: float = 0.0, _var_pitch: bool = false) -> void:
	duck_by_tag(_sfx_tag)
	var s : Resource = self.sfx_dict.get(_sfx_key)
	var _bus : String = AudioManager.BUS_TAGS.get(_sfx_tag, AudioManager.BUS_TAGS["default"])
	if not s:
		push_warning("Unknown SFX: " + name)
		return
	var positional_sfx_player : AudioStreamPlayer2D = _get_free_or_steal_positional_sfx_player(POSITIONAL_STEAL_MODE)
	positional_sfx_player.bus = _bus
	if _var_pitch:
		positional_sfx_player.pitch_scale = randf_range(0.95, 1.05)
		positional_sfx_player.volume_db = _volume_db + randf_range(-1, 1)
	else:
		positional_sfx_player.pitch_scale = 1.0
		positional_sfx_player.volume_db = _volume_db
	positional_sfx_player.global_position = _pos
	positional_sfx_player.stream = s
	positional_sfx_player.play()

func _get_free_or_steal_global_sfx_player(steal_mode: StealMode) -> AudioStreamPlayer:
	for global_sfx_player in self.global_sfx_players:
		if not global_sfx_player.playing:
			return global_sfx_player
	match steal_mode:
		StealMode.OLDEST:
			return _steal_oldest_global()
		StealMode.QUIETEST:
			return _steal_quietest_global()
	return self.global_sfx_players[0]

func _get_free_or_steal_positional_sfx_player(steal_mode: StealMode) -> AudioStreamPlayer2D:
	for positional_sfx_player in self.positional_sfx_players:
		if not positional_sfx_player.playing:
			return positional_sfx_player
	match steal_mode:
		StealMode.OLDEST:
			return _steal_oldest_positional()
		StealMode.QUIETEST:
			return _steal_quietest_positional()
	return self.positional_sfx_players[0]

func _steal_oldest_global() -> AudioStreamPlayer:
	var oldest : AudioStreamPlayer = self.global_sfx_players[0]
	var oldest_time : float = oldest.get_playback_position()
	for p in self.global_sfx_players:
		var t : float = p.get_playback_position()
		if t > oldest_time:
			oldest = p
			oldest_time = t
	return oldest

func _steal_quietest_global() -> AudioStreamPlayer:
	var quietest : AudioStreamPlayer = self.global_sfx_players[0]
	var min_volume : float = self.global_sfx_players[0].volume_db
	for p in self.global_sfx_players:
		if p.volume_db < min_volume:
			quietest = p
			min_volume = p.volume_db
	return quietest

func _steal_oldest_positional() -> AudioStreamPlayer2D:
	var oldest : AudioStreamPlayer2D = self.positional_sfx_players[0]
	var oldest_time : float = oldest.get_playback_position()
	for p in self.positional_sfx_players:
		var t : float = p.get_playback_position()
		if t > oldest_time:
			oldest = p
			oldest_time = t
	return oldest

func _steal_quietest_positional() -> AudioStreamPlayer2D:
	var quietest : AudioStreamPlayer2D = self.positional_sfx_players[0]
	var min_volume : float = self.positional_sfx_players[0].volume_db
	for p in self.positional_sfx_players:
		if p.volume_db < min_volume:
			quietest = p
			min_volume = p.volume_db
	return quietest

func duck_by_tag(tag: String):
	var amount = self.ducking_levels.get(tag)
	if amount == null:
		return
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), amount)

func restore_ducking():
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), 0.0)
