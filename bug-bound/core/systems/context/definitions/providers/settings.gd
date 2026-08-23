class_name SettingsContextProvider
extends ContextProvider

var context: SettingsContextData

const BusMuteFlag: Dictionary[Enums.AudioBusType, int] = {
	Enums.AudioBusType.MASTER: 1 << 0,
	Enums.AudioBusType.MUSIC: 1 << 1,
	Enums.AudioBusType.SFX: 1 << 2,
}

# ===
# Built-In
# ===

func _init(p_context: SettingsContextData) -> void:
	super._init()
	context = p_context

# ===
# Public
# ===

# --- Audio ---
func set_volume(bus: Enums.AudioBusType, value: float) -> void:
	value = clampf(value, 0.0, 1.0)
	
	match bus:
		Enums.AudioBusType.MASTER:
			context.master_volume = value
		Enums.AudioBusType.MUSIC:
			context.music_volume = value
		Enums.AudioBusType.SFX:
			context.sfx_volume = value

func set_bus_mute(bus: Enums.AudioBusType, value: bool) -> void:
	var flags := context.muted_buses
	var mask: int = BusMuteFlag[bus]

	if value:
		flags |= mask
	else:
		flags &= ~mask

	context.muted_buses = flags

func is_bus_muted(bus: Enums.AudioBusType) -> bool:
	var mask: int = BusMuteFlag[bus]
	return (context.muted_buses & mask) != 0

# --- Sensitivitu ---
func set_mouse_sensitivity(value: Vector2) -> void:
	context.mouse_sensitivity = Vector2(
		clampf(value.x, 0.0, 1.0),
		clampf(value.y, 0.0, 1.0)
	)

func get_mouse_sensitivity() -> Vector2:
	return context.mouse_sensitivity

func set_controller_sensitivity(value: Vector2) -> void:
	context.controller_sensitivity = Vector2(
		clampf(value.x, 0.0, 1.0),
		clampf(value.y, 0.0, 1.0)
	)

func get_controller_sensitivity() -> Vector2:
	return context.controller_sensitivity
