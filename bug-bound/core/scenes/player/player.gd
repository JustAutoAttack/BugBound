class_name Player
extends CharacterBody3D

const WALK_SPEED: float = 5.0
const SPRINT_SPEED: float = 8.5
const JUMP_VELOCITY: float = 4.5
const ROTATION_SPEED: float = 12.0

@onready var camera_controller: PlayerCameraController = %CameraController

# ===
# Built-In 
# ===

func _physics_process(delta: float) -> void:
	# Apply gravity if airborne
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump input
	if Input.is_action_just_pressed("player_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Determine current movement speed based on sprint input state
	var current_speed: float = SPRINT_SPEED if Input.is_action_pressed("player_sprint") else WALK_SPEED

	# Gather movement input vectors
	var input_dir: Vector2 = Input.get_vector(
		"player_move_left", 
		"player_move_right", 
		"player_move_forward", 
		"player_move_backward"
	)
	
	var direction: Vector3 = Vector3.ZERO
	
	# Calculate directional movement relative to the camera's orientation
	if camera_controller and camera_controller.yaw:
		var yaw_node: Node3D = camera_controller.yaw
		var forward: Vector3 = -yaw_node.global_transform.basis.z
		var right: Vector3 = yaw_node.global_transform.basis.x
		
		# Zero out Y components to keep movement strictly horizontal
		forward.y = 0.0
		right.y = 0.0
		forward = forward.normalized()
		right = right.normalized()
		
		direction = (forward * -input_dir.y + right * input_dir.x).normalized()
	else:
		direction = (transform.basis * Vector3(input_dir.x, 0.0, input_dir.y)).normalized()

	# Apply velocity and rotate the player smoothly to face any movement direction
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
		
		var target_angle: float = atan2(-direction.x, -direction.z)
		rotation.y = lerp_angle(rotation.y, target_angle, ROTATION_SPEED * delta)
	else:
		velocity.x = move_toward(velocity.x, 0.0, WALK_SPEED)
		velocity.z = move_toward(velocity.z, 0.0, WALK_SPEED)

	move_and_slide()
