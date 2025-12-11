extends Node

var music_controller : MusicController
var sfx_controller : SFXController

const BUS_TAGS : Dictionary = {
	"music" : "Music",
	"ui" : "UI",
	"player" : "Player",
	"ambient" : "Ambient",
	"environment" : "Environment", 
	"default" : "SFX",
}

func _ready() -> void:
	self.music_controller = MusicController.new()
	self.sfx_controller = SFXController.new()

func set_bus_volume(bus: String, db: float):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus), db)

func get_bus_volume(bus: String) -> float:
	return AudioServer.get_bus_volume_db(AudioServer.get_bus_index(bus))

func save_settings():
	var cfg = ConfigFile.new()
	for tag in self.BUS_TAGS.values():
		var db = get_bus_volume(tag)
		cfg.set_value("audio", tag, db)

	cfg.save("user://settings.cfg")

func load_settings():
	var cfg = ConfigFile.new()
	if cfg.load("user://settings.cfg") != OK: return
	for tag in self.BUS_TAGS.values():
		var db = cfg.get_value("audio", tag, get_bus_volume(tag))
		set_bus_volume(tag, db)
