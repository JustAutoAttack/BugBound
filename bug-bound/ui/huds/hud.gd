class_name UIHUD
extends Control

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

func _unsubscribe_events() -> void:
	EventSystem.unsubscribe_all_for_owner(self)
