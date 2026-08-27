class_name WorldTimeController
extends Node

@export var max_time: float = 1.0 * 60 * 60 * 24  # 24 hours
@export var scale: float = 1.0 * 60 * 24 # 1-Minute cycles

func _ready() -> void:
	if not Engine.is_editor_hint():
		if multiplayer.is_server() and ContextSystem.world_context:
			# Initialize context values if starting fresh
			ContextSystem.world_provider.set_total_time(ContextSystem.world_context.total_time)
			ContextSystem.world_provider.set_time(ContextSystem.world_context.time)
			ContextSystem.world_provider.set_cpu_time(ContextSystem.world_context.cpu_time)

func _process(delta: float) -> void:
	if max_time <= 0.0:
		return

	# Guard: If no multiplayer peer is assigned yet, skip this frame to prevent errors on startup
	if not multiplayer.multiplayer_peer:
		return

	# Only the server advances time
	if not multiplayer.is_server():
		return

	# Calculate progression
	var delta_days: float = (delta * scale) / max_time
	
	var total_time = ContextSystem.world_context.total_time + delta_days
	var time = fmod(total_time, 1.0)
	var cpu_time = ContextSystem.world_context.cpu_time + delta

	ContextSystem.world_provider.set_time(time)
	ContextSystem.world_provider.set_total_time(total_time)
	ContextSystem.world_provider.set_cpu_time(cpu_time)
