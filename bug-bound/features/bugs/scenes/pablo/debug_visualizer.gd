class_name BugDebugVisualizer
extends MeshInstance3D

@export var enabled: bool = false

@onready var parent: Bug = get_parent()

var immediate_mesh: ImmediateMesh

func _ready() -> void:
	immediate_mesh = ImmediateMesh.new()
	mesh = immediate_mesh
	
	# Create an unshaded material that respects vertex colors
	var material = ORMMaterial3D.new()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.vertex_color_use_as_albedo = true
	material_override = material

func _process(_delta: float) -> void:
	if not (
		parent or 
		visible or
		enabled
	):
		return
	
	immediate_mesh.clear_surfaces()
	var local_initial_pos: Vector3 = to_local(parent.initial_position)
	
	# Draw Leash Radius around initial position
	_draw_circle(
		local_initial_pos, 
		parent.leash_radius, 
		Color.BLUE, 
		32
	)
	
	# Draw Wander Radius around current position
	_draw_circle(
		Vector3.ZERO, 
		parent.wander_radius, 
		Color.YELLOW, 
		24
	)

# Helper function to draw a wireframe circle in 3D local space using the passed color
func _draw_circle(center: Vector3, radius: float, color: Color, segments: int) -> void:
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINE_STRIP)
	
	for i in range(segments + 1):
		var theta = (float(i) / segments) * TAU
		var x = center.x + cos(theta) * radius
		var z = center.z + sin(theta) * radius
		var y = center.y + 0.1 # Slight offset to avoid z-fighting with the ground
		
		immediate_mesh.surface_set_color(color)
		immediate_mesh.surface_add_vertex(Vector3(x, y, z))
		
	immediate_mesh.surface_end()
