class_name WorldZonesController
extends Node

@export var zone_map: Dictionary[Enums.ZoneType, WorldZone] = {
	Enums.ZoneType.TOWN: null,
	Enums.ZoneType.FOREST: null
}
