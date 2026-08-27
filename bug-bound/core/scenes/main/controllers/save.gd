class_name MainSaveController
extends Node

var settings_data: SettingsSaveData
var game_data: GameSaveData

# ===
# Built-In
# ===

func _ready() -> void:
	settings_data = ContextSystem.save_provider.load_settings(
		AssetConstants.DataPaths.USER_SETTINGS_SAVE
	)

	_subscribe_events()

func _exit_tree() -> void:
	_unsubscribe_events()

# ===
# Private
# ===

func _subscribe_events() -> void:
	# Commands
	EventSystem.subscribe_to_command(Commands.SaveSettings, _handle_save_settings)
	EventSystem.subscribe_to_command(Commands.SaveGame, _handle_save_game)
	
	# Notifications
	EventSystem.subscribe_to_notification(Notifications.GameSaveLoaded, _handle_game_loaded)

func _unsubscribe_events() -> void:
	EventSystem.unsubscribe_all_for_owner(self)

# ===
# Handlers
# ===

func _handle_save_settings(_command: Commands.SaveSettings) -> void:
	LogSystem.log_message(
		"Saving settings",
		LogEnums.LogLevel.DEBUG
	)
	ContextSystem.save_provider.save_settings(settings_data)

func _handle_save_game(_command: Commands.SaveGame) -> void:
	LogSystem.log_message(
		"Saving game",
		LogEnums.LogLevel.DEBUG
	)
	EventSystem.broadcast(
		Notifications.SavingStarted.new()
	)
	ContextSystem.save_provider.save_game(
		game_data, 
		true
	)
	
	# HACK: This is mostly just UX for the UI
	get_tree().create_timer(3.0).timeout.connect(
		func():
			EventSystem.broadcast(
				Notifications.SavingStopped.new()
			)
	)

func _handle_game_loaded(event: Notifications.GameSaveLoaded) -> void:
	game_data = event.data.duplicate(true)
