class_name SaveContextProvider
extends ContextProvider

var settings_context: SettingsContextData
var world_context: WorldContextData

# ===
# Built-In
# ===

func _init(
	p_settings: SettingsContextData,
	p_world: WorldContextData,
) -> void:
	super._init()
	settings_context = p_settings
	world_context = p_world
	ensure_settings_file_exists()

# ===
# Public
# ===

# --- Game ---
func save_game(data: GameSaveData, is_autosave: bool) -> void:
	# Update
	_game_to_data(data)
	
	# Write
	var dir: String = AssetConstants.DataPaths.USER_GAME_AUTOSAVES_DIR if is_autosave else AssetConstants.DataPaths.USER_GAME_SAVES_DIR
	if not DirAccess.dir_exists_absolute(dir):
		DirAccess.make_dir_recursive_absolute(dir)
	var filename: String = _current_timestamp() + ".tres"
	var path: String = dir + filename
	var error: int = ResourceSaver.save(data, path)
	
	# Notify
	if error != OK:
		_error_failed_to_save(error)

func load_new_game() -> GameSaveData:
	return load_game(AssetConstants.DataPaths.NEW_GAME_SAVE)

func load_game(path: String) -> GameSaveData:
	# Read
	var data: GameSaveData = AssetLoader.load_resource(
		path, 
		GameSaveData
	) as GameSaveData
	
	# Contingency
	if not data:
		_warn_no_save_at_path(path)
		data = AssetProvider.get_new_game_save_data()
		_game_to_data(data)
		save_game(data, false)
	
	# Update
	_data_to_game(data)
	return data
	
# --- Settings ---
func ensure_settings_file_exists() -> void:
	if FileAccess.file_exists(AssetConstants.DataPaths.USER_SETTINGS_SAVE):
		return

	var data: SettingsSaveData = AssetProvider.get_default_settings_save_data()
	_settings_to_data(data)

	var dir: String = AssetConstants.DataPaths.USER_SETTINGS_SAVE.get_base_dir()
	if not DirAccess.dir_exists_absolute(dir):
		DirAccess.make_dir_recursive_absolute(dir)

	var error: int = ResourceSaver.save(
		data, 
		AssetConstants.DataPaths.USER_SETTINGS_SAVE
	)
	if error != OK:
		LogSystem.log_message(
			"Failed to create default settings file.",
			LogEnums.LogLevel.ERROR
		)

func save_settings(data: SettingsSaveData) -> void:
	# Update
	_settings_to_data(data)

	# Write
	var error: int = ResourceSaver.save(
		data,
		AssetConstants.DataPaths.USER_SETTINGS_SAVE
	)
	
	# Notify
	if error != OK:
		_error_failed_to_save(error)

func load_settings(path: String) -> SettingsSaveData:
	var data: SettingsSaveData = AssetLoader.load_resource(
		path,
		SettingsSaveData
	) as SettingsSaveData

	if not data:
		_warn_no_save_at_path(path)
		data = AssetProvider.get_default_settings_save_data()
		_settings_to_data(data)
		save_settings(data)

	_data_to_settings(data)
	return data

# ===
# Private
# ===

func _game_to_data(data: GameSaveData) -> void:
	# --- World ---
	data.world_time = world_context.time
	data.world_cpu_time = world_context.cpu_time

func _data_to_game(data: GameSaveData) -> void:
	# --- World ---
	world_context.time = data.world_time
	world_context.cpu_time = data.world_cpu_time

func _settings_to_data(data: SettingsSaveData) -> void:
	# Audio
	data.master_volume = settings_context.master_volume
	data.music_volume = settings_context.music_volume
	data.sfx_volume = settings_context.sfx_volume
	data.muted_buses = settings_context.muted_buses
	
	# Controls
	data.mouse_sensitivity_x = settings_context.mouse_sensitivity.x
	data.mouse_sensitivity_y = settings_context.mouse_sensitivity.y
	data.controller_sensitivity_x = settings_context.controller_sensitivity.x
	data.controller_sensitivity_y = settings_context.controller_sensitivity.y

	# Gameplay

func _data_to_settings(data: SettingsSaveData) -> void:
	# Audio
	settings_context.master_volume = data.master_volume
	settings_context.music_volume = data.music_volume
	settings_context.sfx_volume = data.sfx_volume
	settings_context.muted_buses = data.muted_buses
	
	# Controls
	settings_context.mouse_sensitivity = Vector2(
		data.mouse_sensitivity_x, 
		data.mouse_sensitivity_y
	)
	settings_context.controller_sensitivity = Vector2(
		data.controller_sensitivity_x, 
		data.controller_sensitivity_y
	)
	
	# Gameplay

func _current_timestamp() -> String:
	var dt: Dictionary = Time.get_datetime_dict_from_system(true)
	
	return (
		"%04d%02d%02d_%02d%02d%02d_%03d"
		% [
			dt.year,
			dt.month,
			dt.day,
			dt.hour,
			dt.minute,
			dt.second,
			Time.get_ticks_msec() % 1000
		]
	)

func _warn_no_save_at_path(path: String) -> void:
	LogSystem.log_message(
		"No save data found at path ({0}). Creating new entry.".format([path]),
		LogEnums.LogLevel.WARN
	)

func _error_failed_to_save(error: int) -> void:
	LogSystem.log_message(
		"Failed to save. \nError: {0}".format([error_string(error)]),
		LogEnums.LogLevel.ERROR
	)

func _error_failed_to_load(path: String) -> void:
	LogSystem.log_message(
		"Failed to load. Path: {0}".format([path]),
		LogEnums.LogLevel.ERROR
	)
