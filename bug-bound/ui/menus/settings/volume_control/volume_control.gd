@tool
class_name UISettingsVolumeControl
extends HBoxContainer

signal volume_ratio_updated(value: float)

@export var audio_bus: Enums.AudioBusType
@export var title: String = "":
	set(value):
		if title == value: return
		title = value
		if is_node_ready():
			_update_title_label()
@export_range(0.0, 1.0, 0.01) var volume_ratio: float = 0.5:
	set(value):
		if volume_ratio == value: return
		volume_ratio = value
		if is_node_ready():
			_update_slider()

@onready var title_label: Label = %Title
@onready var slider: HSlider = %Slider

# ===
# Built-In
# ===

func _ready() -> void:
	_update_title_label()
	_update_slider()

# ===
# Private
# ===

func _update_title_label() -> void:
	title_label.text = title

func _update_slider() -> void:
	slider.value = volume_ratio

# ===
# Handlers
# ===

func _on_slider_value_changed(value: float) -> void:
	volume_ratio_updated.emit(value)
