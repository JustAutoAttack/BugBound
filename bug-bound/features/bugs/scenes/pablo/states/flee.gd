# Flee
extends BugPabloState

# ===
# Built-In
# ===

func enter(_prev_state_path: String, _data: Object) -> void: pass

func update(_delta: float) -> void: pass
func physics_update(_delta: float) -> void: pass
func exit() -> void: pass

func _subscribe_events() -> void: pass
func _unsubscribe_events() -> void: pass
