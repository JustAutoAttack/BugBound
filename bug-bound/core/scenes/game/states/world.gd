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
	
	GlobalUtils.toggle_hud(true)
	
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
		
		var is_pause_open: bool = ContextSystem.ui_provider.is_menu_open(Enums.MenuType.PAUSE)
		
		if ContextSystem.ui_context.open_menus.size() > 0:
			EventSystem.dispatch_command(
				Commands.PlaySFX.new(
					Enums.SFXType.UI_MENU_CLOSED
				)
			)
			EventSystem.dispatch_command(
				Commands.HideAllMenus.new()
			)
			
			# If the pause menu was open, close it without affecting game tree pause state
			if is_pause_open:
				_emit_pause_updated(false)
			
			return
		
		# Open the pause menu without pausing the game tree
		_toggle_pause(true)

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
	GlobalUtils.toggle_menu(
		Enums.MenuType.PAUSE, 
		is_paused
	)
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
	match event.action:
		Enums.PauseMenuAction.RESUME:
			GlobalUtils.toggle_menu(Enums.MenuType.PAUSE, false)
		
		Enums.PauseMenuAction.SETTINGS:
			GlobalUtils.toggle_menu(Enums.MenuType.PAUSE, false)
			GlobalUtils.toggle_menu(Enums.MenuType.SETTINGS, true)
		
		Enums.PauseMenuAction.EXIT:
			GlobalUtils.toggle_menu(Enums.MenuType.PAUSE, false)
			NetworkSystem.close_connection()
			_go_to_title()
			return
		
		Enums.PauseMenuAction.QUIT:
			NetworkSystem.close_connection()
			get_tree().quit()
			return
	

func _handle_ui_settings_menu(event: Notifications.SettingsMenuActioned) -> void:
	match event.action:
		Enums.SettingsMenuAction.CLOSE:
			GlobalUtils.toggle_menu(Enums.MenuType.SETTINGS, false)
			GlobalUtils.toggle_menu(Enums.MenuType.PAUSE, true)
			
			await get_tree().process_frame
			
			GlobalUtils.toggle_hud(true)
		
		Enums.SettingsMenuAction.SAVE:
			# TODO: Save user settings with ContextSystem
			pass
