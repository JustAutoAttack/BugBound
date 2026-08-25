class_name WorldZone
extends Node3D

@export var zone: Enums.ZoneType

@onready var navigation_region: NavigationRegion3D = $NavigationRegion3D
@onready var player_spawns: Node3D = %Spawns/Player
@onready var bug_spawner: MultiplayerSpawner = $Spawners/Bug
@onready var bug_spawns: Node3D = %Spawns/Bug
@onready var bug_instances: Node3D = %Instances/Bug
