## Managed service to track and clean up node-specific event subscriptions.
class_name EventSubscriber
extends RefCounted

## List of currently active event subscriptions.
static var _active_subscriptions: Array[EventSubscription] = []

## Registers a subscription and tracks it for cleanup.
## [br][br]
## - [param event_bus]: Bus to subscribe to.
## [br][br]
## - [param type]: Event class type.
## [br][br]
## - [param callback]: Callback function to execute.
static func subscribe(
	event_bus: EventBus, 
	type: GDScript, 
	callback: Callable
) -> void:
	var owner: Object = callback.get_object()
	
	if not is_instance_valid(owner):
		LogSystem.log_message(
			"Callback is not bound to an object instance.",
			LogEnums.LogLevel.ERROR
		)
		return
	
	event_bus.subscribe(type, callback)
	_active_subscriptions.append(EventSubscription.new(
		event_bus,
		type,
		callback,
		owner
	))

## Removes all subscriptions associated with a specific bus.
## [br][br]
## - [param bus]: Bus to clear.
static func unsubscribe_all(bus: EventBus) -> void:
	for subscription: EventSubscription in _active_subscriptions:
		if subscription.bus == bus:
			bus.unsubscribe(
				subscription.type, 
				subscription.callback
			)
	
	# Filter out the cleared subscriptions
	_active_subscriptions = _active_subscriptions.filter(
		func(subscription: EventSubscription): 
			return subscription.bus != bus
	)

## Removes all subscriptions associated with a specific owner.
## [br][br]
## - [param owner]: Object to clear subscriptions for.
static func unsubscribe_all_for_owner(owner: Object) -> void:
	var remaining: Array[EventSubscription] = []
	
	for subscription: EventSubscription in _active_subscriptions:
		if subscription.owner == owner:
			subscription.bus.unsubscribe(
				subscription.type, 
				subscription.callback
			)
		else:
			remaining.append(subscription)
	
	_active_subscriptions = remaining

## Returns total count of active subscriptions.
static func get_active_count() -> int:
	return _active_subscriptions.size()
