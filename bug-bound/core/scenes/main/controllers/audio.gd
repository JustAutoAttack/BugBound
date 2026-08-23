class_name MainAudioController
extends Node

const SFX_THROTTLE_DELAY: float = 0.2

@export var title_playlist: Array[SongData] = []
@export var world_playlist: Array[SongData] = []
@export var game_over_song: SongData
@export var priority_sfx: Array[Enums.SFXType] = []

@onready var background_music: AudioStreamPlayer = %BackgroundMusic
@onready var sfx_priority: AudioStreamPlayer = %SFXPriority
@onready var general_sfx: Node = %GeneralSFX

var current_playlist: Array[SongData] = []
var current_playlist_index: int = 0
var _song_pool: Array[SongData] = []
var last_song: SongData
var current_song: SongData
var shuffle_enabled: bool = false
var loop_enabled: bool = false
var _playback_timer: Timer
var _user_paused: bool = false
var _is_game_paused: bool = false
var _music_volume_target: float = 1.0 

# ===
# Built-In
# ===

func _ready() -> void:
	# Setup music
	background_music.finished.connect(_play_next_song)
	
	_playback_timer = Timer.new()
	_playback_timer.wait_time = 1.0
	_playback_timer.timeout.connect(_emit_playback_update)
	add_child(_playback_timer)
	
	_setup_context()
	_subscribe_events()

func _exit_tree() -> void:
	_unsubscribe_events()

# ===
# Private
# ===

func _subscribe_events() -> void:
	EventSystem.subscribe_to_notification(Notifications.Paused, _handle_game_paused)
	EventSystem.subscribe_to_notification(Notifications.Resumed, _handle_game_resumed)
	EventSystem.subscribe_to_command(Commands.StartTitleMusic, _handle_start_title_music)
	EventSystem.subscribe_to_command(Commands.StartWorldMusic, _handle_start_world_music)
	EventSystem.subscribe_to_command(Commands.PlayGameOverMusic, _handle_play_game_over_music)
	EventSystem.subscribe_to_command(Commands.ReplayLastMusic, _handle_replay_last_music)
	EventSystem.subscribe_to_command(Commands.ReplayCurrentMusic, _handle_replay_current_music)
	EventSystem.subscribe_to_command(Commands.SkipCurrentMusic, _handle_skip_current_music)
	EventSystem.subscribe_to_command(Commands.ToggleMusicPaused, _handle_toggle_paused)
	EventSystem.subscribe_to_command(Commands.ToggleMusicLoop, _handle_toggle_loop)
	EventSystem.subscribe_to_command(Commands.ToggleMusicShuffle, _handle_toggle_shuffle)
	EventSystem.subscribe_to_command(Commands.PlaySFX, _handle_play_sfx)
	EventSystem.subscribe_to_command(Commands.KillAllSFX, _handle_kill_all_sfx)

func _unsubscribe_events() -> void:
	EventSystem.unsubscribe_all_for_owner(self)

func _setup_context() -> void:
	var s_ctx: SettingsContextData = ContextSystem.settings_context
	
	_music_volume_target = s_ctx.music_volume
	
	# Volumes
	_update_master_volume(s_ctx.master_volume)
	s_ctx.master_volume_updated.connect(_update_master_volume)
	_update_music_volume(s_ctx.music_volume)
	s_ctx.music_volume_updated.connect(_update_music_volume)
	s_ctx.music_volume_updated.connect(func(v): _music_volume_target = v)
	_update_sfx_volume(s_ctx.sfx_volume)
	s_ctx.sfx_volume_updated.connect(_update_sfx_volume)
	
	# Muted
	_update_muted_buses(s_ctx.muted_buses)
	s_ctx.muted_buses_updated.connect(_update_muted_buses)

func _update_master_volume(value: float) -> void:
	_set_bus_volume(
		"Master", 
		value
	)
	
func _update_music_volume(value: float) -> void:
	_set_bus_volume(
		"Music", 
		value
	)

func _update_sfx_volume(value: float) -> void:
	_set_bus_volume(
		"SFX", 
		value
	)

func _update_muted_buses(flags: int) -> void:
	AudioServer.set_bus_mute(
		AudioServer.get_bus_index("Master"), 
		bool(flags & 1)
	)
	AudioServer.set_bus_mute(
		AudioServer.get_bus_index("Music"), 
		bool(flags & 2)
	)
	AudioServer.set_bus_mute(
		AudioServer.get_bus_index("SFX"), 
		bool(flags & 4)
	)

func _set_bus_volume(bus_name: String, linear_value: float) -> void:
	var bus_idx = AudioServer.get_bus_index(bus_name)
	if bus_idx == -1: return
	
	# Clamp to prevent going into extreme silence or distortion
	# linear_to_db maps 0.0 to -80db and 1.0 to 0db
	var db_value: float = linear_to_db(clamp(
		linear_value, 
		0.0001, 
		1.0
	))
	AudioServer.set_bus_volume_db(
		bus_idx, 
		db_value
	)

func _set_bus_volume_tweened(bus_name: String, linear_value: float) -> void:
	var bus_idx = AudioServer.get_bus_index(bus_name)
	var db_value: float = linear_to_db(clamp(linear_value, 0.0001, 1.0))
	
	var tween = create_tween()
	tween.tween_method(
		func(val): AudioServer.set_bus_volume_db(bus_idx, val),
		AudioServer.get_bus_volume_db(bus_idx),
		db_value,
		0.3
	)

