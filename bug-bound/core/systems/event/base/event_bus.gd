## Base transport layer for event-driven communication.
##
## Provides functionality for registering subscribers and dispatching events. 
## It supports re-entrant queuing, ensuring that events emitted during the 
## processing of another event are handled sequentially once the current 
## emission cycle completes.
class_name EventBus 
extends RefCounted

## Mapping of event types to their list of subscriber Callables.
var _subscribers: Dictionary[Script, Array] = {}

## Queue holding events triggered during an existing emission cycle.
var _event_queue: Array[Object] = []

## Flag indicating if an emission cycle is currently active.
var _is_emitting: bool = false

## Utility property to check if there are pending events in the queue.
var _can_emit: bool:
	get: return not _event_queue.is_empty()

# ===
# Public
# ===

## Registers a [Callable] to be executed when the specified event type is emitted.
## [br][br]
## - [param type]: GDScript class reference of the event to subscribe to.
## [br][br]
## - [param callback]: Function to execute when the event is emitted.
func subscribe(type: Script, callback: Callable) -> void:
	if not _subscribers.has(type): 
		_subscribers[type] = [] as Array[Callable]
	
	var subs: Array[Callable] = _subscribers[type] as Array[Callable]
	if not subs.has(callback): 
		subs.append(callback)

## Removes a specific [Callable] subscription for the given event type.
## [br][br]
## - [param type]: GDScript class reference of the event to unsubscribe from.
## [br][br]
## - [param callback]: Specific function to remove.
func unsubscribe(
	type: GDScript, 
	callback: Callable
) -> void:
	if _subscribers.has(type): 
		_subscribers[type].erase(callback)

## Dispatches an event to its subscribers. If an emission is already in progress, 
## the event is queued to ensure sequential processing and prevent recursion issues.
## [br][br]
## - [param event]: Event object to emit.
func emit(event: Event) -> void:
	if _is_emitting:
		_log_event("Queueing", event)
		_event_queue.append(event)
		return
	
	_log_event("Emitting", event)
	_is_emitting = true
	_emit_policy(event)
	_is_emitting = false
	
	while _can_emit:
		emit(_event_queue.pop_front())

# ===
# Private
# ===

## Defines the delivery logic for specific event types. 
## Must be implemented by child classes to enforce bus-specific policies.
## [br][br]
## - [param _event]: Event object being processed.
func _emit_policy(_event: Event) -> void:
	assert(
		false, 
		"Must implement _emit_policy in child bus"
	)

## Logs event activity with the [LogSystem].
## [br][br]
## - [param status]: Status tracking label.
## [br][br]
## - [param event]: Event object to log.
func _log_event(
	status: String, 
	event: Event
) -> void:
	LogSystem.log_message(
		"{0} event: {1}".format([status, event.string_name]),
		LogEnums.LogLevel.DEBUG
	)
