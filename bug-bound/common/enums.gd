class_name Enums
extends RefCounted

# ===
# Core
# ===

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
	PLAY, 
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

# ===
# Features
# ===
