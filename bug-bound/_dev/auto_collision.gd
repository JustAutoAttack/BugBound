@tool
extends EditorScenePostImport

func _post_import(scene: Node) -> Node:
	_generate_collisions_recursive(scene)
	return scene

func _generate_collisions_recursive(node: Node) -> void:
	if node is MeshInstance3D and node.mesh:
		# Create the physical static body
		var static_body = StaticBody3D.new()
		static_body.name = "StaticBody3D"
		
		# Create the collision shape node
		var collision_shape = CollisionShape3D.new()
		collision_shape.name = "CollisionShape3D"
		
		# Generate the actual trimesh data from the mesh geometry
		collision_shape.shape = node.mesh.create_trimesh_shape()
		
		# Assemble the tree structure properly
		node.add_child(static_body)
		static_body.owner = node.owner
		
		static_body.add_child(collision_shape)
		collision_shape.owner = node.owner

	for child in node.get_children():
		_generate_collisions_recursive(child)
