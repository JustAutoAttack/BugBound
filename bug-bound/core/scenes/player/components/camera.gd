class_name PlayerCameraController
extends Node3D

@export_category("Camera Settings")
@export var target_boom_length: float = 4.0
@export var boom_transition_speed: float = 3.0
@export var pitch_degrees_x: float = -30.0
@export var mouse_sensitivity: float = 0.003

@export_category("Edge Look Settings")
@export var look_ahead_intensity_x: float = 1.2  # Horizontal nudge distance
@export var look_ahead_intensity_y: float = 0.8  # Vertical nudge distance
@export var look_smoothing: float = 4.0

@export_category("Follow Settings")
@export var follow_lag_speed: float = 10.0

@onready var yaw: Node3D = %Yaw
@onready var pitch: Node3D = %Pitch
@onready var boom: SpringArm3D = %Boom
@onready var camera: Camera3D = %Camera

var _current_tween: Tween
var _current_offset: Vector2 = Vector2.ZERO
var _is_panning: bool = false
var _base_boom_position: Vector3 = Vector3.ZERO

# ===
# Built-In
# ===

func _ready() -> void:
	top_level = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	pitch.rotation_degrees.x = pitch_degrees_x
	_update_camera_distance()
	
	if boom:
		_base_boom_position = boom.position

func _unhandled_input(event: InputEvent) -> void:
	var player_node: Node = get_parent()
	if player_node and player_node.has_method("is_multiplayer_authority") and not player_node.is_multiplayer_authority():
		return

	if event is InputEventMouseMotion and _is_panning:
		yaw.rotation.y -= event.relative.x * mouse_sensitivity
		pitch.rotation.x -= event.relative.y * mouse_sensitivity
		# Clamp pitch to prevent flipping upside down
		pitch.rotation.x = clamp(pitch.rotation.x, deg_to_rad(-89.0), deg_to_rad(89.0))

func _process(delta: float) -> void:
	var player_node: Node = get_parent()
	if player_node and player_node.has_method("is_multiplayer_authority") and not player_node.is_multiplayer_authority():
		if player_node is Node3D:
			global_position = global_position.lerp(player_node.global_position, follow_lag_speed * delta)
		return

	_handle_pan_input()
	_follow_target(delta)
	_handle_camera_orientation(delta)

# ===
# Public
# ===

func set_boom_length(new_length: float) -> void:
	target_boom_length = new_length
	_update_camera_distance()

# ===
# Private
# ===

func _handle_pan_input() -> void:
	var panning_now: bool = Input.is_action_pressed("camera_pan")
	if panning_now != _is_panning:
		_is_panning = panning_now
		if _is_panning:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		else:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _follow_target(delta: float) -> void:
	var target_node: Node = get_parent()
	if not target_node is Node3D:
		return
		
	# Smoothly lag the camera rig's global position toward the player's position
	global_position = global_position.lerp(
		(target_node as Node3D).global_position, 
		follow_lag_speed * delta
	)

func _handle_camera_orientation(delta: float) -> void:
	# When not actively panning, calculate 2D screen-edge look offsets
	if not _is_panning:
		var viewport: Viewport = get_viewport()
		if viewport:
			var mouse_pos: Vector2 = viewport.get_mouse_position()
			var screen_size: Vector2 = viewport.get_visible_rect().size
			if screen_size.x > 0.0 and screen_size.y > 0.0:
				# Map mouse from [0, size] to range [-1.0, 1.0]
				var target_offset: Vector2 = Vector2(
					(mouse_pos.x / screen_size.x) * 2.0 - 1.0,
					(mouse_pos.y / screen_size.y) * 2.0 - 1.0
				)
				_current_offset = _current_offset.lerp(target_offset, look_smoothing * delta)
	else:
		_current_offset = _current_offset.lerp(Vector2.ZERO, look_smoothing * delta)

	# Apply 2D local translation offsets to the spring arm based on mouse position
	if boom:
		var offset_x: float = _current_offset.x * look_ahead_intensity_x
		var offset_y: float = -_current_offset.y * look_ahead_intensity_y # Invert Y so up on screen moves view up
		
		var target_pos: Vector3 = _base_boom_position + Vector3(offset_x, offset_y, 0.0)
		boom.position = boom.position.lerp(target_pos, look_smoothing * delta)

func _update_camera_distance() -> void:
	if _current_tween and _current_tween.is_running():
		_current_tween.kill()
		
	_current_tween = create_tween()
	_current_tween.tween_property(
		boom, 
		"spring_length", 
		target_boom_length,
		1.0 / boom_transition_speed
	).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
