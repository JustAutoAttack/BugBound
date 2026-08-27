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
	GlobalUtils.toggle_menu(Enums.MenuType.MAIN, true)
	
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
	# Commands
	EventSystem.subscribe_to_command(Commands.HostGame, _handle_host_game)
	EventSystem.subscribe_to_command(Commands.JoinGame, _handle_join_game)
	
	# Notifications
	EventSystem.subscribe_to_notification(Notifications.MainMenuActioned, _handle_ui_main_menu)
	EventSystem.subscribe_to_notification(Notifications.SettingsMenuActioned, _handle_ui_settings_menu)

func _unsubscribe_events() -> void:
	EventSystem.unsubscribe_all_for_owner(self)

# ===
# Private
# ===

func _attempt_host_game() -> void:
	# TODO: Check if we are already attempting to host
	
	EventSystem.dispatch_command(
		Commands.HostGame.new()
	)

func _attempt_join_game() -> void:
	# TODO: Check if we are already attempting to join
	
	# Get code
	var code: String = ContextSystem.ui_context.join_code
	if code.is_empty():
		LogSystem.log_message(
			"Attempting to join via MainMenuAction, but join code is empty!", 
			LogEnums.LogLevel.WARN
		)
		return
	
	EventSystem.dispatch_command(
		Commands.JoinGame.new(
			ContextSystem.ui_context.join_code
		)
	)

func _go_to_world() -> void:
	GlobalUtils.toggle_menu(Enums.MenuType.MAIN, false)
	
	_transition_to(
		StateName.LOAD,
		GameLoadStateData.new(
			StateName.WORLD,
			true,
			""
		)
	)

# ===
# Handlers
# ===

# --- Main Menu ---
func _handle_host_game(_command: Commands.HostGame) -> void:
	# TODO: Check if we are already hosting or attempting to host
	
	LogSystem.log_message(
		"Attempting to host game", 
		LogEnums.LogLevel.INFO
	)
	
	var error: Error = NetworkSystem.host_game()
	if error != OK:
		LogSystem.log_message(
			"Unable to host game. Error: {1}".format([
				error
			]), 
			LogEnums.LogLevel.ERROR
		)
		return
	
	_go_to_world()

func _handle_join_game(command: Commands.JoinGame) -> void:
	# TODO: Check if we are already joining or attempting to join
	
	var code: String = command.code
	
	if code.is_empty():
		LogSystem.log_message(
			"Join code cannot be empty!", 
			LogEnums.LogLevel.WARN
		)
		return

	LogSystem.log_message(
		"Attempting to join game with code: {0}".format([
			code
		]), 
		LogEnums.LogLevel.INFO
	)
	
	var error: Error = NetworkSystem.join_game(code)
	if error != OK:
		LogSystem.log_message(
			"Unable to join game with code: {0}. Error: {1}".format([
				code, error
			]), 
			LogEnums.LogLevel.ERROR
		)
		return
		
	_go_to_world()

# --- Settings Menu ---
func _handle_ui_main_menu(event: Notifications.MainMenuActioned) -> void:
	match event.action:
		Enums.MainMenuAction.HOST:
			_attempt_host_game()
		
		Enums.MainMenuAction.JOIN:
			_attempt_join_game()
		
		Enums.MainMenuAction.SETTINGS:
			GlobalUtils.toggle_menu(Enums.MenuType.MAIN, false)
			GlobalUtils.toggle_menu(Enums.MenuType.SETTINGS, true)
		
		Enums.MainMenuAction.QUIT:
			get_tree().quit()

func _handle_ui_settings_menu(event: Notifications.SettingsMenuActioned) -> void:
	match event.action:
		Enums.SettingsMenuAction.CLOSE:
			GlobalUtils.toggle_menu(Enums.MenuType.SETTINGS, false)
			GlobalUtils.toggle_menu(Enums.MenuType.MAIN, true)
			
			await get_tree().process_frame
			
			GlobalUtils.toggle_hud(false)
		
		Enums.SettingsMenuAction.SAVE:
			# NOTE: Main handles saving user settings
			pass
