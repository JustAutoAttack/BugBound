## Base class for all event packets
class_name Event 
extends RefCounted

var string_name: String

func _init(
	p_string_name: String
) -> void:
	string_name = p_string_name
