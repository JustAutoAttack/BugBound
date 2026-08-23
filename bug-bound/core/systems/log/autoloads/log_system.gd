## Utility class for centralized application logging.
## [br][br]
## Provides formatted console output with timestamps, severity levels,
## and automatic caller identification via stack introspection.
extends Node

# ===
# Built-In
# ===
func _enter_tree() -> void:
	log_message(
		"Logger Online", 
		LogEnums.LogLevel.INFO
	)

func _exit_tree() -> void:
	log_message(
		"Logger Offline", 
		LogEnums.LogLevel.INFO
	)

# ===
# Public
# ===
## Logs a message to the console.
## [br][br]
## - [param message]: Text content to log.
## - [param level]: Severity level (using [code]LogEnums.LogLevel[/code]).
func log_message(
	message: String, 
	level: LogEnums.LogLevel
) -> void:
	var time: String = Time.get_time_string_from_system()
	var level_str: String = LogEnums.LogLevel.keys()[level]
	var tag: String = _resolve_tag()
		
	var output: String = "[{0}] [{1}] [{2}]: {3}".format([time, level_str, tag, message])
	
	match level:
		LogEnums.LogLevel.DEBUG: print_debug(output)
		LogEnums.LogLevel.INFO: print(output)
		LogEnums.LogLevel.WARN: push_warning(output)
		LogEnums.LogLevel.ERROR: push_error(output)

# ===
# Private
# ===
## Resolves the tag for the log message via [StackUtils].
func _resolve_tag() -> String:
	# Skip 2: _resolve_tag's own frame and log_message's frame,
	# landing on whatever code actually called log_message.
	var frames: Array[Dictionary] = StackUtils.get_stack_trace(2)
	
	for frame: Dictionary in frames:
		var obj: Object = frame.get("object") as Object
		
		# Direct: Check for object in frame
		if is_instance_valid(obj) and obj != self:
			var tag: String = _get_tag_from_object(obj)
			if tag != "Unknown" and tag != "RefCounted":
				return tag
		
		# Fallback: Extract class name from the file path
		var source: String = frame.get("source", "") as String
		if not source.is_empty():
			var filename: String = source.get_file().get_basename()
			var ignored_files: Array[String] = ["log_system", "event_bus", "command_bus"]
			if not filename in ignored_files:
				return filename
			
	return "Unknown"

## Extracts the class name from an object.
func _get_tag_from_object(obj: Object) -> String:
	var script: Script = obj.get_script() as Script
	if is_instance_valid(script):
		var script_name: String = script.get_global_name()
		if not script_name.is_empty():
			return script_name
	return obj.get_class()
