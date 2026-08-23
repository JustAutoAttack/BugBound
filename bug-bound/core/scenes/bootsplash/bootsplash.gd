class_name Bootsplash
extends Node

# ===
# Built-In
# ===

func _ready() -> void:
	EventSystem.broadcast(
		Notifications.BootsplashLoaded.new()
	)
