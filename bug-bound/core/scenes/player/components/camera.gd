class_name PlayerCameraController
extends Node3D

@export_category("Camera Settings")
@export var target_boom_length: float = 4.0
@export var boom_transition_speed: float = 3.0
@export var pitch_degrees_x: float = -30.0

@export_category("Edge Look Settings")
@export var look_ahead_intensity: float = 1.5 
@export var look_smoothing: float = 4.0

@export_category("Follow Settings")
@export var follow_lag_speed: float = 10.0
@export var camera_rotation_lag: float = 4.0

@onready var yaw: Node3D = %Yaw
@onready var pitch: Node3D = %Pitch
@onready var boom: SpringArm3D = %Boom
@onready var camera: Camera3D = %Camera

var _current_tween: Tween
var _current_offset: Vector2 = Vector2.ZERO

# === Built-In Methods ===

func _ready() -> void:
	top_level = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	pitch.rotation_degrees.x = pitch_degrees_x
	_update_camera_distance()

func _process(delta: float) -> void:
	_follow_target(delta)
	_handle_camera_orientation(delta)

# === Public Methods ===

func set_boom_length(new_length: float) -> void:
	target_boom_length = new_length
	_update_camera_distance()

# === Private Methods ===

func _follow_target(delta: float) -> void:
	var target_node = get_parent()
	if not target_node is Node3D:
		return
		
	# Smoothly lag the camera rig's global position toward the player's position
	global_position = global_position.lerp(
		target_node.global_position, 
		follow_lag_speed * delta
	)

func _handle_camera_orientation(delta: float) -> void:
	var target_node = get_parent()
	if not target_node is Node3D:
		return

	# Calculate normalized cursor offset from the center of the screen
	var viewport = get_viewport()
	if viewport:
		var mouse_pos = viewport.get_mouse_position()
		var screen_size = viewport.get_visible_rect().size
		if screen_size.x > 0 and screen_size.y > 0:
			var target_offset = Vector2(
				(mouse_pos.x / screen_size.x) * 2.0 - 1.0,
				(mouse_pos.y / screen_size.y) * 2.0 - 1.0
			)
			_current_offset = _current_offset.lerp(target_offset, look_smoothing * delta)

	# Smoothly rotate the camera yaw to follow the player's orientation
	var target_yaw = target_node.global_rotation.y
	yaw.global_rotation.y = lerp_angle(
		yaw.global_rotation.y, 
		target_yaw, 
		camera_rotation_lag * delta
	)

	# Apply a subtle edge-screen look-ahead offset on top of the camera rotation
	var look_offset_adjustment = _current_offset.x * (look_ahead_intensity * 0.3)
	yaw.rotation.y -= look_offset_adjustment * delta

func _update_camera_distance() -> void:
	if _current_tween and _current_tween.is_running():
		_current_tween.kill()
		
	# Smoothly transition boom length changes using a tween
	_current_tween = create_tween()
	_current_tween.tween_property(
		boom, 
		"spring_length", 
		target_boom_length,
		1.0 / boom_transition_speed
	).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
