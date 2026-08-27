class_name UIPauseMenu
extends UIMenu

# ===
# Private
# ===

func _emit_action(action: Enums.PauseMenuAction) -> void:
	EventSystem.broadcast(
		Notifications.PauseMenuActioned.new(
			action
		)
	)

# ===
# Handlers
# ===

func _on_resume_button_pressed() -> void:
	_emit_press_sfx()
	_emit_action(Enums.PauseMenuAction.RESUME)

func _on_settings_button_pressed() -> void:
	_emit_press_sfx()
	_emit_action(Enums.PauseMenuAction.SETTINGS)

func _on_main_menu_button_pressed() -> void:
	_emit_press_sfx()
	_emit_action(Enums.PauseMenuAction.EXIT)

func _on_quit_button_pressed() -> void:
	_emit_press_sfx()
	_emit_action(Enums.PauseMenuAction.QUIT)
