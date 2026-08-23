# Title
extends GameState

# ===
# Built-In
# ===

func enter(_prev_state_path: String, _data: Object) -> void:
	LogSystem.log_message(
		"Enter TITLE",
		LogEnums.LogLevel.DEBUG
	)
	_subscribe_events()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	await get_tree().process_frame

	# Hide all UI
	EventSystem.dispatch_command(
		Commands.HideAllUI.new()
	)
	
	await get_tree().process_frame
	
	# Show Main Menu
	EventSystem.dispatch_command(
		Commands.ToggleMenu.new(
			Enums.MenuType.MAIN,
			true
		)
	)
		
	# Start Music
	EventSystem.dispatch_command(
		Commands.StartTitleMusic.new()
	)

func exit() -> void:
	LogSystem.log_message(
		"Exit TITLE",
		LogEnums.LogLevel.DEBUG
	)
	EventSystem.dispatch_command(
		Commands.HideAllUI.new()
	)
	_unsubscribe_events()

func _subscribe_events() -> void:
	EventSystem.subscribe_to_notification(Notifications.MainMenuActioned, _handle_ui_main_menu)
	EventSystem.subscribe_to_notification(Notifications.SettingsMenuActioned, _handle_ui_settings_menu)

func _unsubscribe_events() -> void:
	EventSystem.unsubscribe_all_for_owner(self)

# ===
# Events
# ===

# --- UI ---
func _handle_ui_main_menu(event: Notifications.MainMenuActioned) -> void:
	match event.action:
		Enums.MainMenuAction.PLAY:
			# Close Main Menu
			EventSystem.dispatch_command(
				Commands.ToggleMenu.new(
					Enums.MenuType.MAIN, 
					false
				)
			)
			_transition_to(
				StateName.LOAD,
				GameLoadStateData.new(
					StateName.WORLD,
					true,
					""
				)
			)

		Enums.MainMenuAction.SETTINGS:
			# Close Main Menu
			EventSystem.dispatch_command(
				Commands.ToggleMenu.new(
					Enums.MenuType.MAIN, 
					false
				)
			)
			# Open Settings Menu
			EventSystem.dispatch_command(
				Commands.ToggleMenu.new(
					Enums.MenuType.SETTINGS, 
					true
				)
			)
		
		Enums.MainMenuAction.QUIT:
			get_tree().quit()

func _handle_ui_settings_menu(event: Notifications.SettingsMenuActioned) -> void:
	match event.action:
		Enums.SettingsMenuAction.SAVE:
			# Close Settings
			EventSystem.dispatch_command(
				Commands.ToggleMenu.new(
					Enums.MenuType.SETTINGS, 
					false
				)
			)

			# Open Main
			EventSystem.dispatch_command(
				Commands.ToggleMenu.new(
					Enums.MenuType.MAIN, 
					true
				)
			)
			
			await get_tree().process_frame
			
			# Hide HUD
			EventSystem.dispatch_command(
				Commands.ToggleHUD.new(
					false
				)
			)
