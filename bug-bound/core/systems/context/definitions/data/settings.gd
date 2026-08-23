class_name SettingsContextData
extends ContextData

# --- Audio ---
signal master_volume_updated(value: float)
var _master_volume: float
var master_volume: float:
	get: return _master_volume
	set(value):
		if _authorize_write():
			_master_volume = value
			master_volume_updated.emit(value)

signal music_volume_updated(value: float)
var _music_volume: float
var music_volume: float:
	get: return _music_volume
	set(value):
		if _authorize_write():
			_music_volume = value
			music_volume_updated.emit(value)

signal sfx_volume_updated(value: float)
var _sfx_volume: float
var sfx_volume: float:
	get: return _sfx_volume
	set(value):
		if _authorize_write():
			_sfx_volume = value
			sfx_volume_updated.emit(value)

signal muted_buses_updated(value: int)
var _muted_buses: int
var muted_buses: int:
	get: return _muted_buses
	set(value):
		if _authorize_write():
			_muted_buses = value
			muted_buses_updated.emit(value)

# --- Sensitivity ---
signal mouse_sensitivity_updated(value: Vector2)
var _mouse_sensitivity: Vector2
var mouse_sensitivity: Vector2:
	get: return _mouse_sensitivity
	set(value):
		if _authorize_write():
			_mouse_sensitivity = value
			mouse_sensitivity_updated.emit(value)

signal controller_sensitivity_updated(value: Vector2)
var _controller_sensitivity: Vector2
var controller_sensitivity: Vector2:
	get: return _controller_sensitivity
	set(value):
		if _authorize_write():
			_controller_sensitivity = value
			controller_sensitivity_updated.emit(value)

# ===
# Built-In
# ===

func _init() -> void:
	reset()

func reset() -> void:
	# Audio
	_master_volume = 1.0
	_music_volume = 1.0
	_sfx_volume = 1.0
	_muted_buses = 0

	# Sensitivity
	_mouse_sensitivity = Vector2.ONE
	_controller_sensitivity = Vector2.ONE
