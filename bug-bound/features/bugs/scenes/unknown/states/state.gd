class_name BugUnknownState
extends State

enum StateName { 
	PATROL, 
	ALERTED, 
	FLEE, 
	ENGAGE,
	CAUGHT
}

var _owner: BugUnknown

# ===
# Built-In
# ===

func _ready() -> void:
	await owner.ready
	_owner = owner as BugUnknown

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
