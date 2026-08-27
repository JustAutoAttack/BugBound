class_name GlobalUtils
extends RefCounted

static func toggle_hud(is_active: bool) -> void:
	EventSystem.dispatch_command(
		Commands.ToggleHUD.new(
			is_active
		)
	)

static func toggle_menu(menu_type: Enums.MenuType, is_active: bool) -> void:
	EventSystem.dispatch_command(
		Commands.ToggleMenu.new(
			menu_type, 
			is_active
		)
	)
