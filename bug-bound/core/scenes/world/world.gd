class_name World
extends Node3D

# ===
# Built-In
# ===

func _ready() -> void:
	EventSystem.broadcast(
		Notifications.WorldLoaded.new()
	)

# ===
# Public
# ===


# ===
# Private
# ===
