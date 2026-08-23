# Boot
extends MainState

# TODO Hook into settings context
@export var enabled: bool = true

# ===
# Built-In
# ===

func enter(_prev_state_path: String, _data: Object) -> void:
	LogSystem.log_message(
		"Enter BOOT",
		LogEnums.LogLevel.DEBUG
	)
	
	if enabled:
		_subscribe_events()
		EventSystem.dispatch_command(
			Commands.LoadBootsplash.new()
		)

	else:
		_transition_to(
			StateName.GAME, 
			null
		)

func exit() -> void:
	LogSystem.log_message(
		"Exit BOOT",
		LogEnums.LogLevel.DEBUG
	)
	_unsubscribe_events()

func _subscribe_events() -> void:
	EventSystem.subscribe_to_notification(Notifications.BootsplashLoaded, _handle_bootsplash_loaded)

func _unsubscribe_events() -> void:
	EventSystem.unsubscribe_all_for_owner(self)

# ===
# Events
# ===

func _handle_bootsplash_loaded(_event: Notifications.BootsplashLoaded) -> void:
	LogSystem.log_message(
		"Bootsplash Loaded",
		LogEnums.LogLevel.DEBUG
	)
	_transition_to(
		StateName.GAME, 
		null
	)
