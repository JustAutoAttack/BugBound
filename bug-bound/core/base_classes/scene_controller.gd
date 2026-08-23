## Base controller for scene management.
class_name SceneController
extends Node

var current_scene: Node

## Removes current scene and adds a new one.
func _replace_current(new: Node) -> void:
	if current_scene:
		current_scene.queue_free()
		current_scene = null
	
	current_scene = new
	add_child(current_scene)

func _ready() -> void:
	_subscribe_events()

func _exit_tree() -> void:
	_unsubscribe_events()

## Override in child classes to register events.
func _subscribe_events() -> void: pass

## Automatically cleans up all subscriptions for this controller.
func _unsubscribe_events() -> void:
	EventSystem.unsubscribe_all_for_owner(self)
