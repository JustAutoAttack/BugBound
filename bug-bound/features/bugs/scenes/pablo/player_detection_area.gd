class_name PlayerPlayerDetectionArea
extends Area3D

signal player_entered_range(player: Player)
signal player_exited_range(player: Player)

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
	
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)

# ===
# Private
# ===

func _update_shape_radius() -> void:
	if not collision_shape:
		await ready
	
	print_debug("okie dokie")
	if (
		collision_shape and 
		collision_shape.shape is SphereShape3D
	):
		(collision_shape.shape as SphereShape3D).radius = radius

# ===
# Handlers
# ===

func _on_area_entered(area: Area3D) -> void:
	var player: Player = (
		area.owner as Player 
		if area.owner is Player 
		else area.get_parent() as Player
	)
	if player:
		player_entered_range.emit(player)

func _on_area_exited(area: Area3D) -> void:
	var player: Player = (
		area.owner as Player 
		if area.owner is Player 
		else area.get_parent() as Player
	)
	if player:
		player_exited_range.emit(player)
