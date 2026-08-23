class_name UIContextProvider
extends ContextProvider

var context: UIContextData

# ===
# Built-In
# ===

func _init(
	p_context: UIContextData
) -> void:
	super._init()
	context = p_context

# ===
# Public
# ===

func toggle_menu(
	menu_type: Enums.MenuType, 
	is_visible: bool
) -> void:
	var menus: Array[Enums.MenuType] = context.open_menus.duplicate()
	if is_visible:
		if not menus.has(menu_type):
			menus.append(menu_type)
	else:
		menus.erase(menu_type)
	
	context.open_menus = menus

func set_open_menus(
	value: Array[Enums.MenuType]
) -> void:
	context.open_menus = value

func is_menu_open(
	menu_type: Enums.MenuType
) -> bool:
	return (menu_type in context.open_menus)

func set_hud_visible(value: bool) -> void:
	context.is_hud_visible = value

func set_loading(value: bool) -> void:
	context.is_loading = value

func set_saving(value: bool) -> void:
	context.is_saving = value
