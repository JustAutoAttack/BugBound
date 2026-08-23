## Centralized manager for application-wide event infrastructure.
extends Node

## Singleton instances of specialized buses.
var command_bus: CommandBus = CommandBus.new()
var notification_bus: NotificationBus = NotificationBus.new()

# ===
# Public
# ===

# --- Dispatching ---

## Dispatches a command to the [CommandBus].
func dispatch_command(command_event: Command) -> void:
	command_bus.emit(command_event)

## Broadcasts a notification to the [NotificationBus].
func broadcast(notification_event: Notification) -> void:
	notification_bus.emit(notification_event)

# --- Subscription ---

## Registers a handler for a specific command type.
func subscribe_to_command(type: GDScript, callback: Callable) -> void:
	EventSubscriber.subscribe(command_bus, type, callback)

## Registers a listener for a specific notification type.
func subscribe_to_notification(type: GDScript, callback: Callable) -> void:
	EventSubscriber.subscribe(notification_bus, type, callback)

# --- Lifecycle ---

## Removes all command subscriptions associated with the provided [param owning_object].
func unsubscribe_all_for_owner(owning_object: Object) -> void:
	EventSubscriber.unsubscribe_all_for_owner(owning_object)

## Clears all existing subscriptions for the [CommandBus].
func clear_commands() -> void:
	EventSubscriber.unsubscribe_all(command_bus)

## Clears all existing subscriptions for the [NotificationBus].
func clear_notifications() -> void:
	EventSubscriber.unsubscribe_all(notification_bus)
