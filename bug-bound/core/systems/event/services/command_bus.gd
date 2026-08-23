## Strict bus enforcing 1-to-1 command handling with mandatory registration
class_name CommandBus 
extends EventBus

# ===
# Built-In
# ===

func _emit_policy(event: Event) -> void:
	var script: Script = event.get_script()
	
	if script == null:
		LogSystem.log_message(
			"Event object missing script.", 
			LogEnums.LogLevel.ERROR
		)
		return

	var subs: Array = _subscribers.get(script, [])
	
	if subs.is_empty():
		LogSystem.log_message(
			"No handler registered.", 
			LogEnums.LogLevel.ERROR
		)
		return

	var handler: Callable = subs[0]
	if handler.is_valid():
		handler.call(event)
	else:
		_subscribers.erase(script)

# ===
# Public
# ===

## Registers a [Callable] as the unique handler for a command type.
## [br][br]
## - [param type]: GDScript class reference of the command to handle.
## [br][br]
## - [param callback]: Function to execute when the command is emitted.
func register_handler(type: Script, callback: Callable) -> void:
	if _subscribers.has(type):
		LogSystem.log_message(
			"Overwriting handler", 
			LogEnums.LogLevel.WARN
		)
	
	_subscribers[type] = [callback]
