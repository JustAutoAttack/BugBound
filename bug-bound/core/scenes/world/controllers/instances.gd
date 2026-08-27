class_name WorldInstancesController
extends Node

@export var bug_scene: PackedScene
@export var zones_controller: WorldZonesController

@onready var players_container: Node = $Players
@onready var player_spawner: MultiplayerSpawner = $PlayerSpawner

var bug_spawners: Dictionary[Enums.ZoneID, MultiplayerSpawner] = {}
var bug_containers: Dictionary[Enums.ZoneID, Node3D] = {}
var peer_to_player_map: Dictionary[int, Player] = {}

# ===
# Built-In
# ===

func _ready() -> void:
	_fetch_zone_references()
	_subscribe_events()
	_setup_spawners()

func _exit_tree() -> void:
	_unsubscribe_events()

# ===
# Private
# ===

func _fetch_zone_references() -> void:
	if not zones_controller:
		LogSystem.log_message(
			"ZonesController not found by WorldInstancesController!", 
			LogEnums.LogLevel.ERROR
		)
		return

	for zone_type: Enums.ZoneID in zones_controller.zone_map.keys():
		
		# Zone
		var zone_node: WorldZone = zones_controller.zone_map.get(zone_type)
		if not zone_node:
			LogSystem.log_message(
				"Zone node missing in zone_map for type: %d" % zone_type, 
				LogEnums.LogLevel.ERROR
			)
			continue
		
		if not zone_node.bug_spawner:
			LogSystem.log_message(
				"Could not auto-fetch bug_spawner for zone: %d" % zone_type, 
				LogEnums.LogLevel.ERROR
			)
			continue
		
		bug_spawners[zone_type] = zone_node.bug_spawner
		
		if not zone_node.bug_instances:
			LogSystem.log_message(
				"Could not auto-fetch bug_instances container for zone: %d" % zone_type, 
				LogEnums.LogLevel.ERROR
			)
			continue
		
		bug_containers[zone_type] = zone_node.bug_instances

func _subscribe_events() -> void:
	EventSystem.subscribe_to_command(Commands.SpawnPlayer, _handle_spawn_player)
	EventSystem.subscribe_to_command(Commands.DespawnPlayer, _handle_despawn_player)
	EventSystem.subscribe_to_command(Commands.SpawnBug, _handle_spawn_bug)

func _unsubscribe_events() -> void:
	EventSystem.unsubscribe_all_for_owner(self)

func _setup_spawners() -> void:
	if not player_spawner:
		LogSystem.log_message(
			"PlayerSpawner not found in WorldInstancesController!", 
			LogEnums.LogLevel.ERROR
		)
		return
	
	player_spawner.spawn_function = _custom_spawn_player

	for zone_type: Enums.ZoneID in bug_spawners:
		var spawner: MultiplayerSpawner = bug_spawners.get(zone_type)
		if not spawner: 
			LogSystem.log_message(
				"BugSpawner not found for zone type %d!" % zone_type, 
				LogEnums.LogLevel.ERROR
			)
			continue
		
		spawner.spawn_function = _custom_spawn_bug

# ===
# Callbacks
# ===

func _custom_spawn_player(data: Dictionary) -> Node:
	# TODO: Sanitize with a data object (mimic zod)
	
	var player: Player = AssetProvider.get_player_scene()
	var peer_id: int = data.peer_id
	
	peer_to_player_map[peer_id] = player
	
	player.name = str(peer_id)
	player.set_multiplayer_authority(peer_id)
	player.call_deferred("set_global_position", data.location)
	player.call_deferred("set_global_rotation", data.rotation)
	
	return player

func _custom_spawn_bug(data: Dictionary) -> Node:
	# TODO: Sanitize with a data object (mimic zod)
	
	var target_zone: Enums.ZoneID = data.get("zone")
	var target_bug: Enums.BugID = data.get("bug_id")
	
	var bug_instance: BugUnknown = AssetProvider.get_bug_unknown_scene()
	if not bug_instance:
		LogSystem.log_message(
			"BugUnknown instance not found", 
			LogEnums.LogLevel.ERROR
		)
		return null
	
	var target_container: Node3D = bug_containers.get(target_zone)
	if not target_container:
		LogSystem.log_message(
			"Bug container missing for zone: {0}".format([target_zone]), 
			LogEnums.LogLevel.ERROR
		)
		return null

	var bug_definition_data: BugDefinitionData = AssetProvider.get_bug_definition_data(target_bug)
	if not bug_definition_data:
		LogSystem.log_message(
			"BugDefinitionData not found for: {0}".format([target_bug]),
			LogEnums.LogLevel.ERROR
		)
		return null
		
	var global_pos: Vector3 = data.get("location", target_container.global_position)
	var rotation: Vector3 = data.get("rotation", Vector3.ZERO)

	bug_instance.call_deferred("set_global_position", global_pos)
	bug_instance.call_deferred("set_global_rotation", rotation)
	bug_instance.call_deferred("setup", bug_definition_data, Enums.RarityType.MYTHICAL)
	
	return bug_instance

# ===
# Handlers
# ===

func _handle_spawn_player(command: Commands.SpawnPlayer) -> void:
	if not multiplayer.is_server():
		return

	if not player_spawner:
		return
	
	# TODO: Sanitize with a data object (mimic zod)
	var spawn_data: Dictionary = {
		"peer_id": command.peer_id,
		"location": command.world_location,
		"rotation": command.rotation
	}

	player_spawner.spawn(spawn_data)

func _handle_despawn_player(command: Commands.DespawnPlayer) -> void:
	if not multiplayer.is_server():
		return
	
	var peer_id: int = command.peer_id
	
	if not peer_to_player_map.has(peer_id):
		LogSystem.log_message(
			"Failed to despawn player: Peer ID {0} not found in peer_to_player_map.".format([
				peer_id
			]),
			LogEnums.LogLevel.ERROR
		)
		return
		
	var player: Player = peer_to_player_map[peer_id]
	peer_to_player_map.erase(peer_id)
	
	if not is_instance_valid(player):
		LogSystem.log_message(
			"Failed to despawn player: Player instance for peer ID {0} is invalid or already freed.".format([
				peer_id
			]),
			LogEnums.LogLevel.ERROR
		)
		return
	
	LogSystem.log_message(
		"Successfully despawning player for peer ID: {0}".format([
			peer_id
		]),
		LogEnums.LogLevel.INFO
	)
	
	player.despawn()
	
	EventSystem.broadcast(
		Notifications.PlayerDespawned.new(
			peer_id
		)
	)

func _handle_spawn_bug(command: Commands.SpawnBug) -> void:
	if not multiplayer.is_server():
		return
	
	var spawner: MultiplayerSpawner = bug_spawners.get(command.zone)
	if not spawner:
		LogSystem.log_message(
			"MultiplayerSpawner not found for zone: {0}".format([
				command.zone
			]), 
			LogEnums.LogLevel.ERROR
		)
		return
	
	# TODO: Sanitize with a data object (mimic zod)
	var spawn_data: Dictionary = {
		"bug_id": command.id,
		"zone": command.zone,
		"location": command.world_location,
		"rotation": command.rotation
	}

	spawner.spawn(spawn_data)
