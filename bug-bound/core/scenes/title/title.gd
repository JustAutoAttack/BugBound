class_name Title
extends Node

# ===
# Built-In
# ===

func _ready() -> void:
	EventSystem.broadcast(
		Notifications.TitleLoaded.new()
	)
