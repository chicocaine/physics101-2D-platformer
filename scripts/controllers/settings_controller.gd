class_name SettingsController extends Control

@onready var sfx_toggle : CheckButton = $PanelContainer/VBoxContainer/SFXToggle
@onready var music_toggle : CheckButton	= $PanelContainer/VBoxContainer/MusicToggle
@onready var back_btn : Button = $PanelContainer/VBoxContainer/BackButton

var is_active : bool

func _ready() -> void:
	self.is_active = false
	self.sfx_toggle.toggled.connect(_handle_sfx_toggled)
	self.music_toggle.toggled.connect(_handle_music_toggled)
	self.back_btn.pressed.connect(_handle_back_btn_pressed)

func _handle_sfx_toggled() -> void:
	pass

func _handle_music_toggled() -> void:
	pass

func _handle_back_btn_pressed() -> void:
	MessageBus.back_gui_requested.emit()
