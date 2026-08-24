class_name World
extends Node3D

@onready var player_spawn: Marker3D = %PlayerSpawn
@onready var instances_controller: WorldInstancesController = %InstancesController

# ===
# Built-In
# ===

func _ready() -> void:
	_subscribe_events()

	# Spawn Player
	EventSystem.dispatch_command(
		Commands.SpawnPlayer.new(
			player_spawn.global_position,
			player_spawn.global_rotation
		)
	)

func _exit_tree() -> void:
	_unsubscribe_events()

# ===
# Public
# ===


# ===
# Private
# ===

func _subscribe_events() -> void:
	EventSystem.subscribe_to_notification(Notifications.PlayerSpawned, _handle_player_spawned)

func _unsubscribe_events() -> void:
	EventSystem.unsubscribe_all_for_owner(self)

func _handle_player_spawned(notification: Notifications.PlayerSpawned) -> void:
	
	EventSystem.broadcast(
		Notifications.WorldLoaded.new()
	)
