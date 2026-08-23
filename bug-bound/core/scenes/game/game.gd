class_name Game
extends Node

# ===
# Built-In
# ===

func _ready() -> void:
	EventSystem.broadcast(
		Notifications.GameLoaded.new()
	)
