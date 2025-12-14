class_name PauseMenuController extends Control

@onready var resume_btn : Button = $PanelContainer/VBoxContainer/ResumeButton
@onready var restart_btn : Button = $PanelContainer/VBoxContainer/RestartButton
@onready var settings_btn : Button = $PanelContainer/VBoxContainer/SettingsButton
@onready var main_menu_btn : Button = $PanelContainer/VBoxContainer/MainMenuButton

func _ready() -> void:
	self.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	self.resume_btn.pressed.connect(_handle_resume_btn_pressed)
	self.restart_btn.pressed.connect(_handle_restart_btn_pressed)
	self.settings_btn.pressed.connect(_handle_settings_btn_pressed)
	self.main_menu_btn.pressed.connect(_handle_main_menu_btn_pressed)

func _handle_resume_btn_pressed() -> void:
	MessageBus.resume_game_requested.emit()

func _handle_restart_btn_pressed() -> void:
	MessageBus.restart_level_requested.emit()

func _handle_settings_btn_pressed() -> void:
	MessageBus.settings_requested.emit()

func _handle_main_menu_btn_pressed() -> void:
	MessageBus.main_menu_requested.emit()
