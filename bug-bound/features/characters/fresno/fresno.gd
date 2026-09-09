class_name Fresno
extends CharacterBody3D

const JUMP_GRAVITY_MULTIPLIER: float = 1.8
const TERMINAL_VELOCITY: float = -25.0
const FALL_ACCELERATION_RATE: float = 3.0

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		var gravity_vector: Vector3 = get_gravity()
		if velocity.y > 0.0:
			velocity += gravity_vector * JUMP_GRAVITY_MULTIPLIER * delta
		else:
			velocity.y = move_toward(velocity.y, TERMINAL_VELOCITY, gravity_vector.length() * FALL_ACCELERATION_RATE * delta)
