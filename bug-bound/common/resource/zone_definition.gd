class_name ZoneDefinitionData
extends Resource

@export var id: Enums.ZoneID
@export var display_name: String 
@export var type: Enums.ZoneType
@export var bug_rarity_weights_map: Dictionary[Enums.BugID, RarityWeight] = {}
