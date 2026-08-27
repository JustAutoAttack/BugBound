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
# Handlers
# ===

func _on_host_button_pressed() -> void:
	_emit_press_sfx()
	_emit_action(Enums.MainMenuAction.HOST)

func _on_join_button_pressed() -> void:
	_emit_press_sfx()
	_emit_action(Enums.MainMenuAction.JOIN)

func _on_settings_button_pressed() -> void:
	_emit_press_sfx()
	_emit_action(Enums.MainMenuAction.SETTINGS)

func _on_quit_button_pressed() -> void:
	_emit_press_sfx()
	_emit_action(Enums.MainMenuAction.QUIT)

func _on_join_code_input_text_changed(new_text: String) -> void:
	var code: String = new_text.strip_edges()
	ContextSystem.ui_provider.set_join_code(code)

func _on_join_code_input_text_submitted(new_text: String) -> void:
	var code: String = new_text.strip_edges()
	ContextSystem.ui_provider.set_join_code(code)
	_emit_action(Enums.MainMenuAction.JOIN)
