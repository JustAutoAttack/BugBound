class_name WorldContextData
extends ContextData

# --- Time ---
signal time_updated(value: float)
var _time: float
var time: float:
	get: return _time
	set(value):
		if _authorize_write():
			_time = value
			time_updated.emit(value)

signal cpu_time_updated(value: float)
var _cpu_time: float
var cpu_time: float:
	get: return _cpu_time
	set(value):
		if _authorize_write():
			_cpu_time = value
			cpu_time_updated.emit(value)

# ===
# Built-In
# ===

func _init() -> void:
	reset()

func reset() -> void:
	_time = 0.0
	_cpu_time = 0.0
