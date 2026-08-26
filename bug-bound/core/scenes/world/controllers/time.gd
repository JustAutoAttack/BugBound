class_name WorldTimeController
extends Node

@export var total_time: float = 0.0
@export var time: float = 0.0
@export var max_time: float = 1.0 * 60 * 60 * 24  # 24 hours
@export var cpu_time: float = 0
@export var scale: float = 1.0 * 60 * 24 # 1-Minute cycles

func _ready() -> void:
	if not Engine.is_editor_hint():
		total_time = ContextSystem.world_context.total_time
		time = ContextSystem.world_context.time
		cpu_time = ContextSystem.world_context.cpu_time

func _process(delta: float) -> void:
	if max_time <= 0.0:
		return

	# Calculate how much of a day passed this frame (0.0 to 1.0 scale)
	var delta_days: float = (delta * scale) / max_time
	
	# Add that fraction to total_time (will result in 2.5 after 2.5 days)
	total_time += delta_days
	
	# time is just the fractional part of total_time
	time = fmod(total_time, 1.0)
	
	cpu_time += delta
	
	ContextSystem.world_provider.set_time(time)
	ContextSystem.world_provider.set_total_time(total_time)
	ContextSystem.world_provider.set_cpu_time(cpu_time)
