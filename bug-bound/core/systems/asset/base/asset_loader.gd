## Utility class for robust resource loading and scene instantiation.
class_name AssetLoader
extends RefCounted

## Loads a resource and validates its type.
## [br][br]
## - [param path]: File path to the resource.
## [br][br]
## - [param expected_type]: Object type the resource must match.
static func load_resource(
	path: String, 
	expected_type: Object
) -> Resource:
	if path.is_empty():
		_warn_no_path(expected_type)
		return null
	
	var data: Variant = ResourceLoader.load(
		path, 
		"", 
		ResourceLoader.CACHE_MODE_REPLACE
	)
	
	if not is_instance_of(data, expected_type):
		_error_type_mismatch(path, expected_type)
		return null
		
	return data

## Fetches a path from a dictionary with validation.
## [br][br]
## - [param key]: Index to look up.
## - [param table]: Dictionary mapping indices to paths.
## - [param enum_keys]: Array of enum names for logging context.
static func get_path_from_table(
	key: int, 
	table: Dictionary, 
	enum_keys: Array
) -> String:
	var path: String = table.get(key, "")
	if path.is_empty():
		_warn_no_path(enum_keys[key])
		return ""
	
	return path

## Loads a resource based on a key index from a dictionary.
## [br][br]
## - [param key]: Index to look up.
## [br][br]
## - [param table]: Dictionary mapping indices to paths.
## [br][br]
## - [param enum_keys]: Array of enum names for logging context.
## [br][br]
## - [param expected_type]: Object type the resource must match.
static func load_resource_from_table(
	key: int, 
	table: Dictionary, 
	enum_keys: Array, 
	expected_type: GDScript
) -> Resource:
	var path: String = get_path_from_table(key, table, enum_keys)
	if path.is_empty(): 
		return null
	
	return load_resource(path, expected_type)

## Loads a [PackedScene] directly without instantiating it.
## [br][br]
## - [param path]: File path to the scene.
static func load_packed_scene(path: String) -> PackedScene:
	var packed_scene: PackedScene = ResourceLoader.load(path) as PackedScene
	if not packed_scene:
		_error_failed_to_load_scene(path)
		return null
	
	return packed_scene

## Instantiates a scene directly from a file path.
## [br][br]
## - [param path]: File path to the scene.
## [br][br]
## - [param expected_base_class]: Script the scene must inherit from.
static func load_scene(
	path: String, 
	expected_base_class: Script
) -> Node:
	var packed_scene: PackedScene = load_resource(
		path, 
		PackedScene
	) as PackedScene
	if not packed_scene: 
		return null
	
	var instance: Node = packed_scene.instantiate()
	
	if not is_instance_of(instance, expected_base_class):
		_error_invalid_base_class(path)
		instance.queue_free()
		return null
		
	return instance

## Instantiates a scene from a dictionary, ensuring type safety.
## [br][br]
## - [param key]: Index to look up.
## [br][br]
## - [param table]: Dictionary mapping indices to paths.
## [br][br]
## - [param enum_keys]: Array of enum names for logging context.
## [br][br]
## - [param expected_base_class]: Script the scene must inherit from.
static func load_scene_from_table(
	key: int, 
	table: Dictionary, 
	enum_keys: Array, 
	expected_base_class: Script
) -> Node:
	var path: String = get_path_from_table(key, table, enum_keys)
	if path.is_empty(): 
		return null
	
	return load_scene(path, expected_base_class)

# ===
# Private
# ===

static func _warn_no_path(type_context: Variant) -> void:
	LogSystem.log_message(
		"No path defined for type: {0}".format([type_context]),
		LogEnums.LogLevel.WARN
	)

static func _error_type_mismatch(path: String, expected_type: Variant) -> void:
	LogSystem.log_message(
		"Type mismatch at '{0}'. Expected {1}.".format([path, expected_type]),
		LogEnums.LogLevel.ERROR
	)

static func _error_failed_to_load_scene(path: String) -> void:
	LogSystem.log_message(
		"Failed to load scene at: {0}".format([path]),
		LogEnums.LogLevel.ERROR
	)

static func _error_invalid_base_class(path: String) -> void:
	LogSystem.log_message(
		"Scene at '{0}' does not inherit from expected class.".format([path]),
		LogEnums.LogLevel.ERROR
	)
