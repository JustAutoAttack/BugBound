class_name Constants
extends RefCounted

const MOUSE_INPUT_COEFFICIENT: float = 0.005

class PhysicsLayer:
	
	# Index
	const WORLD_INDEX: int = 1
	const PROP_INDEX: int = 2
	const PLAYER_INDEX: int = 3
	const BUG_INDEX: int = 4

	# Mask
	const WORLD_MASK: int = 1 << 0
	const PROP_MASK: int = 1 << 1
	const PLAYER_MASK: int = 1 << 2
	const BUG_MASK: int = 1 << 3

class RenderLayer:
	
	# Index
	const WORLD_INDEX: int = 1
	const MINIMAP_INDEX: int = 2
	
	# Mask
	const WORLD_MASK: int = 1 << 0
	const MINIMAP_MASK: int = 1 << 1
