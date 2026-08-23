class_name ContextData
extends RefCounted

# ===
# Public
# ===

func reset() -> void:
	assert(
		false, 
		"Reset method not implemented"
	)

# ===
# Private
# ===

func _authorize_write() -> bool:
	# skip_count 1 accounts for StackUtils' own frame, landing on the
	# same target frame the previous direct get_stack()[2] pointed to.
	var caller_frame: Dictionary = StackUtils.get_caller_frame(1)
	if caller_frame.is_empty():
		return false
	
	var caller: Object = caller_frame.get("object") as Object
	
	# Direct check
	if (
		caller is ContextProvider or 
		caller == self
	):
		return true
	
	# Fallback: caller object is null (e.g. called before full construction,
	# or from a context that doesn't retain an object ref) — verify against
	# the registry of scripts that ContextProvider subclasses self-register,
	# rather than trusting where the file happens to live on disk.
	var source_path: String = caller_frame.get("source", "") as String
	if (
		not source_path.is_empty() and 
		ContextProvider.is_authorized_source(source_path)
	):
		return true
	
	LogSystem.log_message(
		"Unauthorized write by {0}".format([str(caller)]),
		LogEnums.LogLevel.ERROR
	)
	return false
