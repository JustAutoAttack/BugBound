class_name GameState
extends State

enum StateName { LOAD, TITLE, WORLD }

var _owner: Game


# ===
# Built-In
# ===

func _ready() -> void:
	await owner.ready
	_owner = owner as Game

# ===
# Public
# ===

func get_state_name(state: StateName) -> String:
	return StateName.keys()[state].capitalize()

# ===
# Private
# ===

func _transition_to(state: StateName, data: Object) -> void:
	finished.emit(get_state_name(state), data)
