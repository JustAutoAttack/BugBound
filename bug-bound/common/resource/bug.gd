class_name BugData
extends Resource

@export var id: Enums.BugID
@export var combat_stats: Dictionary[Enums.BugCombatStat, int] = {}
@export var level: int = 1
@export var xp: int = 0
@export var health: int = 1
@export var movement_speed: float = 3.0

func _init() -> void:
	combat_stats = {
		Enums.BugCombatStat.HEALTH: 1,
		Enums.BugCombatStat.ATTACK: 1,
		Enums.BugCombatStat.DEFENSE: 1,
		Enums.BugCombatStat.SPEED: 1,
	}
