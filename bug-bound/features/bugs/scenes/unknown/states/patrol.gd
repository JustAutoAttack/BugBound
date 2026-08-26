# Patrol
extends BugUnknownState

@export var idle_duration_range: Vector2 = Vector2(1.0, 3.0)
@export var walk_duration_range: Vector2 = Vector2(3.0, 5.0)

@onready var switch_timer: Timer = $SwitchTimer

enum SubState {
	IDLE,
	WALK
}

var current_substate: SubState:
	set(value):
		current_substate = value
		_on_current_substate_updated()

var origin_position: Vector3 = Vector3.INF

# ===
# Built-In
# ===

func enter(prev_state_path: String, _data: Object) -> void:
	if not switch_timer.timeout.is_connected(_on_switch_timer_timeout):
		switch_timer.timeout.connect(_on_switch_timer_timeout)
	current_substate = SubState.IDLE
	origin_position = (
		_owner.global_position 
		if prev_state_path.is_empty() 
		else _owner.initial_position
	)


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
		# Check if agent reached its target destination
		if _owner.nav_agent.is_navigation_finished():
			current_substate = SubState.IDLE
			return
			
		# Get next path position from the nav agent
		var current_pos: Vector3 = _owner.global_position
		var next_pos: Vector3 = _owner.nav_agent.get_next_path_position()
		var move_dir: Vector3 = (next_pos - current_pos).normalized()
		
		_owner.velocity.x = move_dir.x * _owner.walk_speed
		_owner.velocity.z = move_dir.z * _owner.walk_speed
		
		# Smoothly rotate toward movement direction
		if move_dir.length_squared() > 0.001:
			var target_angle: float = atan2(-move_dir.x, -move_dir.z)
			_owner.rotation.y = lerp_angle(_owner.rotation.y, target_angle, 10.0 * delta)
	
	elif current_substate == SubState.IDLE:
		_owner.velocity.x = move_toward(
			_owner.velocity.x, 
			0, 
			_owner.walk_speed * delta
		)
		_owner.velocity.z = move_toward(
			_owner.velocity.z, 
			0, 
			_owner.walk_speed * delta
		)
	
	_owner.move_and_slide()

# ===
# Private
# ===

func _get_random_navigation_point() -> Vector3:
	var random_angle: float = randf() * TAU
	var random_dist: float = randf_range(
		1.0, 
		_owner.wander_radius
	)
	var offset: Vector3 = Vector3(
		cos(random_angle), 
		0, 
		sin(random_angle)
	) * random_dist
	
	# Anchor the wander candidate around the bug's home position instead of current position
	var candidate: Vector3 = _owner.initial_position + offset
	
	# Enforce the leash radius constraint to prevent drifting out of the forest
	if _owner.initial_position.distance_to(candidate) > _owner.leash_radius:
		candidate = _owner.initial_position + (_owner.initial_position.direction_to(candidate) * _owner.leash_radius)
	
	var map: RID = _owner.get_world_3d().navigation_map
	return NavigationServer3D.map_get_closest_point(map, candidate)
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
	var switch_time_duration: float = 0.0
	
	match current_substate:
		SubState.IDLE:
			switch_time_duration = randf_range(
				idle_duration_range.x, 
				idle_duration_range.y
			)
			_owner.velocity.x = 0.0
			_owner.velocity.z = 0.0
			
		SubState.WALK:
			switch_time_duration = randf_range(
				walk_duration_range.x, 
				walk_duration_range.y
			)
			
			# Pick a safe random point on the Navigation Mesh
			var random_point: Vector3 = _get_random_navigation_point()
			_owner.nav_agent.target_position = random_point
	
	switch_timer.wait_time = switch_time_duration
	switch_timer.start()
