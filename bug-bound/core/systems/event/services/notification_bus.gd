## Broadcast bus supporting many-to-many notification dispatching
class_name NotificationBus 
extends EventBus

# ===
# Built-In
# ===

func _emit_policy(event: Event) -> void:
	var type: Script = event.get_script() as Script
	if _subscribers.has(type):
		var subs: Array[Callable] = _subscribers[type] as Array[Callable]
		for callback: Callable in subs.duplicate():
			if callback.is_valid():
				callback.call(event)
			else:
				subs.erase(callback)
