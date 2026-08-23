class_name UIMenu
extends Control

@export var type: Enums.MenuType

func _emit_press_sfx() -> void:
	EventSystem.dispatch_command(
		Commands.PlaySFX.new(
			Enums.SFXType.UI_SELECT_ONE
		)
	)
