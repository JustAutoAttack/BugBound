class_name MainSceneController
extends SceneController

# ===
# Built-In
# ===

func _subscribe_events() -> void:
	EventSystem.subscribe_to_command(Commands.LoadBootsplash, _handle_main_load_bootsplash)
	EventSystem.subscribe_to_command(Commands.LoadGame, _handle_main_load_game)

# ===
# Events
# ===

func _handle_main_load_bootsplash(_event: Commands.LoadBootsplash) -> void:
	_replace_current(AssetProvider.get_bootsplash_scene())

func _handle_main_load_game(_event: Commands.LoadGame) -> void:
	_replace_current(AssetProvider.get_game_scene())
