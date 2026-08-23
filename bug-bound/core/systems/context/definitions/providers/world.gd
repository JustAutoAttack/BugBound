class_name WorldContextProvider
extends ContextProvider

var context: WorldContextData

# ===
# Built-In
# ===

func _init(
	p_context: WorldContextData
) -> void:
	super._init()
	context = p_context

func reset() -> void:
	context.reset()

# ===
# Public
# ===

func set_time(value: float) -> void:
	context.time = value

func set_cpu_time(value: float) -> void:
	context.cpu_time = value
