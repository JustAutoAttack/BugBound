@tool
extends Node3D

@export var type: Enums.CactusType:
	set(value):
		type = value
		if is_node_ready():
			_update_current_variant()

@onready var tall_boy: Node3D = $TallBoy
@onready var tall_boy_wth_arms: Node3D = $TallBoyWthArms

var variants: Array[Node3D] = []
var static_bodies: Array[StaticBody3D] = []
var current_variant: Node3D:
	set(value):
		current_variant = value
		_update_view()
		_update_physics()

# ===
# Built-In
# ===

func _ready() -> void:
	variants.append(tall_boy)
	static_bodies.append(tall_boy.get_node("StaticBody3D"))
	variants.append(tall_boy_wth_arms)
	static_bodies.append(tall_boy_wth_arms.get_node("StaticBody3D"))
	
	_update_current_variant()

# ===
# Private
# ===

func _update_view() -> void:
	for variant: Node3D in variants:
		variant.hide()
	
	current_variant.show()

func _update_physics() -> void:
	var current_body: StaticBody3D = current_variant.get_node("StaticBody3D")
	if not current_body: return
	
	for body: StaticBody3D in static_bodies:
		body.set_collision_layer_value(Constants.PhysicsLayer.PROP_INDEX, false)

	current_body.set_collision_layer_value(Constants.PhysicsLayer.PROP_INDEX, true)

func _update_current_variant() -> void:
	var new_variant: Node3D = current_variant
	
	match type:
		Enums.CactusType.TALL_BOY:
			new_variant = tall_boy
		Enums.CactusType.TALL_BOY_WITH_ARMS:
			new_variant = tall_boy_wth_arms
	
	if new_variant == current_variant: return
	current_variant = new_variant
