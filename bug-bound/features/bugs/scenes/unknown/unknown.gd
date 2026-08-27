class_name BugUnknown
extends Bug

@export var rarity_colors: Dictionary[Enums.RarityType, Color] = {
	Enums.RarityType.COMMON: Color(0.918, 0.604, 0.0, 1.0),
	Enums.RarityType.UNCOMMON: Color(0.0, 0.741, 0.206, 1.0),
	Enums.RarityType.RARE: Color(0.1, 0.4, 1.0, 1.0),
	Enums.RarityType.EPIC: Color(0.669, 0.37, 1.0, 1.0),
	Enums.RarityType.MYTHICAL: Color(0.973, 0.0, 0.0, 1.0)
}

@onready var particles: GPUParticles3D = $Model/GPUParticles3D
@onready var interaction_label: Label3D = $InteractionLabel
@onready var player_interaction_area: PlayerDetectionArea = $PlayerInteractionArea

var bug_definition: BugDefinitionData
var current_rarity: Enums.RarityType

# ===
# Built-In
# ===

func _ready() -> void:
	super._ready()
	interaction_label.hide()
	
	player_interaction_area.player_entered_range.connect(
		func(player: Player):
			# Only show the label if this player is OUR local client's player
			if player.is_multiplayer_authority():
				interaction_label.show()  
	)
	
	player_interaction_area.player_exited_range.connect(
		func(player: Player):
			# Only hide the label if it was our local player leaving range
			if player.is_multiplayer_authority():
				interaction_label.hide()  
	)

# ===
# Public
# ===

func setup(
	bug_definition_data: BugDefinitionData, 
	rarity: Enums.RarityType
) -> void:
	bug_definition = bug_definition_data
	current_rarity = rarity
	
	_apply_rarity_visuals(current_rarity)

# ===
# Private
# ===

func _apply_rarity_visuals(rarity: Enums.RarityType) -> void:
	var color: Color = rarity_colors.get(rarity)
	if not color:
		LogSystem.log_message(
			"Color not found for rarity: {0}".format([rarity]),
			LogEnums.LogLevel.ERROR
		)
		return
	
	if not particles:
		LogSystem.log_message(
			"GPUParticles3D node is missing or not assigned on BugUnknown.",
			LogEnums.LogLevel.ERROR
		)
		return
		
	if not particles.process_material is ParticleProcessMaterial:
		LogSystem.log_message(
			"GPUParticles3D process_material is missing or not a ParticleProcessMaterial.",
			LogEnums.LogLevel.ERROR
		)
		return

	var process_material: ParticleProcessMaterial = particles.process_material.duplicate() as ParticleProcessMaterial
	process_material.color = color
	particles.process_material = process_material

	if not particles.draw_pass_1:
		LogSystem.log_message(
			"draw_pass_1 is missing on GPUParticles3D.",
			LogEnums.LogLevel.ERROR
		)
		return

	var mesh_resource: Mesh = particles.draw_pass_1.duplicate(true) as Mesh
	particles.draw_pass_1 = mesh_resource
	
	var surface_material: Material = mesh_resource.material
	if not surface_material and mesh_resource.get_surface_count() > 0:
		surface_material = mesh_resource.surface_get_material(0)
		
	if not surface_material is StandardMaterial3D:
		LogSystem.log_message(
			"Material on draw_pass_1 mesh is missing or not a StandardMaterial3D.",
			LogEnums.LogLevel.ERROR
		)
		return

	var unique_material: StandardMaterial3D = surface_material.duplicate() as StandardMaterial3D
	unique_material.albedo_color = color
	unique_material.emission_enabled = true
	unique_material.emission = color
	unique_material.emission_energy_multiplier = 5.0
	
	mesh_resource.material = unique_material
