extends Node

var music_bus: String = "Music"
var sfx_bus: String = "SFX"
var lpf_effect_index: int = 0
var hpf_effect_index: int = 1

var default_volume_db: float = -20.0
var fade_in_start_db: float = -40.0
var fade_in_duration: float = 2.0

# Stores players by custom ID
var players: Dictionary = {}
var volume_tweens: Dictionary = {}


func _ready() -> void:
	turnLPFoff()
	turnHPFoff()


func _create_player(track_id: String, bus_name: String = "Music") -> AudioStreamPlayer:
	var new_player := AudioStreamPlayer.new()
	new_player.bus = bus_name
	new_player.volume_db = default_volume_db
	new_player.mix_target = AudioStreamPlayer.MIX_TARGET_STEREO
	add_child(new_player)

	players[track_id] = new_player
	return new_player


func _get_player(track_id: String) -> AudioStreamPlayer:
	if players.has(track_id):
		return players[track_id]
	return null


func load_music(track_id: String, path: String, bus_name: String = "Music") -> bool:
	var stream := load(path) as AudioStream

	if stream == null:
		push_error("Music.gd: Failed to load audio stream from path: " + path)
		return false

	var player := _get_player(track_id)
	if player == null:
		player = _create_player(track_id, bus_name)
	else:
		player.bus = bus_name

	player.stream = stream
	return true


func play_music(
	track_id: String,
	path: String = "",
	from_position: float = 0.0,
	fade_in: float = 3.0,
	volume_db: float = 0.0,
	pitch: float = 1.0,
	bus_name: String = "Music"
) -> void:
	var player := _get_player(track_id)

	if path != "":
		var ok := load_music(track_id, path, bus_name)
		if not ok:
			return
		player = _get_player(track_id)

	if player == null or player.stream == null:
		push_error("Music.gd: No music loaded for track_id: " + track_id)
		return

	# Make sure existing players can also switch bus
	player.bus = bus_name

	if volume_tweens.has(track_id):
		var old_tween: Tween = volume_tweens[track_id]
		if old_tween != null:
			old_tween.kill()
		volume_tweens.erase(track_id)

	player.stop()

	if fade_in > 0.0:
		player.volume_db = fade_in_start_db
	else:
		player.volume_db = volume_db

	player.pitch_scale = pitch
	player.play(from_position)

	if fade_in > 0.0:
		var tween := create_tween()
		tween.tween_property(player, "volume_db", volume_db, fade_in)
		volume_tweens[track_id] = tween


func stop_music(track_id: String) -> void:
	var player := _get_player(track_id)
	if player == null:
		return

	if volume_tweens.has(track_id):
		var tween: Tween = volume_tweens[track_id]
		if tween != null:
			tween.kill()
		volume_tweens.erase(track_id)

	player.stop()


func set_volume(track_id: String, v: float) -> void:
	var player := _get_player(track_id)
	if player == null:
		return

	if volume_tweens.has(track_id):
		var old_tween: Tween = volume_tweens[track_id]
		if old_tween != null:
			old_tween.kill()

	var tween := create_tween()
	tween.tween_property(player, "volume_db", v, 3.0)
	volume_tweens[track_id] = tween


func stop_all_music(except = []) -> void:
	for track_id in players.keys():
		if track_id in except:
			continue
		stop_music(track_id)


func remove_music(track_id: String) -> void:
	var player := _get_player(track_id)
	if player == null:
		return

	stop_music(track_id)
	players.erase(track_id)
	player.queue_free()


func is_playing(track_id: String) -> bool:
	var player := _get_player(track_id)
	if player == null:
		return false
	return player.playing


func turnLPFon() -> void:
	var bus_index := AudioServer.get_bus_index(music_bus)
	if bus_index == -1:
		push_error("Music.gd: Bus not found: " + music_bus)
		return

	if lpf_effect_index < 0 or lpf_effect_index >= AudioServer.get_bus_effect_count(bus_index):
		push_error("Music.gd: Invalid LPF effect index.")
		return

	AudioServer.set_bus_effect_enabled(bus_index, lpf_effect_index, true)


func turnLPFoff() -> void:
	var bus_index := AudioServer.get_bus_index(music_bus)
	if bus_index == -1:
		push_error("Music.gd: Bus not found: " + music_bus)
		return

	if lpf_effect_index < 0 or lpf_effect_index >= AudioServer.get_bus_effect_count(bus_index):
		push_error("Music.gd: Invalid LPF effect index.")
		return

	AudioServer.set_bus_effect_enabled(bus_index, lpf_effect_index, false)


func turnHPFon() -> void:
	var bus_index := AudioServer.get_bus_index(music_bus)
	if bus_index == -1:
		push_error("Music.gd: Bus not found: " + music_bus)
		return

	if hpf_effect_index < 0 or hpf_effect_index >= AudioServer.get_bus_effect_count(bus_index):
		push_error("Music.gd: Invalid HPF effect index.")
		return

	AudioServer.set_bus_effect_enabled(bus_index, hpf_effect_index, true)


func turnHPFoff() -> void:
	var bus_index := AudioServer.get_bus_index(music_bus)
	if bus_index == -1:
		push_error("Music.gd: Bus not found: " + music_bus)
		return

	if hpf_effect_index < 0 or hpf_effect_index >= AudioServer.get_bus_effect_count(bus_index):
		push_error("Music.gd: Invalid HPF effect index.")
		return

	AudioServer.set_bus_effect_enabled(bus_index, hpf_effect_index, false)
