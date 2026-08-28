@tool
class_name BugUnknown
extends Bug

@export var rarity_colors: Dictionary[Enums.RarityType, Color] = {
	Enums.RarityType.COMMON: Color(0.918, 0.604, 0.0, 1.0),
	Enums.RarityType.UNCOMMON: Color(0.0, 0.741, 0.206, 1.0),
	Enums.RarityType.RARE: Color(0.1, 0.4, 1.0, 1.0),
	Enums.RarityType.EPIC: Color(0.669, 0.37, 1.0, 1.0),
	Enums.RarityType.MYTHICAL: Color(0.973, 0.0, 0.0, 1.0)
}

@export var bug_definition: BugDefinitionData:
	set(value):
		bug_definition = value

@export var current_rarity: Enums.RarityType:
	set(value):
		current_rarity = value
		if is_node_ready():
			_apply_rarity_visuals(current_rarity)

@onready var firefly_particles: GPUParticles3D = %FireflyParticles
@onready var bubble_mesh: MeshInstance3D = %BubbleMesh
@onready var interaction_label: Label3D = $InteractionLabel
@onready var player_interaction_area: PlayerDetectionArea = $PlayerInteractionArea

# ===
# Built-In
# ===

func _ready() -> void:
	super()
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
	
	_apply_rarity_visuals(current_rarity)

# ===
# Public
# ===

func setup(
	bug_definition_data: BugDefinitionData, 
	rarity: Enums.RarityType
) -> void:
	bug_definition = bug_definition_data
	current_rarity = rarity

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
	
	_apply_firefly_rarity_visuals(color)
	_apply_bubble_rarity_visuals(color)

func _apply_firefly_rarity_visuals(color: Color) -> void:
	if not firefly_particles:
		LogSystem.log_message(
			"FireflyParticles node is missing or not assigned on BugUnknown.",
			LogEnums.LogLevel.ERROR
		)
		return
		
	if not firefly_particles.process_material is ParticleProcessMaterial:
		LogSystem.log_message(
			"FireflyParticles process_material is missing or not a ParticleProcessMaterial.",
			LogEnums.LogLevel.ERROR
		)
		return

	var process_material: ParticleProcessMaterial = firefly_particles.process_material.duplicate() as ParticleProcessMaterial
	process_material.color = color
	firefly_particles.process_material = process_material

	if not firefly_particles.draw_pass_1:
		LogSystem.log_message(
			"draw_pass_1 is missing on FireflyParticles.",
			LogEnums.LogLevel.ERROR
		)
		return

	var mesh_resource: Mesh = firefly_particles.draw_pass_1.duplicate(true) as Mesh
	firefly_particles.draw_pass_1 = mesh_resource
	
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

func _apply_bubble_rarity_visuals(color: Color) -> void:
	if not bubble_mesh:
		LogSystem.log_message(
			"BubbleMesh node is missing or not assigned on BugUnknown.",
			LogEnums.LogLevel.ERROR
		)
		return

	var bubble_material: Material = bubble_mesh.get_surface_override_material(0)
	if not bubble_material:
		bubble_material = bubble_mesh.mesh.surface_get_material(0)

	if not bubble_material is ShaderMaterial:
		LogSystem.log_message(
			"Material on BubbleMesh is missing or not a ShaderMaterial.",
			LogEnums.LogLevel.ERROR
		)
		return

	var unique_bubble_material: ShaderMaterial = bubble_material.duplicate() as ShaderMaterial
	unique_bubble_material.set_shader_parameter("bubble_color", color)
	bubble_mesh.set_surface_override_material(0, unique_bubble_material)
