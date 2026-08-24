# Engage
extends BugPabloState

# ===
# Built-In
# ===

func enter(_prev_state_path: String, _data: Object) -> void:
	_subscribe_events()
	_owner.sprite.play("kill_mode", 2.0)
	_owner.velocity.lerp(Vector3.ZERO, 1.0)
	_owner.move_and_slide()
	
	# TODO: show exclamation mark
	# TODO: remain in engage

func exit() -> void: 
	_unsubscribe_events()

func _subscribe_events() -> void: 
	# bug collect resolved
	# if not this bug, skip
	# switch on resolution:
	# - caught: transition to caught
	# - flee: transition to flee
	# - bug won: transition to flee
	pass

func _unsubscribe_events() -> void: 
	EventSystem.unsubscribe_all_for_owner(self)
