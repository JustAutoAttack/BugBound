# Load
extends GameState

@export var object_controller: GameObjectController

var _is_first_load: bool = true
var _data: GameLoadStateData

# ===
# Built-In
# ===

func _ready() -> void:
	super()
	if not object_controller:
		push_error("Game: LOAD -> GameObjectController not assigned!")
		return

func enter(_prev_state_path: String, data: Object) -> void:
	LogSystem.log_message(
		"Enter LOAD",
		LogEnums.LogLevel.DEBUG
	)
	_subscribe_events()
	EventSystem.broadcast(
		Notifications.LoadingStarted.new()
	)
	
	# Standardize data
	if _is_first_load:
		_is_first_load = false
		_data = GameLoadStateData.new(
			GameState.StateName.TITLE, 
			false, 
			""
		)
	elif data is GameLoadStateData:
		_data = data
	else:
		LogSystem.log_message(
			"Invalid enter data. Going to Title.",
			LogEnums.LogLevel.ERROR
		)
		_transition_to(
			StateName.TITLE,
			null
		)
		return
	
	_route_load()

func exit() -> void:
	LogSystem.log_message(
		"Exit LOAD",
		LogEnums.LogLevel.DEBUG
	)
	_data = null
	EventSystem.broadcast(
		Notifications.LoadingStopped.new()
	)
	_unsubscribe_events()

func _subscribe_events() -> void:
	# Custom
	EventSystem.subscribe_to_notification(Notifications.TitleLoaded, _handle_scene_loaded)
	EventSystem.subscribe_to_notification(Notifications.WorldLoaded, _handle_scene_loaded)
	
	# Signals
	object_controller.setup_complete.connect(_on_object_controller_setup_complete)

func _unsubscribe_events() -> void:
	# Custom
	EventSystem.unsubscribe_all_for_owner(self)
	
	# Signals
	object_controller.setup_complete.disconnect(_on_object_controller_setup_complete)

# ===
# Private
# ===

func _route_load() -> void:
	match _data.target_state:
		GameState.StateName.TITLE: 
			_load_title_sequence()
		GameState.StateName.WORLD: 
			if not object_controller.is_setup:
				_load_objects()
				return
			
			object_controller.deactivate_all_pools()
			_load_world_sequence()

func _load_objects() -> void:
	if not object_controller.is_node_ready():
		await object_controller.ready
		
	object_controller.setup_pools()

func _load_title_sequence() -> void:
	EventSystem.dispatch_command(
		Commands.LoadTitle.new()
	)

func _load_world_sequence() -> void:
	# Game Save
	var game_save_data: GameSaveData
	if _data.is_new_game:
		game_save_data = ContextSystem.save_provider.load_new_game()
	else:
		game_save_data = ContextSystem.save_provider.load_game(
			_data.save_game_file_path
		)
	
	if not game_save_data:
		push_error("Game: LOAD - No save data. Loading Title")
		EventSystem.dispatch_command(
			Commands.LoadTitle.new()
		)
		return
	
	# Finalize Loading
	EventSystem.broadcast(
		Notifications.GameSaveLoaded.new(
			game_save_data
		)
	)
	
	await get_tree().process_frame
	EventSystem.dispatch_command(
		Commands.LoadWorld.new()
	)

# ===
# Events
# ===

func _handle_scene_loaded(_event: Notification) -> void:
	_transition_to(
		_data.target_state, 
		null
	)

# ===
# Signals
# ===

func _on_object_controller_setup_complete() -> void:
	_route_load()
