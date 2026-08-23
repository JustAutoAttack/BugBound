class_name Notifications
extends RefCounted

# ===
# Misc
# ===

# --- Pause ---
class Paused extends Notification:
	func _init() -> void:
		super("Paused")
class Resumed extends Notification:
	func _init() -> void:
		super("Resumed")

# --- Save/Load ---
class LoadingStarted extends Notification:
	func _init() -> void:
		super("LoadingStarted")
class LoadingStopped extends Notification:
	func _init() -> void:
		super("LoadingStopped")
class SavingStarted extends Notification:
	func _init() -> void:
		super("SavingStarted")
class SavingStopped extends Notification:
	func _init() -> void:
		super("SavingStopped")
class GameSaved extends Notification:
	func _init() -> void:
		super("GameSaved")
class GameSaveLoaded extends Notification: 
	
	var data: GameSaveData
	
	func _init(
		p_data: GameSaveData
	) -> void:
		super("GameSaveLoaded")
		data = p_data
class SettingsSaved extends Notification:
	func _init() -> void:
		super("SettingsSaved")

# ===
# Scene
# ===

# --- Main ---
class MainLoaded extends Notification:
	func _init() -> void:
		super("MainLoaded")
class BootsplashLoaded extends Notification:
	func _init() -> void:
		super("BootsplashLoaded")
class GameLoaded extends Notification:
	func _init() -> void:
		super("GameLoaded")

# --- Game ---
class TitleLoaded extends Notification:
	func _init() -> void:
		super("TitleLoaded")
class WorldLoaded extends Notification:
	func _init() -> void:
		super("WorldLoaded")

# ===
# Audio
# ===

# --- Music ---
class MusicPauseUpdated extends Notification:
	
	var is_paused: bool
	
	func _init(
		p_is_paused: bool
	) -> void:
		super("MusicPauseUpdated")
		is_paused = p_is_paused
class CurrentPlaybackTimeUpdated extends Notification:
	
	var value: int
	
	func _init(
		p_value: int
	) -> void:
		super("CurrentPlaybackTimeUpdated")
		value = p_value
class CurrentMusicUpdated extends Notification:
	
	var song_data: SongData
	
	func _init(
		p_song_data: SongData
	) -> void:
		super("CurrentMusicUpdated")
		song_data = p_song_data

# ===
# UI
# ===

class MainMenuActioned extends Notification:
	
	var action: Enums.MainMenuAction
	
	func _init(
		p_action: Enums.MainMenuAction
	) -> void:
		super("MainMenuActioned")
		action = p_action
class SettingsMenuActioned extends Notification:
	
	var action: Enums.SettingsMenuAction
	
	func _init(
		p_action: Enums.SettingsMenuAction
	) -> void:
		super("SettingsMenuActioned")
		action = p_action
class PauseMenuActioned extends Notification:
	
	var action: Enums.PauseMenuAction
	
	func _init(
		p_action: Enums.PauseMenuAction
	) -> void:
		super("PauseMenuActioned")
		action = p_action
