class_name GameObjectController
extends Node

signal setup_complete

var is_setup: bool = false

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

func _subscribe_events() -> void: pass
func _unsubscribe_events() -> void: pass

# ===
# Public
# ===

func setup_pools() -> void:
	is_setup = false
	
	# TODO: Setup pools
	
	is_setup = true
	setup_complete.emit()

func deactivate_all_pools() -> void:
	# NOTE: Example to handle nested
	#for pool: ObjectPool in ContextSystem.game_context.enemy_pools.values():
		#for enemy: Enemy in pool.get_active_instances():
			#enemy.deactivate()
			#pool.return_instance(enemy)
	
	var pools: Array[ObjectPool] = []
	
	for pool: ObjectPool in pools:
		for instance: Node in pool.get_active_instances():
			pool.return_instance(instance)

# ===
# Private
# ===

# ===
# Events
# ===
