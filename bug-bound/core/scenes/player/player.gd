class_name Player
extends CharacterBody3D

const WALK_SPEED = 5.0
const SPRINT_SPEED = 8.5
const JUMP_VELOCITY = 4.5
const ROTATION_SPEED = 6.0

@onready var camera_controller: PlayerCameraController = %CameraController

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("player_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Check if sprint is held
	var current_speed = SPRINT_SPEED if Input.is_action_pressed("player_sprint") else WALK_SPEED

	# Get input direction
	var input_dir := Input.get_vector(
		"player_move_left", 
		"player_move_right", 
		"player_move_forward", 
		"player_move_backward"
	)
	
	var direction := Vector3.ZERO
	
	# Calculate movement relative to the camera controller's yaw rotation if available
	if camera_controller and camera_controller.yaw:
		var yaw_node = camera_controller.yaw
		var forward = -yaw_node.global_transform.basis.z
		var right = yaw_node.global_transform.basis.x
		direction = (forward * -input_dir.y + right * input_dir.x)
		direction.y = 0.0 # Keep movement flat on the floor
		direction = direction.normalized()
	else:
		# Fallback if camera controller isn't ready yet
		direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	# Handle movement and rotation
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
		
		# Check if the player is moving backward (input_dir.y > 0 means pressing backward/S)
		var is_moving_backward = input_dir.y > 0.1
		
		if not is_moving_backward:
			# Only rotate smoothly when moving forward, left, or right
			var target_angle = atan2(-direction.x, -direction.z)
			rotation.y = lerp_angle(rotation.y, target_angle, ROTATION_SPEED * delta)
		# When moving backward, rotation is completely skipped, 
		# allowing you to walk backwards smoothly in whatever direction you were facing.
	else:
		velocity.x = move_toward(velocity.x, 0, WALK_SPEED)
		velocity.z = move_toward(velocity.z, 0, WALK_SPEED)

	move_and_slide()
