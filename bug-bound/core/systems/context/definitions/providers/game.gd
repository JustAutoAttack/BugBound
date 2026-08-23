class_name GameContextProvider
extends ContextProvider

var context: GameContextData

# ===
# Built-In
# ===

func _init(
	p_context: GameContextData
) -> void:
	super._init()
	context = p_context
	
# ===
# Public
# ===
