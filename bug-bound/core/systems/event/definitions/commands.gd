class_name Commands
extends RefCounted

# ===
# Misc
# ===

# --- Save/Load ---
class StartLoading extends Command:
	func _init() -> void:
		super("StartLoading")
class StopLoading extends Command:
	func _init() -> void:
		super("StopLoading")
class StartSaving extends Command:
	func _init() -> void:
		super("StartSaving")
class StopSaving extends Command:
	func _init() -> void:
		super("StopSaving")
class SaveGame extends Command:
	func _init() -> void:
		super("SaveGame")
class SaveSettings extends Command:
	func _init() -> void:
		super("SaveSettings")

# ===
# Scene
# ===

# --- Main ---
class LoadBootsplash extends Command:
	func _init() -> void:
		super("LoadBootsplash")
class LoadGame extends Command:
	func _init() -> void:
		super("LoadGame")

# --- Game ---
class LoadTitle extends Command:
	func _init() -> void:
		super("LoadTitle")
class LoadWorld extends Command:
	func _init() -> void:
		super("LoadWorld")

# ===
# Audio
# ===

# --- Music ---
class StartTitleMusic extends Command:
	func _init() -> void:
		super("StartTitleMusic")
class StartWorldMusic extends Command:
	func _init() -> void:
		super("StartWorldMusic")
class PlayGameOverMusic extends Command:
	func _init() -> void:
		super("PlayGameOverMusic")
class ReplayLastMusic extends Command:
	func _init() -> void:
		super("ReplayLastMusic")
class ReplayCurrentMusic extends Command:
	func _init() -> void:
		super("ReplayCurrentMusic")
class SkipCurrentMusic extends Command:
	func _init() -> void:
		super("SkipCurrentMusic")
class ToggleMusicPaused extends Command: 
	
	var is_paused: bool
	
	func _init(
		p_is_paused: bool
	) -> void:
		super("ToggleMusicPaused")
		is_paused = p_is_paused
class ToggleMusicLoop extends Command:
	
	var enabled: bool
	
	func _init(
		p_enabled: bool
	) -> void:
		super("ToggleMusicLoop")
		enabled = p_enabled
class ToggleMusicShuffle extends Command:
	
	var enabled: bool
	
	func _init(
		p_enabled: bool
	) -> void:
		super("ToggleMusicShuffle")
		enabled = p_enabled

# --- SFX ---
class PlaySFX extends Command:
	
	var sfx_type: Enums.SFXType
	
	func _init(
		p_sfx_type: Enums.SFXType
	) -> void:
		super("PlaySFX")
		sfx_type = p_sfx_type
class KillAllSFX extends Command:
	func _init() -> void:
		super("KillAllSFX")

# ===
# UI
# ===
class HideAllUI extends Command:
	func _init() -> void:
		super("HideAllUI")
class HideAllMenus extends Command:
	func _init() -> void:
		super("HideAllMenus")
class ToggleMenu extends Command:
	
	var type: Enums.MenuType
	var is_visible: bool
	
	func _init(
		p_type: Enums.MenuType, 
		p_is_visible: bool
	):
		super("ToggleMenu")
		type = p_type
		is_visible = p_is_visible
class ToggleHUD extends Command:
	
	var is_visible: bool
	
	func _init(
		p_is_visible: bool
	):
		super("ToggleHUD")
		is_visible = p_is_visible
