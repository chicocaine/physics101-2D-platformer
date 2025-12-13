class_name MainMenuController extends Control

@onready var play_btn : Button = $PanelContainer/VBoxContainer/PlayButton
@onready var lab_btn : Button = $PanelContainer/VBoxContainer/LaboratoryButton
@onready var settings_btn : Button = $PanelContainer/VBoxContainer/SettingsButton
@onready var quit_btn : Button = $PanelContainer/VBoxContainer/QuitButton

var is_active : bool

func _ready() -> void:
	self.play_btn.pressed.connect(_handle_play_btn_pressed)
	self.lab_btn.pressed.connect(_handle_lab_btn_pressed)
	self.settings_btn.pressed.connect(_handle_settings_btn_pressed)
	self.quit_btn.pressed.connect(_handle_quit_btn_pressed)

func _handle_play_btn_pressed() -> void:
	Global.gui_manager.hide_gui(self)
	self.is_active = false
	MessageBus.play_game_requested.emit()

func _handle_lab_btn_pressed() -> void:
	Global.gui_manager.hide_gui(self)
	self.is_active = false
	MessageBus.lab_requested.emit()

func _handle_settings_btn_pressed() -> void:
	Global.gui_manager.hide_gui(self)
	self.is_active = false
	MessageBus.settings_requested.emit()

func _handle_quit_btn_pressed() -> void:
	MessageBus.quit_requested.emit()
