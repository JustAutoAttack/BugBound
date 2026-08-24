
class_name Player
extends CharacterBody3D

const WALK_SPEED = 5.0
const SPRINT_SPEED = 8.5
const JUMP_VELOCITY = 4.5
const ROTATION_SPEED = 6.0

@onready var camera_controller: PlayerCameraController = %CameraController

# === Physics Processing ===

func _physics_process(delta: float) -> void:
	# Apply gravity if airborne
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump input
	if Input.is_action_just_pressed("player_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Determine current movement speed based on sprint input state
	var current_speed = SPRINT_SPEED if Input.is_action_pressed("player_sprint") else WALK_SPEED

	# Gather movement input vectors
	var input_dir := Input.get_vector(
		"player_move_left", 
		"player_move_right", 
		"player_move_forward", 
		"player_move_backward"
	)
	
	var direction := Vector3.ZERO
	
	# Calculate directional movement relative to the camera's orientation
	if camera_controller and camera_controller.yaw:
		var yaw_node = camera_controller.yaw
		var forward = -yaw_node.global_transform.basis.z
		var right = yaw_node.global_transform.basis.x
		direction = (forward * -input_dir.y + right * input_dir.x)
		direction.y = 0.0
		direction = direction.normalized()
	else:
		direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	# Apply velocity and handle facing direction rotation
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
		
		# Check if moving backward to prevent unwanted body rotation spinning
		var is_moving_backward = input_dir.y > 0.1
		if not is_moving_backward:
			var target_angle = atan2(-direction.x, -direction.z)
			rotation.y = lerp_angle(rotation.y, target_angle, ROTATION_SPEED * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, WALK_SPEED)
		velocity.z = move_toward(velocity.z, 0, WALK_SPEED)

	move_and_slide()
