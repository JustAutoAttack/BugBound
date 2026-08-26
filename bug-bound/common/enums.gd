class_name Enums
extends RefCounted

# ===
# Core
# ===

# --- Misc ---

enum RarityType {
	COMMON,
	UNCOMMON,
	RARE,
	EPIC,
	MYTHICAL
}

# --- Audio ---

enum AudioBusType {
	MASTER,
	MUSIC,
	SFX
}

enum SFXType {
	UI_DENIED,
	UI_MENU_OPENED,
	UI_MENU_CLOSED,
	UI_NOTIFICATION,
	UI_SELECT_ONE,
	UI_SELECT_TWO,
}

# --- UI ---

enum MenuType {
	MAIN,
	PAUSE,
	SETTINGS,
	CREDITS,
	GAME_OVER
}

enum MainMenuAction {
	HOST,
	JOIN,
	SETTINGS,
	QUIT
}

enum SettingsMenuAction {
	SAVE
}

enum PauseMenuAction { 
	RESUME, 
	SETTINGS,
	SAVE,
	EXIT, 
	QUIT
}

# --- World ---

# ===
# Features
# ===

# --- Zone ---

enum ZoneID {
	FUNGAL_FOREST,
	WEEVIL_WOOD
}

enum ZoneType {
	WILDERNESS,
	TOWN
}

# --- Bug ---

enum BugID {
	PABLO
}

enum BugType {
	VENOMOUS,
	POISONOUS,
	SEISMIC,
	ROTTEN,
	HIVE,
	CAMOUFLAGE,
}

enum BugMovementType {
	GROUND,
	AIR,
	BOTH
}

enum BugCombatStat {
	HEALTH,
	ATTACK,
	DEFENSE,
	SPEED,
}
