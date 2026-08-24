class_name WorldInstancesController
extends Node

@onready var players_container: Node = %Players
@onready var bugs_container: Node = %Bugs
@onready var player_spawner: MultiplayerSpawner = %PlayerSpawner

# ===
# Built-In
# ===

func _ready() -> void:
	_subscribe_events()

func _exit_tree() -> void:
	_unsubscribe_events()

# ===
# Private
# ===

func _subscribe_events() -> void:
	EventSystem.subscribe_to_command(Commands.SpawnPlayer, _handle_spawn_player)

func _unsubscribe_events() -> void:
	EventSystem.unsubscribe_all_for_owner(self)

# ===
# Events
# ===

func _handle_spawn_player(command: Commands.SpawnPlayer) -> void:
	if not multiplayer.is_server():
		return

	if not player_spawner:
		LogSystem.log_message("PlayerSpawner not found in WorldInstancesController!", LogEnums.LogLevel.ERROR)
		return

	var spawn_data: Dictionary = {
		"peer_id": command.peer_id,
		"location": command.location,
		"rotation": command.rotation
	}

	player_spawner.spawn(spawn_data)
