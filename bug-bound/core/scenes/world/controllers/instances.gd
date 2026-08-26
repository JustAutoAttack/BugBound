class_name WorldInstancesController
extends Node

@onready var players_container: Node = %Players
@onready var player_spawner: MultiplayerSpawner = %PlayerSpawner
@onready var zones_controller: WorldZonesController = %ZonesController

@export var bug_scene: PackedScene

var bug_spawners: Dictionary[Enums.ZoneID, MultiplayerSpawner] = {}
var bug_containers: Dictionary[Enums.ZoneID, Node3D] = {}

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
	var player: Player = AssetProvider.get_player_scene()
	player.name = str(data.peer_id)
	player.set_multiplayer_authority(data.peer_id)
	
	player.call_deferred("set_global_position", data.location)
	player.call_deferred("set_global_rotation", data.rotation)
	
	return player

func _custom_spawn_bug(data: Dictionary) -> Node:
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

	var spawn_data: Dictionary = {
		"peer_id": command.peer_id,
		"location": command.world_location,
		"rotation": command.rotation
	}

	player_spawner.spawn(spawn_data)

func _handle_spawn_bug(command: Commands.SpawnBug) -> void:
	if not multiplayer.is_server():
		return
	
	var spawner: MultiplayerSpawner = bug_spawners.get(command.zone)
	if not spawner:
		LogSystem.log_message(
			"MultiplayerSpawner not found for zone: {0}".format([command.zone]), 
			LogEnums.LogLevel.ERROR
		)
		return

	var target_container: Node3D = bug_containers.get(command.zone)
	if not target_container:
		LogSystem.log_message(
			"Bug container not found for zone: {0}".format([command.zone]), 
			LogEnums.LogLevel.ERROR
		)
		return
	
	spawner.spawn_path = spawner.get_path_to(target_container)

	var spawn_data: Dictionary = {
		"bug_id": command.id,
		"zone": command.zone,
		"location": command.world_location,
		"rotation": command.rotation
	}

	spawner.spawn(spawn_data)
