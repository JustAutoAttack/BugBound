# Game
extends MainState

# ===
# Built-In
# ===

func enter(_prev_state_path: String, _data: Object) -> void:
	LogSystem.log_message(
		"Enter GAME", 
		LogEnums.LogLevel.DEBUG
	)
	
	_subscribe_events()
	EventSystem.dispatch_command(
		Commands.LoadGame.new()
	)

func exit() -> void:
	LogSystem.log_message(
		"Exit GAME", 
		LogEnums.LogLevel.DEBUG
	)
	_unsubscribe_events()

func _subscribe_events() -> void:
	EventSystem.subscribe_to_notification(Notifications.GameLoaded, _handle_game_loaded)
	EventSystem.subscribe_to_notification(Notifications.SettingsMenuActioned, _handle_ui_settings_menu)

func _unsubscribe_events() -> void:
	EventSystem.unsubscribe_all_for_owner(self)

# ===
# Events
# ===

func _handle_game_loaded(_event: Notifications.GameLoaded) -> void:
	LogSystem.log_message(
		"Game Loaded", 
		LogEnums.LogLevel.DEBUG
	)

func _handle_ui_settings_menu(event: Notifications.SettingsMenuActioned) -> void:
	match event.action:
		Enums.SettingsMenuAction.SAVE:
			EventSystem.dispatch_command(
				Commands.SaveSettings.new()
			)
