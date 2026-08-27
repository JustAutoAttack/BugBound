# World
extends GameState

var _is_game_over: bool = false

# ===
# Built-In
# ===

func enter(_prev_state_path: String, _data: Object) -> void:
	LogSystem.log_message(
		"Enter WORLD State",
		LogEnums.LogLevel.DEBUG
	)
	ContextSystem.is_in_world = true
	_subscribe_events()
	
	# Hide all UI
	EventSystem.dispatch_command(
		Commands.HideAllUI.new()
	)
	
	await get_tree().process_frame
	
	# Show HUD
	EventSystem.dispatch_command(
		Commands.ToggleHUD.new(
			true
		)
	)
	
	# Start Music
	EventSystem.dispatch_command(
		Commands.StartWorldMusic.new()
	)

func exit() -> void:
	LogSystem.log_message(
		"Exit WORLD State",
		LogEnums.LogLevel.DEBUG
	)
	get_tree().paused = false
	
	# Hide all UI
	EventSystem.dispatch_command(
		Commands.HideAllUI.new()
	)
	
	# Kill all SFX
	EventSystem.dispatch_command(
		Commands.KillAllSFX.new()
	)

	ContextSystem.reset_game()
	_is_game_over = false
	_unsubscribe_events()

func handle_input(event: InputEvent) -> void:
	var is_game_over: bool = ContextSystem.ui_provider.is_menu_open(Enums.MenuType.GAME_OVER)
	
	if event.is_action_pressed("game_pause_resume"):
		if is_game_over: return
		
		if ContextSystem.ui_context.open_menus.size() > 0:
			EventSystem.dispatch_command(
				Commands.PlaySFX.new(
					Enums.SFXType.UI_MENU_CLOSED
				)
			)
			EventSystem.dispatch_command(
				Commands.HideAllMenus.new()
			)

			if get_tree().paused:
				_toggle_pause(false)
			
			return
		
		_toggle_pause(not get_tree().paused)

func _subscribe_events() -> void:
	EventSystem.subscribe_to_notification(Notifications.PauseMenuActioned, _handle_ui_pause_menu)
	EventSystem.subscribe_to_notification(Notifications.SettingsMenuActioned, _handle_ui_settings_menu)
	
	if not multiplayer.server_disconnected.is_connected(_handle_server_disconnected):
		multiplayer.server_disconnected.connect(_handle_server_disconnected)
	if not multiplayer.peer_disconnected.is_connected(_handle_peer_disconnected):
		multiplayer.peer_disconnected.connect(_handle_peer_disconnected)

func _unsubscribe_events() -> void:
	EventSystem.unsubscribe_all_for_owner(self)
	
	if multiplayer.server_disconnected.is_connected(_handle_server_disconnected):
		multiplayer.server_disconnected.disconnect(_handle_server_disconnected)
	if multiplayer.peer_disconnected.is_connected(_handle_peer_disconnected):
		multiplayer.peer_disconnected.disconnect(_handle_peer_disconnected)

# ===
# Private
# ===

func _emit_toggle_pause_menu(is_paused: bool) -> void:
	EventSystem.dispatch_command(
		Commands.ToggleMenu.new(
			Enums.MenuType.PAUSE, 
			is_paused
		)
	)

func _emit_pause_updated(is_paused: bool) -> void:
	if is_paused:
		EventSystem.broadcast(
			Notifications.Paused.new()
		)
		return
	
	EventSystem.broadcast(
		Notifications.Resumed.new()
	)

func _toggle_pause(is_paused: bool) -> void:
	get_tree().paused = is_paused
	_emit_toggle_pause_menu(is_paused)
	_emit_pause_updated(is_paused)

func _go_to_title() -> void:
	_transition_to(
		StateName.LOAD, 
		GameLoadStateData.new(
			StateName.TITLE, 
			false,
            ""
		)
	)

# ===
# Handlers
# ===

# --- Network ---
func _handle_server_disconnected() -> void:
	LogSystem.log_message(
		"Server disconnected, returning to title.", 
		LogEnums.LogLevel.WARN
	)
	NetworkSystem.close_connection()
	_go_to_title()

func _handle_peer_disconnected(id: int) -> void:
	LogSystem.log_message(
		"Peer %d disconnected." % id, 
		LogEnums.LogLevel.INFO
	)
	if multiplayer.is_server():
		EventSystem.dispatch_command(
			Commands.DespawnPlayer.new(id)
		)

# --- UI ---
func _handle_ui_pause_menu(event: Notifications.PauseMenuActioned) -> void:
	var close_menu: bool = false
	
	match event.action:
		Enums.PauseMenuAction.RESUME:
			close_menu = true
			_toggle_pause(false)
		
		Enums.PauseMenuAction.SETTINGS:
			close_menu = true
			
			EventSystem.dispatch_command(
				Commands.ToggleMenu.new(
					Enums.MenuType.PAUSE, 
					false
				)
			)
			
			EventSystem.dispatch_command(
				Commands.ToggleMenu.new(
					Enums.MenuType.SETTINGS, 
					true
				)
			)
		
		Enums.PauseMenuAction.EXIT:
			close_menu = true
			NetworkSystem.close_connection()
			_go_to_title()
			return
		
		Enums.PauseMenuAction.QUIT:
			NetworkSystem.close_connection()
			get_tree().quit()
			return
	
	if close_menu:
		EventSystem.dispatch_command(
			Commands.ToggleMenu.new(
				Enums.MenuType.PAUSE, 
				false
			)
		)

func _handle_ui_settings_menu(event: Notifications.SettingsMenuActioned) -> void:
	match event.action:
		Enums.SettingsMenuAction.SAVE:
			EventSystem.dispatch_command(
				Commands.ToggleMenu.new(
					Enums.MenuType.SETTINGS,
					false
				)
			)
			
			EventSystem.dispatch_command(
				Commands.ToggleMenu.new(
					Enums.MenuType.PAUSE,
					true
				)
			)
			
			await get_tree().process_frame
			
			EventSystem.dispatch_command(
				Commands.ToggleHUD.new(
					false
				)
			)
