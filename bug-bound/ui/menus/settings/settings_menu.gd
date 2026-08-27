class_name UISettingsMenu
extends UIMenu

@onready var volume_controls: VBoxContainer = %VolumeControls
@onready var close_button: Button = %CloseButton
@onready var save_button: Button = %SaveButton

# ===
# Built-In
# ===

func _ready() -> void:
	_connect_signals()

# ===
# Private
# ===

func _connect_signals() -> void:
	for volume_control: UISettingsVolumeControl in volume_controls.get_children():
		volume_control.volume_ratio_updated.connect(
			_on_volume_control_volume_ratio_updated.bind(
				volume_control.audio_bus
			)
		)

func _emit_action(action: Enums.SettingsMenuAction) -> void:
	EventSystem.broadcast(
		Notifications.SettingsMenuActioned.new(
			action
		)
	)

# ===
# Handlers
# ===

func _on_volume_control_volume_ratio_updated(audio_bus: Enums.AudioBusType, value: float) -> void:
	LogSystem.log_message(
		"Volume ratio updated for: {0}. Value: {1}".format([
			audio_bus, value
		]),
		LogEnums.LogLevel.DEBUG
	)
	
	LogSystem.log_message(
		"Unhandled: _on_volume_control_volume_ratio_updated",
		LogEnums.LogLevel.WARN
	)

func _on_close_button_pressed() -> void:
	_emit_press_sfx()
	_emit_action(Enums.SettingsMenuAction.CLOSE)

func _on_save_button_pressed() -> void:
	_emit_press_sfx()
	_emit_action(Enums.SettingsMenuAction.SAVE)
