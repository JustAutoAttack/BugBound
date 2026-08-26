@tool
class_name AssetProvider
extends RefCounted

# Scenes
static var _bootsplash: PackedScene = null
static var _game: PackedScene = null
static var _title: PackedScene = null
static var _world: PackedScene = null
static var _player: PackedScene = null
static var _bug_unknown: PackedScene = null
static var _bug_scenes: Dictionary[Enums.BugID, PackedScene] = {}
static var _zone_scenes: Dictionary[Enums.ZoneID, PackedScene] = {}

# Data
static var _new_game_save_data: GameSaveData = null
static var _default_settings_save_data: SettingsSaveData = null
static var _bug_definition_data: Dictionary[Enums.BugID, BugDefinitionData]  = {}
static var _zone_definition_data: Dictionary[Enums.ZoneID, ZoneDefinitionData]  = {}

# Materials

static func setup_cache() -> void:
	clear_cache()
	
	# Scenes
	_cache_bootsplash_scene()
	_cache_game_scene()
	_cache_title_scene()
	_cache_world_scene()
	_cache_player_scene()
	_cache_bug_unknown_scene()
	_cache_bug_scenes()
	_cache_zone_scenes()
	
	# Data
	_cache_default_settings_save_data()
	_cache_new_game_save_data()
	_cache_bug_definition_data()
	_cache_zone_definition_data()
	
	# Material

static func clear_cache() -> void:
	# Scenes
	_bootsplash = null
	_game = null
	_title = null
	_world = null
	_player = null
	_bug_unknown = null
	_bug_scenes = {}
	_zone_scenes = {}
	
	# Data
	_new_game_save_data = null
	_default_settings_save_data = null
	_bug_definition_data = {}
	_zone_definition_data = {}
	
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

# --- Player ---
static func _cache_player_scene() -> void:
	_player = AssetLoader.load_packed_scene(
		AssetConstants.ScenePaths.PLAYER, 
	)

static func get_player_scene() -> Player:
	if _player:
		return _player.instantiate() as Player
	return null

# --- Bug Unknown ---
static func _cache_bug_unknown_scene() -> void:
	_bug_unknown = AssetLoader.load_packed_scene(
		AssetConstants.ScenePaths.BUG_UNKNOWN, 
	)

static func get_bug_unknown_scene() -> BugUnknown:
	if _bug_unknown:
		return _bug_unknown.instantiate() as BugUnknown
	return null

# --- Bug ---
static func _cache_bug_scenes() -> void:
	for i in Enums.BugID.values():
		var scene_path: String = AssetConstants.ScenePaths.BUGS_TABLE.get(i)
		if not scene_path:
			LogSystem.log_message(
				"",
				LogEnums.LogLevel.ERROR
			)
			continue
		_bug_scenes[i] = AssetLoader.load_packed_scene(
			scene_path
		) as PackedScene

static func get_bug_scene(id: Enums.BugID) -> PackedScene:
	return _bug_scenes.get(id)

# --- Zone ---
static func _cache_zone_scenes() -> void:
	for i in Enums.ZoneID.values():
		var scene_path: String = AssetConstants.ScenePaths.ZONES_TABLE.get(i)
		if not scene_path:
			LogSystem.log_message(
				"",
				LogEnums.LogLevel.ERROR
			)
			continue
		_bug_scenes[i] = AssetLoader.load_packed_scene(
			scene_path
		) as PackedScene

static func get_zone_scene(id: Enums.ZoneID) -> PackedScene:
	return _zone_scenes.get(id)

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

# --- Bugs ---
static func _cache_bug_definition_data() -> void:
	for i in Enums.BugID.values():
		_bug_definition_data[i] = AssetLoader.load_resource_from_table(
			i, 
			AssetConstants.DataPaths.BUG_DEFINITIONS_TABLE, 
			Enums.BugID.keys(), 
			BugDefinitionData
		) as BugDefinitionData

static func get_bug_definition_data(id: Enums.BugID) -> BugDefinitionData:
	return _bug_definition_data.get(id)

# --- Zones ---
static func _cache_zone_definition_data() -> void:
	for i in Enums.ZoneID.values():
		_zone_definition_data[i] = AssetLoader.load_resource_from_table(
			i, 
			AssetConstants.DataPaths.ZONE_DEFINITIONS_TABLE, 
			Enums.ZoneID.keys(), 
			ZoneDefinitionData
		) as ZoneDefinitionData

static func get_zone_definition_data(id: Enums.ZoneID) -> ZoneDefinitionData:
	return _zone_definition_data.get(id)

# ===
# Materials
# ===
