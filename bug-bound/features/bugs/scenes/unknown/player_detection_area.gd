@tool
class_name PlayerDetectionArea
extends Area3D

signal player_entered_range(player: Player)
signal player_exited_range(player: Player)

@export_category("Settings")
@export var radius: float = 2.0:
	set(value):
		radius = value
		_update_shape_radius()

@onready var collision_shape: CollisionShape3D = $CollisionShape3D

# ===
# Built-In
# ===

func _ready() -> void:
	_update_shape_radius()
	
	if not Engine.is_editor_hint():
		body_entered.connect(_on_body_entered)
		body_exited.connect(_on_body_exited)

# ===
# Private
# ===

func _update_shape_radius() -> void:
	if not collision_shape:
		return
	
	if not collision_shape.shape:
		collision_shape.shape = SphereShape3D.new()
	
	if collision_shape.shape is SphereShape3D:
		(collision_shape.shape as SphereShape3D).radius = radius

func _get_player_from_node(node: Node) -> Player:
	if node is Player:
		return node as Player
	if node.owner is Player:
		return node.owner as Player
	if node.get_parent() is Player:
		return node.get_parent() as Player
	return null

# ===
# Handlers
# ===

func _on_body_entered(body: Node3D) -> void:
	var player: Player = _get_player_from_node(body)
	if player:
		player_entered_range.emit(player)

func _on_body_exited(body: Node3D) -> void:
	var player: Player = _get_player_from_node(body)
	if player:
		player_exited_range.emit(player)
