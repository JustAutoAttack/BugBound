class_name AssetConstants
extends RefCounted

class ScenePaths:
	
	# --- Base ---
	const CORE_DIR: String = "res://core/scenes/"
	const FEATURES_DIR: String = "res://features/"
	
	# --- Core ---
	const BOOTSPLASH: String = CORE_DIR + "bootsplash/bootsplash.tscn"
	const GAME: String = CORE_DIR + "game/game.tscn"
	const TITLE: String = CORE_DIR + "title/title.tscn"
	const WORLD: String = CORE_DIR + "world/world.tscn"
	
	# --- Features ---

class DataPaths:
	
	# --- Base ---
	const BASE_DIR: String = "res://assets/data/"
	
	# --- Saves ---
	const SAVES_DIR: String = BASE_DIR + "saves/"
	
	const NEW_GAME_SAVE: String = SAVES_DIR + "new_game.tres"
	const DEFAULT_SETTINGS_SAVE: String = SAVES_DIR + "default_settings.tres"
	
	# --- User Saves ---
	const USER_SAVES_DIR: String = "user://saves/"
	const USER_GAME_SAVES_DIR: String = USER_SAVES_DIR + "games/"
	const USER_GAME_AUTOSAVES_DIR: String = USER_SAVES_DIR + "games/autosave/"
	const USER_SETTINGS_SAVE: String = USER_SAVES_DIR + "settings.tres"

class MaterialPaths:
	
	const BASE_DIR: String = "res://assets/materials/"

class AudioPaths:
	
	const AUDIO_VOLUME_COEFFICIENT: float= 1.0
	const BASE_SFX_PATH: String = "res://assets/audio/sfx/"
	const SFX_PATHS: Dictionary[Enums.SFXType, String] = {
		Enums.SFXType.UI_DENIED: BASE_SFX_PATH + "ui_denied.mp3",
		Enums.SFXType.UI_MENU_OPENED: BASE_SFX_PATH + "ui_menu_opened.mp3",
		Enums.SFXType.UI_MENU_CLOSED: BASE_SFX_PATH + "ui_menu_closed.mp3",
		Enums.SFXType.UI_NOTIFICATION: BASE_SFX_PATH + "ui_notification.mp3",
		Enums.SFXType.UI_SELECT_ONE: BASE_SFX_PATH + "ui_select_1.mp3",
		Enums.SFXType.UI_SELECT_TWO: BASE_SFX_PATH + "ui_select_2.mp3",
	}
