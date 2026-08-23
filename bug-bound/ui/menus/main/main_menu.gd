class_name UIMainMenu
extends UIMenu

# ===
# Private
# ===

func _emit_action(action: Enums.MainMenuAction) -> void:
	EventSystem.broadcast(
		Notifications.MainMenuActioned.new(
			action
		)
	)

# ===
# Signals
# ===

func _on_play() -> void:
	_emit_press_sfx()
	_emit_action(Enums.MainMenuAction.PLAY)

func _on_settings() -> void:
	_emit_press_sfx()
	_emit_action(Enums.MainMenuAction.SETTINGS)

func _on_quit() -> void:
	_emit_press_sfx()
	_emit_action(Enums.MainMenuAction.QUIT)
