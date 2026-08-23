extends Node

# Runtime
var game_version: String = ""
var build_type: String = ""
var full_version_string: String = ""
var did_bootsplash: bool = false
var is_in_world: bool = false

# Context
var ui_context: UIContextData
var settings_context: SettingsContextData
var game_context: GameContextData
var world_context: WorldContextData

# Providers
var save_provider: SaveContextProvider
var ui_provider: UIContextProvider
var settings_provider: SettingsContextProvider
var game_provider: GameContextProvider
var world_provider: WorldContextProvider

# ===
# Built-In
# ===

func _init() -> void:
	AssetProvider.setup_cache()
	_setup_version()
	_setup_context()
	_setup_providers()
	EventSystem.subscribe_to_notification(Notifications.BootsplashLoaded, _handle_bootsplash_loaded)

# ===
# Public
# ===

## For reseting the session as if we just opened the client
func reset() -> void:
	AssetProvider.clear_cache()
	AssetProvider.setup_cache()
	did_bootsplash = false
	is_in_world = false
	_setup_version()
	_setup_context()
	_setup_providers()

## For reseting the gameplay states
func reset_game() -> void:
	world_provider.reset()
	is_in_world = false

# ===
# Private
# ===

func _setup_version() -> void:
	game_version = ProjectSettings.get_setting("application/config/version", "0.0.1")
	build_type = "development" if OS.has_feature("editor") else "release"
	full_version_string = "v%s_%s" % [game_version, build_type]

func _setup_context() -> void:
	ui_context = UIContextData.new()
	settings_context = SettingsContextData.new()
	game_context = GameContextData.new()
	world_context = WorldContextData.new()

func _setup_providers() -> void:
	save_provider = SaveContextProvider.new(
		settings_context,
		world_context,
	)
	
	ui_provider = UIContextProvider.new(
		ui_context
	)
	
	settings_provider = SettingsContextProvider.new(
		settings_context
	)
	
	game_provider = GameContextProvider.new(
		game_context
	)
	
	world_provider = WorldContextProvider.new(
		world_context
	)

# ===
# Events
# ===

func _handle_bootsplash_loaded(_event: Notifications.BootsplashLoaded) -> void:
	did_bootsplash = true
