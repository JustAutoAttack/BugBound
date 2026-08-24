class_name World
extends Node3D

@onready var player_spawn: Marker3D = %PlayerSpawn
@onready var instances_controller: WorldInstancesController = %InstancesController

# ===
# Built-In
# ===

func _ready() -> void:
	_subscribe_events()

	# If we are the server, spawn our own player immediately.
	# If we are a client, notify the server (ID 1) that we are loaded and ready to spawn.
	if multiplayer.is_server():
		_request_spawn_player(multiplayer.get_unique_id())
	else:
		_register_client_ready.rpc_id(1, multiplayer.get_unique_id())

func _exit_tree() -> void:
	_unsubscribe_events()

# ===
# Multiplayer Networking RPCs
# ===

@rpc("any_peer", "call_remote", "reliable")
func _register_client_ready(peer_id: int) -> void:
	if not multiplayer.is_server():
		return
	LogSystem.log_message("Client %d is ready, spawning player..." % peer_id, LogEnums.LogLevel.INFO)
	_request_spawn_player(peer_id)

func _request_spawn_player(peer_id: int) -> void:
	EventSystem.dispatch_command(
		Commands.SpawnPlayer.new(
			peer_id,
			player_spawn.global_position,
			player_spawn.global_rotation
		)
	)

# ===
# Private
# ===

func _subscribe_events() -> void:
	EventSystem.subscribe_to_notification(Notifications.PlayerSpawned, _handle_player_spawned)

func _unsubscribe_events() -> void:
	EventSystem.unsubscribe_all_for_owner(self)

# ===
# Events
# ===

func _handle_player_spawned(_notification: Notifications.PlayerSpawned) -> void:
	EventSystem.broadcast(
		Notifications.WorldLoaded.new()
	)
