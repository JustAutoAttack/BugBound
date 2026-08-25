class_name WorldInstancesController
extends Node

@onready var players_container: Node = %Players
@onready var player_spawner: MultiplayerSpawner = %PlayerSpawner
@onready var zones_controller: WorldZonesController = %ZonesController

@export var bug_scene: PackedScene

var bug_spawners: Dictionary[Enums.ZoneType, MultiplayerSpawner] = {}
var bug_containers: Dictionary[Enums.ZoneType, Node3D] = {}

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
		LogSystem.log_message("ZonesController not found by WorldInstancesController!", LogEnums.LogLevel.ERROR)
		return

	for zone_type in zones_controller.zone_map.keys():
		var zone_node = zones_controller.zone_map.get(zone_type)
		if zone_node:
			if zone_node.bug_spawner:
				bug_spawners[zone_type] = zone_node.bug_spawner
			else:
				LogSystem.log_message("Could not auto-fetch bug_spawner for zone: %d" % zone_type, LogEnums.LogLevel.ERROR)
				
			if zone_node.bug_instances:
				bug_containers[zone_type] = zone_node.bug_instances
			else:
				LogSystem.log_message("Could not auto-fetch bug_instances container for zone: %d" % zone_type, LogEnums.LogLevel.ERROR)
		else:
			LogSystem.log_message("Zone node missing in zone_map for type: %d" % zone_type, LogEnums.LogLevel.ERROR)

func _subscribe_events() -> void:
	EventSystem.subscribe_to_command(Commands.SpawnPlayer, _handle_spawn_player)
	EventSystem.subscribe_to_command(Commands.SpawnBug, _handle_spawn_bug)

func _unsubscribe_events() -> void:
	EventSystem.unsubscribe_all_for_owner(self)

func _setup_spawners() -> void:
	if player_spawner:
		player_spawner.spawn_function = _custom_spawn_player
	else:
		LogSystem.log_message(
			"PlayerSpawner not found in WorldInstancesController!", 
			LogEnums.LogLevel.ERROR
		)

	for zone_type in bug_spawners:
		var spawner: MultiplayerSpawner = bug_spawners.get(zone_type)
		if not spawner: 
			LogSystem.log_message(
				"BugSpawner not found for zone type %d!" % zone_type, 
				LogEnums.LogLevel.ERROR
			)
			continue
		spawner.spawn_function = _custom_spawn_bug

# ===
# Handlers & Spawner Callbacks
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

func _custom_spawn_player(data: Dictionary) -> Node:
	var player: Player = AssetProvider.get_player_scene()
	player.name = str(data.peer_id)
	player.set_multiplayer_authority(data.peer_id)
	
	player.call_deferred("set_global_position", data.location)
	player.call_deferred("set_global_rotation", data.rotation)
	
	return player

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

func _custom_spawn_bug(data: Dictionary) -> Node:
	var target_zone = data.get("zone", Enums.ZoneType.FOREST)
	var target_bug_id = data.get("bug_id", Enums.BugID.TEST)
	
	var bug_instance = null
	match target_bug_id:
		Enums.BugID.TEST:
			bug_instance = bug_scene.instantiate() as BugPablo
	
	if not bug_instance:
		LogSystem.log_message("Bug instance not found for ID: %d" % target_bug_id, LogEnums.LogLevel.ERROR)
		return null
	
	var target_container: Node3D = bug_containers.get(target_zone)
	if not target_container:
		LogSystem.log_message("Bug container missing for zone: %d" % target_zone, LogEnums.LogLevel.ERROR)
		return null

	var global_pos: Vector3 = data.get("location", target_container.global_position)
	var rot: Vector3 = data.get("rotation", Vector3.ZERO)

	bug_instance.call_deferred("set_global_position", global_pos)
	bug_instance.call_deferred("set_global_rotation", rot)
	
	return bug_instance
