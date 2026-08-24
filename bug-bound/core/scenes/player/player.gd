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

func _ready() -> void:
	if is_multiplayer_authority() and camera_controller and camera_controller.camera:
		camera_controller.camera.current = true

	await get_tree().process_frame
	
	EventSystem.broadcast(
		Notifications.PlayerSpawned.new(
			self
		)
	)

func _physics_process(delta: float) -> void:
	# Non-authority peers rely on the MultiplayerSynchronizer for movement updates.
	if not is_multiplayer_authority():
		return

	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("player_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var current_speed: float = SPRINT_SPEED if Input.is_action_pressed("player_sprint") else WALK_SPEED

	var input_dir: Vector2 = Input.get_vector(
		"player_move_left", 
		"player_move_right", 
		"player_move_forward", 
		"player_move_backward"
	)
	
	var direction: Vector3 = Vector3.ZERO
	
	if camera_controller and camera_controller.yaw:
		var yaw_node: Node3D = camera_controller.yaw
		var forward: Vector3 = -yaw_node.global_transform.basis.z
		var right: Vector3 = yaw_node.global_transform.basis.x
		
		forward.y = 0.0
		right.y = 0.0
		forward = forward.normalized()
		right = right.normalized()
		
		direction = (forward * -input_dir.y + right * input_dir.x).normalized()
	else:
		direction = (transform.basis * Vector3(input_dir.x, 0.0, input_dir.y)).normalized()

	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
		
		var target_angle: float = atan2(-direction.x, -direction.z)
		rotation.y = lerp_angle(rotation.y, target_angle, ROTATION_SPEED * delta)
	else:
		velocity.x = move_toward(velocity.x, 0.0, WALK_SPEED)
		velocity.z = move_toward(velocity.z, 0.0, WALK_SPEED)

	move_and_slide()
