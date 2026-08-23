@tool
class_name AssetProvider
extends RefCounted

# Scenes
static var _bootsplash: PackedScene = null
static var _game: PackedScene = null
static var _title: PackedScene = null
static var _world: PackedScene = null

# Data
static var _new_game_save_data: GameSaveData = null
static var _default_settings_save_data: SettingsSaveData = null

# Materials

static func setup_cache() -> void:
	clear_cache()
	
	# Scenes
	_cache_bootsplash_scene()
	_cache_game_scene()
	_cache_title_scene()
	_cache_world_scene()
	
	# Data
	_cache_default_settings_save_data()
	_cache_new_game_save_data()
	
	# Material

static func clear_cache() -> void:
	# Scenes
	_bootsplash = null
	_game = null
	_title = null
	_world = null
	
	# Data
	_new_game_save_data = null
	_default_settings_save_data = null
	
	# Materials

# ===
# Scenes
# ===

# --- Bootsplash ---
static func _cache_bootsplash_scene() -> void:
	_bootsplash = AssetLoader.load_packed_scene(
		AssetConstants.ScenePaths.BOOTSPLASH, 
	)

static func get_bootsplash_scene() -> Bootsplash:
	if _bootsplash:
		return _bootsplash.instantiate() as Bootsplash
	return null

# --- Game ---
static func _cache_game_scene() -> void:
	_game = AssetLoader.load_packed_scene(
		AssetConstants.ScenePaths.GAME, 
	)

static func get_game_scene() -> Game:
	if _game:
		return _game.instantiate() as Game
	return null

# --- Title ---
static func _cache_title_scene() -> void:
	_title = AssetLoader.load_packed_scene(
		AssetConstants.ScenePaths.TITLE, 
	)

static func get_title_scene() -> Title:
	if _title:
		return _title.instantiate() as Title
	return null

# --- World ---
static func _cache_world_scene() -> void:
	_world = AssetLoader.load_packed_scene(
		AssetConstants.ScenePaths.WORLD, 
	)

static func get_world_scene() -> World:
	if _world:
		return _world.instantiate() as World
	return null

# ===
# Data 
# ===

# --- User Settings Save ---
static func get_settings_save_data() -> SettingsSaveData:
	return AssetLoader.load_resource(
		AssetConstants.DataPaths.USER_SETTINGS_SAVE, 
		SettingsSaveData
	) as SettingsSaveData

# --- Default Settings Save ---
static func _cache_default_settings_save_data() -> void:
	_default_settings_save_data = AssetLoader.load_resource(
		AssetConstants.DataPaths.DEFAULT_SETTINGS_SAVE, 
		SettingsSaveData
	) as SettingsSaveData

static func get_default_settings_save_data() -> SettingsSaveData:
	return _default_settings_save_data

# --- New Game Save ---
static func _cache_new_game_save_data() -> void:
	_new_game_save_data = AssetLoader.load_resource(
		AssetConstants.DataPaths.NEW_GAME_SAVE, 
		GameSaveData
	) as GameSaveData

static func get_new_game_save_data() -> GameSaveData:
	return _new_game_save_data

# ===
# Materials
# ===
