class_name WorldInstancesController
extends Node

@onready var players_container: Node = %Players
@onready var bugs_container: Node = %Bugs

# ===
# Built-In
# ==

func _ready() -> void:
	_subscribe_events()

func _exit_tree() -> void:
	_unsubscribe_events()

# ===
# Private
# ===

func _subscribe_events() -> void:
	EventSystem.subscribe_to_command(Commands.SpawnPlayer, _handle_spawn_player)
	#EventSystem.subscribe_to_command(Commands.SpawnBug, _handle_spawn_bug)

func _unsubscribe_events() -> void:
	EventSystem.unsubscribe_all_for_owner(self)

# ===
# Events
# ===

func _handle_spawn_player(command: Commands.SpawnPlayer) -> void:
	var player: Player = AssetProvider.get_player_scene()
	players_container.add_child(player)
	player.global_position = command.location
	player.global_rotation = command.rotation
	
	await get_tree().process_frame
	#
	#Session.player_provider.set_player_instance(
		#player
	#)
	#
	EventSystem.broadcast(
		Notifications.PlayerSpawned.new(
			player
		)
	)

#func _handle_spawn_bug(command: Commands.SpawnBug) -> void:
	#var bug: Bug = AssetProvider.get_bug_scene()
	#bugs_container.add_child(bug)
	#bug.global_position = command.location
	#bug.global_rotation = command.rotation
	#
	#await get_tree().process_frame
#
	#EventSystem.broadcast(
		#Notifications.BugSpawned.new(
			#bug
		#)
	#)
