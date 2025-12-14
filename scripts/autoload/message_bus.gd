extends Node

func _ready() -> void:
	self.process_mode = Node.PROCESS_MODE_ALWAYS

@warning_ignore_start("unused_signal")

# game states
signal level_restarted
signal level_switched

# keys
signal key_collected

# level_exits
signal player_next_level_attempt

# killzone
signal player_entered_kill_zone

# interactions
signal closest_player_updated

# input_signals
signal up_is_pressed
signal interact_is_pressed
signal escape_is_pressed

# gui_signals
signal play_game_requested
signal lab_requested
signal settings_requested
signal quit_requested
signal back_gui_requested
signal resume_game_requested
signal main_menu_requested
signal restart_level_requested
