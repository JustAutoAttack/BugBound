## Data container for tracking individual event subscriptions.
class_name EventSubscription
extends RefCounted

## EventBus associated with this subscription.
var bus: EventBus
## GDScript class reference of the event type.
var type: GDScript
## Function to execute when the event is emitted.
var callback: Callable
## Object that owns this subscription.
var owner: Object

func _init(
	p_bus: EventBus,
	p_type: GDScript,
	p_callback: Callable,
	p_owner: Object
) -> void:
	bus = p_bus
	type = p_type
	callback = p_callback
	owner = p_owner
