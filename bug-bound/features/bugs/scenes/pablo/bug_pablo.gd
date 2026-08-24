class_name BugPablo
extends CharacterBody3D

@export var walk_speed: float = 3.0
@export var run_speed: float = 6.0
@export var flee_speed: float = 10.0

@onready var sprite: AnimatedSprite3D = %Sprite
