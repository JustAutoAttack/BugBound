class_name Player
extends CharacterBody3D

enum MoveState {
	WALK,
	SPRINT,
	SNEAK
}

const WALK_SPEED: float = 5.0
const SPRINT_SPEED: float = 8.5
const SNEAK_SPEED: float = 2.5
const JUMP_VELOCITY: float = 9.0 # 9.0 Jumps to player height
const ROTATION_SPEED: float = 12.0
const JUMP_GRAVITY_MULTIPLIER: float = 1.8
const TERMINAL_VELOCITY: float = -25.0
const FALL_ACCELERATION_RATE: float = 3.0

@onready var camera_controller: PlayerCameraController = %CameraController

var current_move_state: MoveState = MoveState.WALK

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
		var gravity_vector: Vector3 = get_gravity()
		if velocity.y > 0.0:
			velocity += gravity_vector * JUMP_GRAVITY_MULTIPLIER * delta
		else:
			velocity.y = move_toward(velocity.y, TERMINAL_VELOCITY, gravity_vector.length() * FALL_ACCELERATION_RATE * delta)

	if Input.is_action_just_pressed("player_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	current_move_state = _determine_move_state()
	var current_speed: float = _get_speed_for_state(current_move_state)

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

# ===
# Private
# ===

func _determine_move_state() -> MoveState:
	var is_sprinting: bool = Input.is_action_pressed("player_sprint")
	var is_sneaking: bool = Input.is_action_pressed("player_sneak")
	
	if is_sprinting and is_sneaking:
		if current_move_state == MoveState.SPRINT:
			return MoveState.SPRINT
		if current_move_state == MoveState.SNEAK:
			return MoveState.SNEAK
		return MoveState.WALK
		
	if is_sprinting:
		return MoveState.SPRINT
		
	if is_sneaking:
		return MoveState.SNEAK
		
	return MoveState.WALK

func _get_speed_for_state(move_state: MoveState) -> float:
	match move_state:
		MoveState.SPRINT:
			return SPRINT_SPEED
		MoveState.SNEAK:
			return SNEAK_SPEED
		_:
			return WALK_SPEED
