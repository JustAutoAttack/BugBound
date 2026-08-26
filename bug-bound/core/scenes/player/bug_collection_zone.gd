@tool
class_name BugCollectionZone
extends Area3D

signal bug_entered_range(bug: Bug)
signal bug_exited_range(bug: Bug)

@export_category("Settings")
@export var radius: float = 2.0:
	set(value):
		radius = value
		if is_node_ready():
			_update_shape_radius()

@onready var collision_shape: CollisionShape3D = $CollisionShape3D

# ===
# Built-In
# ===

func _ready() -> void:
	_update_shape_radius()
	
	# Optional: Prevent signals from firing or processing gameplay logic inside the editor window
	if Engine.is_editor_hint():
		return
	
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)

# ===
# Private
# ===

func _update_shape_radius() -> void:
	if not collision_shape:
		await ready
		
	if (
		collision_shape and 
		collision_shape.shape is SphereShape3D
	):
		(collision_shape.shape as SphereShape3D).radius = radius

# ===
# Handlers
# ===

func _on_area_entered(area: Area3D) -> void:
	var bug: Bug = (
		area.owner as Bug 
		if area.owner is Bug 
		else area.get_parent() as Bug
	)
	if bug:
		bug_entered_range.emit(bug)

func _on_area_exited(area: Area3D) -> void:
	var bug: Bug = (
		area.owner as Bug 
		if area.owner is Bug 
		else area.get_parent() as Bug
	)
	if bug:
		bug_exited_range.emit(bug)
