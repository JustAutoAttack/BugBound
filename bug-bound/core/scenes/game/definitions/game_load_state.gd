class_name GameLoadStateData
extends RefCounted

var target_state: GameState.StateName
var is_new_game: bool
var save_game_file_path: String

func _init(
	p_target_state: GameState.StateName, 
	p_is_new_game: bool,
	p_save_game_file_path: String
):
	target_state = p_target_state
	is_new_game = p_is_new_game
	save_game_file_path = p_save_game_file_path
