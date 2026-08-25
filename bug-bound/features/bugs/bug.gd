class_name Bug
extends CharacterBody3D

@export var walk_speed: float = 3.0
@export var run_speed: float = 6.0
@export var flee_speed: float = 10.0
# Max distance allowed to pick a new location to wander to
@export var wander_radius: float = 5.0
# Max distance allowed from initial position
@export var leash_radius: float = 12.0  

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var sprite: AnimatedSprite3D = %Sprite
@onready var player_detection_area: BugPlayerDetectionArea = $PlayerDetectionArea

var initial_position: Vector3

func _ready() -> void:
	await get_tree().process_frame
	
	initial_position = global_position
	
	EventSystem.broadcast(
		Notifications.BugSpawned.new(
			self
		)
	)
