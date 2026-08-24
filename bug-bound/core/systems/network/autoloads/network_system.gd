extends Node

signal player_connected(peer_id: int)
signal player_disconnected(peer_id: int)
signal connection_failed
signal server_disconnected

const PORT: int = 7777
const MAX_CLIENTS: int = 4

var peer: ENetMultiplayerPeer = null

# ===
# Built-In
# ===

func _ready() -> void:
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.connection_failed.connect(_on_connection_failed)
	multiplayer.server_disconnected.connect(_on_server_disconnected)

# ===
# Public
# ===

func host_game() -> Error:
	peer = ENetMultiplayerPeer.new()
	var error: Error = peer.create_server(PORT, MAX_CLIENTS)
	if error != OK:
		LogSystem.log_message("Failed to host server: %s" % error, LogEnums.LogLevel.ERROR)
		return error
		
	multiplayer.multiplayer_peer = peer
	LogSystem.log_message("Hosting server on port %d..." % PORT, LogEnums.LogLevel.INFO)
	return OK

func join_game(ip: String) -> Error:
	peer = ENetMultiplayerPeer.new()
	var error: Error = peer.create_client(ip, PORT)
	if error != OK:
		LogSystem.log_message("Failed to create client: %s" % error, LogEnums.LogLevel.ERROR)
		return error
		
	multiplayer.multiplayer_peer = peer
	LogSystem.log_message("Connecting to server at %s:%d..." % [ip, PORT], LogEnums.LogLevel.INFO)
	return OK

func close_connection() -> void:
	if multiplayer.multiplayer_peer:
		multiplayer.multiplayer_peer.close()
		multiplayer.multiplayer_peer = null
		LogSystem.log_message("Closed active multiplayer connection.", LogEnums.LogLevel.INFO)

# ===
# Private / Signal Callbacks
# ===

func _on_peer_connected(id: int) -> void:
	LogSystem.log_message("Player connected: %d" % id, LogEnums.LogLevel.INFO)
	player_connected.emit(id)

func _on_peer_disconnected(id: int) -> void:
	LogSystem.log_message("Player disconnected: %d" % id, LogEnums.LogLevel.INFO)
	player_disconnected.emit(id)

func _on_connected_to_server() -> void:
	LogSystem.log_message("Successfully connected to the server!", LogEnums.LogLevel.INFO)

func _on_connection_failed() -> void:
	LogSystem.log_message("Connection failed.", LogEnums.LogLevel.ERROR)
	multiplayer.multiplayer_peer = null
	connection_failed.emit()

func _on_server_disconnected() -> void:
	LogSystem.log_message("Server disconnected.", LogEnums.LogLevel.WARN)
	multiplayer.multiplayer_peer = null
	server_disconnected.emit()
