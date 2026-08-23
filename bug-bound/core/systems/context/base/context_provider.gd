class_name ContextProvider
extends RefCounted  # or whatever it currently extends
## Base class for objects authorized to write to ContextData.
## [br][br]
## Subclasses self-register their script path on first instantiation,
## so authorization checks don't depend on folder naming/location.

static var _authorized_sources: Dictionary = {}

func _init() -> void:
	var script: Script = get_script() as Script
	if is_instance_valid(script):
		_authorized_sources[script.resource_path] = true

## Checks whether a given script path belongs to a registered provider.
static func is_authorized_source(source_path: String) -> bool:
	return _authorized_sources.has(source_path)
