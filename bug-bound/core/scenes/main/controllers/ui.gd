class_name MainUIController
extends Node

@onready var hud: UIHUD = %HUD
@onready var menus_layer: CanvasLayer = %MenusLayer
@onready var loading_screen: UILoadingScreen = %LoadingScreen

var menu_type_to_node: Dictionary[Enums.MenuType, UIMenu] = {}

# ===
# Built-In
# ===

func _ready() -> void:
	for child in menus_layer.get_children():
		if child is UIMenu:
			menu_type_to_node[child.type] = child
	
	_hide_all()
	_subscribe_events()

func _exit_tree() -> void:
	_unsubscribe_events()

# ===
# Private
# ===

func _subscribe_events() -> void:
	EventSystem.subscribe_to_command(Commands.HideAllUI, func(_event): _hide_all())
	EventSystem.subscribe_to_command(Commands.ToggleHUD, _handle_toggle_hud)
	EventSystem.subscribe_to_command(Commands.ToggleMenu, _handle_toggle_menu)
	EventSystem.subscribe_to_command(Commands.HideAllMenus, _handle_hide_all_menus)
	EventSystem.subscribe_to_notification(Notifications.LoadingStarted, _handle_loading_started)
	EventSystem.subscribe_to_notification(Notifications.LoadingStopped, _handle_loading_stopped)

func _unsubscribe_events() -> void:
	EventSystem.unsubscribe_all_for_owner(self)

func _toggle_hud(is_visible: bool) -> void:
	hud.visible = is_visible
 
func _toggle_menu(menu_type: Enums.MenuType, should_show: bool) -> void:
	if menu_type_to_node.has(menu_type):
		menu_type_to_node[menu_type].visible = should_show
		ContextSystem.ui_provider.set_open_menus(_get_open_menus())
		
		if (
			should_show and 
			menu_type not in [Enums.MenuType.MAIN]
		):
			EventSystem.dispatch_command(
				Commands.PlaySFX.new(
					Enums.SFXType.UI_MENU_OPENED
				)
			)


func _hide_all_menus() -> void:
	for menu: UIMenu in menu_type_to_node.values():
		menu.visible = false
	
	ContextSystem.ui_provider.set_open_menus(_get_open_menus())

func _start_loading() -> void:
	loading_screen.show()

func _stop_loading() -> void:
	loading_screen.hide()

func _hide_all() -> void:
	_hide_all_menus()
	_toggle_hud(false)
	_stop_loading()

func _get_open_menus() -> Array[Enums.MenuType]:
	var open_menus: Array[Enums.MenuType] = []
	for type: Enums.MenuType in menu_type_to_node:
		var menu: UIMenu = menu_type_to_node[type]
		if (
			menu and 
			menu.visible
		):
			open_menus.append(type)
	
	return open_menus

# ===
# Events
# ===

func _handle_toggle_hud(event: Commands.ToggleHUD) -> void:
	_toggle_hud(
		event.is_visible
	)

func _handle_toggle_menu(event: Commands.ToggleMenu) -> void:
	_toggle_menu(
		event.type, 
		event.is_visible
	)
	
	var is_any_menu_blocking_hud = (
		menu_type_to_node.get(Enums.MenuType.PAUSE, UIMenu.new()).visible or
		menu_type_to_node.get(Enums.MenuType.SETTINGS, UIMenu.new()).visible or
		menu_type_to_node.get(Enums.MenuType.MAIN, UIMenu.new()).visible
	)
	
	var should_show_hud: bool = (
		ContextSystem.is_in_world and 
		not is_any_menu_blocking_hud
	)
	
	_toggle_hud(should_show_hud)

func _handle_hide_all_menus(_event: Commands.HideAllMenus) -> void:
	_hide_all_menus()

func _handle_loading_started(_event: Notifications.LoadingStarted) -> void:
	_start_loading()

func _handle_loading_stopped(_event: Notifications.LoadingStopped) -> void:
	_stop_loading()
