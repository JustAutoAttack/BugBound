class_name UIMainMenu
extends UIMenu

@export var join_code_input: LineEdit

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

func _on_host_pressed() -> void:
	_emit_press_sfx()
	EventSystem.dispatch_command(
		Commands.HostGame.new()
	)

func _on_join_pressed() -> void:
	_emit_press_sfx()
	var code: String = (
		join_code_input.text.strip_edges() 
		if join_code_input 
		else ""
	)
	EventSystem.dispatch_command(
		Commands.JoinGame.new(
			code
		)
	)

func _on_settings() -> void:
	_emit_press_sfx()
	_emit_action(Enums.MainMenuAction.SETTINGS)

func _on_quit() -> void:
	_emit_press_sfx()
	_emit_action(Enums.MainMenuAction.QUIT)
