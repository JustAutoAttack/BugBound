class_name BugPabloState
extends State

enum StateName { PATROL, ALERTED, FLEE, ENGAGE, CAUGHT }

var _owner: BugPablo


# ===
# Built-In
# ===

func _ready() -> void:
	await owner.ready
	_owner = owner as BugPablo

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
