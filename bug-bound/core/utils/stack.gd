class_name StackUtils
extends RefCounted
## Centralized stack introspection utilities.
## [br][br]
## Used by systems (e.g. the Logger) that need to identify a calling
## object/file without duplicating stack-walking logic.

## Returns the stack starting just past this function's own frame.
## [br][br]
## - [param skip_count]: Additional frames to skip beyond the immediate
##   caller of this function (use this to skip past wrapper functions
##   in your own call chain).
static func get_stack_trace(skip_count: int = 0) -> Array[Dictionary]:
	var stack: Array[Dictionary] = get_stack()
	var start_index: int = 1 + skip_count
	return stack.slice(start_index) if start_index < stack.size() else []

## Returns the frame at a specific depth, skipping internal frames.
static func get_caller_frame(skip_count: int = 0) -> Dictionary:
	var stack: Array[Dictionary] = get_stack()
	var target_index: int = 2 + skip_count
	return stack[target_index] if target_index < stack.size() else {}

## Gets the object instance that called the current function.
static func get_caller(skip_count: int = 0) -> Object:
	return get_caller_frame(skip_count).get("object") as Object

## Gets the file path of the caller.
static func get_caller_source(skip_count: int = 0) -> String:
	return get_caller_frame(skip_count).get("source", "") as String
