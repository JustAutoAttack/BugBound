class_name BugUnknown
extends Bug

@export var rarity_colors: Dictionary = {
	"Common": Color(1.0, 1.0, 0.8),
	"Uncommon": Color(0.2, 0.8, 0.4),
	"Rare": Color(0.2, 0.5, 1.0),
	"Epic": Color(0.8, 0.3, 0.9),
	"Legendary": Color(1.0, 0.6, 0.1)
}

@onready var particles: GPUParticles3D = $GPUParticles3D
@onready var glow_light: OmniLight3D = $OmniLight3D

var current_rarity: String = "Common"
var true_bug_scene: PackedScene = null

# ===
# Built-In
# ===

func _ready() -> void:
	current_rarity = _roll_rarity_for_zone()
	_apply_rarity_visuals(current_rarity)
	true_bug_scene = _roll_true_bug_identity()

func _physics_process(delta: float) -> void:
	var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	move_and_slide()

# ===
# Public
# ===

# ===
# Private
# ===

func _roll_rarity_for_zone() -> String:
	var roll = randf()
	if roll > 0.95: return "Legendary"
	if roll > 0.85: return "Epic"
	if roll > 0.60: return "Rare"
	if roll > 0.30: return "Uncommon"
	return "Common"

func _apply_rarity_visuals(rarity: String) -> void:
	var col = rarity_colors.get(rarity, Color.WHITE)
	
	# Apply color to the OmniLight
	if glow_light:
		glow_light.light_color = col
	
	# Apply color to the GPUParticles3D process material
	if particles and particles.process_material is ParticleProcessMaterial:
		# We duplicate the material so instances don't override each other's colors
		var mat = particles.process_material.duplicate() as ParticleProcessMaterial
		mat.color = col
		particles.process_material = mat

func _roll_true_bug_identity() -> PackedScene:
	# TODO: Pull from zone asset provider based on rarity
	return null
