# Patrol
extends BugPabloState

@export var idle_duration_range: Vector2 = Vector2(1.0, 3.0)
@export var walk_duration_range: Vector2 = Vector2(3.0, 5.0)

# TODO: Audio threshold for alerted
# TODO: Alert meter crap

@onready var switch_timer: Timer = $SwitchTimer

enum SubState {
	IDLE,
	WALK
}

var current_move_dir: Vector3 = Vector3.ZERO
var current_speed: float = 0.0
var current_substate: SubState:
	set(value):
		current_substate = value
		_on_current_substate_updated()

# ===
# Built-In
# ===

func enter(_prev_state_path: String, _data: Object) -> void:
	if not switch_timer.timeout.is_connected(_on_switch_timer_timeout):
		switch_timer.timeout.connect(_on_switch_timer_timeout)
	current_substate = SubState.IDLE

func exit() -> void: 
	switch_timer.stop()
	if switch_timer.timeout.is_connected(_on_switch_timer_timeout):
		switch_timer.timeout.disconnect(_on_switch_timer_timeout)

func physics_update(delta: float) -> void:
	var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
	
	if not _owner.is_on_floor():
		_owner.velocity.y -= gravity * delta
	else:
		_owner.velocity.y = -0.1
	
	if current_substate == SubState.WALK:
		_owner.velocity.x = current_move_dir.x * current_speed
		_owner.velocity.y = current_move_dir.y * current_speed
	elif current_substate == SubState.IDLE:
		_owner.velocity.x = move_toward(_owner.velocity.x, 0, current_speed * delta)
		_owner.velocity.y = move_toward(_owner.velocity.y, 0, current_speed * delta)
	
	_owner.move_and_slide()

# === 
# Handlers
# ===

func _on_switch_timer_timeout() -> void:
	match current_substate:
		SubState.IDLE:
			current_substate = SubState.WALK
		SubState.WALK:
			current_substate = SubState.IDLE

func _on_current_substate_updated() -> void:
	var anim_string: String = ""
	var switch_time_duration: float = 0.0
	
	match current_substate:
		SubState.IDLE:
			anim_string = "idle"
			switch_time_duration = randf_range(
				idle_duration_range.x, 
				idle_duration_range.y
			)
			current_speed = 0.0
			current_move_dir = Vector3.ZERO
		SubState.WALK:
			anim_string = "move"
			switch_time_duration = randf_range(
				walk_duration_range.x, 
				walk_duration_range.y
			)
			current_speed = _owner.walk_speed
			
			# Pick a random direction on the XZ plane
			var random_angle: float = randf() * TAU
			current_move_dir = Vector3(
				cos(random_angle), 
				0, 
				sin(random_angle)
			)
			_owner.rotation.y = random_angle
	
	_owner.sprite.play(anim_string)
	switch_timer.wait_time = switch_time_duration
	switch_timer.start()
