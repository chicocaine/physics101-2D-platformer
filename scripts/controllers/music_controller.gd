class_name MusicController extends Node

var current_music : AudioStream
var music_player : AudioStreamPlayer

var music_dict : Dictionary = {
	"test" = preload("res://assets/audio/music/test.mp3")
}

func _init() -> void:
	self.music_player = AudioStreamPlayer.new()
	self.music_player.bus = AudioManager.BUS_TAGS.get("music")
	AudioManager.add_child(self.music_player)

func play_music(_music_key: String, _fade_time := 1.0) -> void:
	var _stream : Resource = self.music_dict.get(_music_key)
	if not _stream:
		push_warning("Unknown Music: " + _music_key)
		return
	if self.current_music == _stream:
		return
	self.current_music = _stream
	if _fade_time > 0:
		_fade_out_in(_stream, _fade_time)
	else:
		self.music_player.stream = _stream
		self.music_player.play()

func play_music_by_stream(_stream: AudioStream, _fade_time: float) -> void:
	if self.current_music == _stream:
		return
	self.current_music = _stream
	if _fade_time > 0:
		_fade_out_in(_stream, _fade_time)
	else:
		self.music_player.stream = _stream
		self.music_player.play()

func play_music_by_name(_music_file_name: String, _fade_time := 1.0) -> void:
	var path : String = "res://assets/audio/music/%s.ogg" % _music_file_name
	if ResourceLoader.exists(path):
		play_music_by_stream(load(path), _fade_time)
	else:
		push_warning("Missing music: " + path)

func _fade_out_in(new_stream: AudioStream, duration: float) -> void:
	var tween = create_tween()
	tween.tween_property(music_player, "volume_db", -40, duration/2)
	tween.tween_callback(func():
		music_player.stream = new_stream
		music_player.play()
	)
	tween.tween_property(music_player, "volume_db", 0, duration/2)
