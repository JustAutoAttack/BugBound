class_name World
extends Node3D

@onready var zones_controller: WorldZonesController = %ZonesController
@onready var instances_controller: WorldInstancesController = %InstancesController

var bugs_spawned: bool = false
var target_bugs_spawned: int = 5
var total_bugs_spawned: int = 0:
	set(value):
		total_bugs_spawned = value
		if total_bugs_spawned >= target_bugs_spawned and not bugs_spawned:
			bugs_spawned = true
			_on_world_environment_ready()

# ===
# Built-In
# ===

func _ready() -> void:
	_subscribe_events()

	await get_tree().process_frame
	await get_tree().process_frame

	# Only the server orchestrates the initial environment setup
	if multiplayer.is_server():
		_spawn_initial_bugs()
	else:
		var peer: MultiplayerPeer = multiplayer.multiplayer_peer
		if (
			peer and 
			peer.get_connection_status() == MultiplayerPeer.CONNECTION_CONNECTED
		):
			_send_client_ready()
		else:
			if not multiplayer.connected_to_server.is_connected(_send_client_ready):
				multiplayer.connected_to_server.connect(_send_client_ready, CONNECT_ONE_SHOT)

func _exit_tree() -> void:
	_unsubscribe_events()

# ===
# Private
# ===

func _subscribe_events() -> void:
	EventSystem.subscribe_to_notification(Notifications.BugSpawned, _handle_bug_spawned)
	EventSystem.subscribe_to_notification(Notifications.PlayerSpawned, _handle_player_spawned)

func _unsubscribe_events() -> void:
	EventSystem.unsubscribe_all_for_owner(self)

func _send_client_ready() -> void:
	_register_client_ready.rpc_id(1, multiplayer.get_unique_id())

# --- Multiplayer Networking RPCs ---

@rpc("any_peer", "call_remote", "reliable")
func _register_client_ready(peer_id: int) -> void:
	if not multiplayer.is_server():
		return
	LogSystem.log_message(
		"Client %d is ready, requesting player setup..." % peer_id, 
		LogEnums.LogLevel.INFO
	)
	_request_spawn_player(peer_id)

func _request_spawn_player(peer_id: int) -> void:
	var spawn_transform: Node3D = _get_random_town_player_spawn()
	
	EventSystem.dispatch_command(
		Commands.SpawnPlayer.new(
			peer_id,
			spawn_transform.global_position,
			spawn_transform.global_rotation
		)
	)

func _get_random_town_player_spawn() -> Node3D:
	if not (
		zones_controller or 
		zones_controller.zone_map.has(Enums.ZoneID.WEEVIL_WOOD)
	):
		LogSystem.log_message(
			"ZonesController or Town Zone missing! Defaulting world origin for player spawn.", 
			LogEnums.LogLevel.ERROR
		)
		return self
	
	var town_zone: TownZone = zones_controller.zone_map[Enums.ZoneID.WEEVIL_WOOD]
	if not (
		town_zone or 
		town_zone.player_spawns
	):
		LogSystem.log_message(
			"Town zone or its player_spawns container is missing!", 
			LogEnums.LogLevel.ERROR
		)
		return self
	
	var spawn_markers: Array[Node] = town_zone.player_spawns.get_children()
	if spawn_markers.is_empty():
		LogSystem.log_message(
			"No player spawn markers found inside Town zone container! Defaulting to town zone position.", 
			LogEnums.LogLevel.ERROR
		)
		return town_zone

	return spawn_markers[randi() % spawn_markers.size()] as Node3D

# ===
# Handlers & Flow Control
# ===

func _handle_bug_spawned(_notification: Notifications.BugSpawned) -> void:
	total_bugs_spawned += 1

func _on_world_environment_ready() -> void:
	if not multiplayer.is_server():
		return
	
	LogSystem.log_message("Initial world bugs spawned. Spawning server host player.", LogEnums.LogLevel.INFO)
	# Now that bugs are ready, spawn the server's own player
	_request_spawn_player(multiplayer.get_unique_id())

func _handle_player_spawned(notification: Notifications.PlayerSpawned) -> void:
	# Only trigger WorldLoaded if the player that spawned belongs to this local client/server instance
	if notification.player and notification.player.is_multiplayer_authority():
		LogSystem.log_message(
			"Local player authority confirmed spawned. Broadcasting WorldLoaded.", 
			LogEnums.LogLevel.INFO
		)
		
		EventSystem.broadcast(
			Notifications.WorldLoaded.new()
		)

func _spawn_initial_bugs() -> void:
	if not multiplayer.is_server():
		return

	if not zones_controller or not zones_controller.zone_map.has(Enums.ZoneID.FUNGAL_FOREST):
		LogSystem.log_message(
			"ZonesController or Forest Zone missing for bug spawning!", 
			LogEnums.LogLevel.ERROR
		)
		return

	var forest_zone: WorldZone = zones_controller.zone_map[Enums.ZoneID.FUNGAL_FOREST]
	if not forest_zone or not forest_zone.bug_spawns:
		LogSystem.log_message(
			"Forest zone or its bug_spawns container is missing!", 
			LogEnums.LogLevel.ERROR
		)
		return

	var spawn_markers = forest_zone.bug_spawns.get_children()
	if spawn_markers.is_empty():
		LogSystem.log_message(
			"No bug spawn markers found inside Forest zone container!", 
			LogEnums.LogLevel.ERROR
		)
		return

	for i: int in range(target_bugs_spawned):
		var marker: Marker3D = spawn_markers[i % spawn_markers.size()]
		var spawn_position: Vector3 = marker.global_position if marker else forest_zone.global_position
		var spawn_rotation: Vector3 = marker.global_rotation if marker else Vector3.ZERO

		EventSystem.dispatch_command(
			Commands.SpawnBug.new(
				Enums.BugID.PABLO,
				Enums.ZoneID.FUNGAL_FOREST,
				spawn_position,
				spawn_rotation
			)
		)
