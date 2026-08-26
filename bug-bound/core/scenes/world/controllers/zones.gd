class_name WorldZonesController
extends Node

@export var zone_map: Dictionary[Enums.ZoneID, WorldZone] = {
	Enums.ZoneID.WEEVIL_WOOD: null,
	Enums.ZoneID.FUNGAL_FOREST: null
}