func _reset_playlist_state(exclude_song: SongData = null) -> void:
	_song_pool = current_playlist.duplicate()
	
	if exclude_song and _song_pool.has(exclude_song):
		_song_pool.erase(exclude_song)
		
	_song_pool.shuffle()
	current_playlist_index = 0

func _play_song(song: SongData) -> void:
	if not song: return
	
	last_song = current_song
	current_song = song
	
	background_music.stream = current_song.audio_stream
	background_music.play()

	_playback_timer.start()
	
	EventSystem.broadcast(
		Notifications.CurrentMusicUpdated.new(
			current_song
		)
	)

	_emit_playback_update()

func _play_next_song() -> void:
	if current_playlist.is_empty(): return
	
	# Handle Loop (Current Song)
	if loop_enabled and current_song:
		_play_song(current_song)
		return

	# Prepare Next Song
	var next_song: SongData
	
	if shuffle_enabled:
		if _song_pool.is_empty():
			_reset_playlist_state(current_song)
		
		next_song = _song_pool.pop_back()
	
	else:
		current_playlist_index = (current_playlist_index + 1) % current_playlist.size()
		next_song = current_playlist[current_playlist_index]

	_play_song(next_song)

func _play_dynamic_sfx(stream: AudioStream, pitch: float = 1.0) -> void:
	var player: AudioStreamPlayer = AudioStreamPlayer.new()
	player.process_mode = Node.PROCESS_MODE_PAUSABLE
	player.bus = "SFX"
	player.stream = stream
	player.pitch_scale = pitch
	player.finished.connect(player.queue_free)
	
	general_sfx.add_child(player) 
	player.play()

func _emit_playback_update() -> void:
	if not background_music.playing:
		_playback_timer.stop()
		return
		
	var current_time: int = int(background_music.get_playback_position())
	
	EventSystem.broadcast(
		Notifications.CurrentPlaybackTimeUpdated.new(
			current_time
		)
	)

func _toggle_music_paused(is_paused: bool) -> void:
	if is_paused:
		_playback_timer.stop()
	else:
		# Only restart timer if a song is currently playing/loaded
		if background_music.stream:
			_playback_timer.start()
	
func _toggle_music_ducking(is_paused: bool) -> void:
	_is_game_paused = is_paused
	
	# Manage Timer
	if is_paused:
		_playback_timer.stop()
	elif background_music.stream:
		_playback_timer.start()
		
	# Manage Volume
	var target_linear: float = (_music_volume_target * 0.5) if is_paused else _music_volume_target
	_set_bus_volume_tweened("Music", target_linear)

# ===
# Events
# ===

func _handle_game_paused(_event: Notifications.Paused) -> void:
	_toggle_music_ducking(true)

func _handle_game_resumed(_event: Notifications.Resumed) -> void:
	if not _user_paused:
		_toggle_music_ducking(false)

func _handle_start_title_music(_event: Commands.StartTitleMusic) -> void:
	current_playlist = title_playlist
	_reset_playlist_state()
	
	if current_playlist.size() > 0:
		_play_song(current_playlist[0])

func _handle_start_world_music(_event: Commands.StartWorldMusic) -> void:
	current_playlist = world_playlist
	_reset_playlist_state()
	
	if current_playlist.size() > 0:
		_play_song(current_playlist[0])

func _handle_play_game_over_music(_event: Commands.PlayGameOverMusic) -> void:
	if not game_over_song:
		push_warning("Audio: Game Over song not assigned in Inspector.")
		return
	
	current_playlist = []
	_playback_timer.stop()
	
	current_song = game_over_song
	background_music.stream = current_song.audio_stream
	background_music.play()
	
	EventSystem.broadcast(
		Notifications.CurrentMusicUpdated.new(
			current_song
		)
	)


func _handle_replay_last_music(_event: Commands.ReplayLastMusic) -> void:
	if last_song:
		_play_song(last_song)

func _handle_replay_current_music(_event: Commands.ReplayCurrentMusic) -> void:
	if current_song:
		_play_song(current_song)

func _handle_skip_current_music(_event: Commands.SkipCurrentMusic) -> void:
	_play_next_song()

func _handle_toggle_paused(event: Commands.ToggleMusicPaused) -> void:
	_user_paused = event.is_paused
	background_music.stream_paused = event.is_paused
	
	_toggle_music_ducking(event.is_paused)
	
	EventSystem.broadcast(
		Notifications.MusicPauseUpdated.new(
			event.is_paused
		)
	)


func _handle_toggle_loop(event: Commands.ToggleMusicLoop) -> void:
	loop_enabled = event.enabled

func _handle_toggle_shuffle(event: Commands.ToggleMusicShuffle) -> void:
	shuffle_enabled = event.enabled

func _handle_play_sfx(event: Commands.PlaySFX) -> void:
	var stream_path: String = AssetConstants.AudioPaths.SFX_PATHS.get(event.sfx_type)
	var audio_stream: AudioStreamMP3 = load(stream_path)
	
	if not audio_stream:
		push_error("Audio: Could not find audio stream for SFX: {0}".format([Enums.SFXType.keys()[event.sfx_type]]))
		return
	
	# Priority handling
	if event.sfx_type in priority_sfx:
		sfx_priority.stream = audio_stream
		sfx_priority.play()
	
	# General SFX
	else:
		var pitch: float = 1.0
		_play_dynamic_sfx(audio_stream, pitch)

func _handle_kill_all_sfx(_event: Commands.KillAllSFX) -> void:
	for child: Node in general_sfx.get_children():
		if child is AudioStreamPlayer:
			child.queue_free()
			
	sfx_priority.stop()
