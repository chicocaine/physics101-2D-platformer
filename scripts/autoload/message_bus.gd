extends Node

@warning_ignore_start("unused_signal")
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

# main_menu
signal play_game_requested
signal lab_requested
signal settings_requested
signal quit_requested

# gui_signals
signal back_gui_requested
