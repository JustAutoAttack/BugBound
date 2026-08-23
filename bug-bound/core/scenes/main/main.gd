class_name Main
extends Node

# ===
# Built-In
# ===

func _ready() -> void:
	EventSystem.broadcast(
		Notifications.MainLoaded.new()
	)
