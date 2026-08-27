class_name WorldContextSynchronizer
extends MultiplayerSynchronizer

# ===
# Built-In
# ===

func _ready() -> void:
	set_multiplayer_authority(1)

	# Wait a frame to ensure ContextSystem and world_context are fully initialized
	await get_tree().process_frame

	if ContextSystem and ContextSystem.world_context:
		var context: WorldContextData = ContextSystem.world_context
		
		# If we are the server, listen to changes on our local context data and broadcast them
		if multiplayer.is_server():
			context.time_updated.connect(_on_server_time_updated)
			context.total_time_updated.connect(_on_server_total_time_updated)
			context.cpu_time_updated.connect(_on_server_cpu_time_updated)

# === 
# Server: Broadcast to Clients 
# ===

func _on_server_time_updated(value: float) -> void:
	_sync_time_to_clients.rpc(value)

func _on_server_total_time_updated(value: float) -> void:
	_sync_total_time_to_clients.rpc(value)

func _on_server_cpu_time_updated(value: float) -> void:
	_sync_cpu_time_to_clients.rpc(value)

@rpc("authority", "call_remote", "reliable")
func _sync_time_to_clients(value: float) -> void:
	if multiplayer.is_server():
		return
	if ContextSystem and ContextSystem.world_provider:
		ContextSystem.world_provider.set_time(value)

@rpc("authority", "call_remote", "reliable")
func _sync_total_time_to_clients(value: float) -> void:
	if multiplayer.is_server():
		return
	if ContextSystem and ContextSystem.world_provider:
		ContextSystem.world_provider.set_total_time(value)

@rpc("authority", "call_remote", "reliable")
func _sync_cpu_time_to_clients(value: float) -> void:
	if multiplayer.is_server():
		return
	if ContextSystem and ContextSystem.world_provider:
		ContextSystem.world_provider.set_cpu_time(value)
