extends Node

var player: AudioStreamPlayer
var current_stream: AudioStream = null

var music_bus: String = "Music"
var lpf_effect_index: int = 0
var hpf_effect_index: int = 1

var default_volume_db: float = 0.0
var fade_in_start_db: float = -20.0
var fade_in_duration: float = 2.0

var volume_tween: Tween


func _ready() -> void:
	player = AudioStreamPlayer.new()
	player.volume_db = default_volume_db
	player.bus = music_bus
	add_child(player)

	turnLPFoff()
	turnHPFoff()


func load_music(path: String, loop: bool = true) -> bool:
	var stream := load(path) as AudioStream

	if stream == null:
		push_error("Music.gd: Failed to load audio stream from path: " + path)
		return false

	current_stream = stream
	player.stream = current_stream
	return true


func play_music(path: String = "", loop: bool = true) -> void:
	if path != "":
		var ok := load_music(path, loop)
		if not ok:
			return

	if player.stream == null:
		push_error("Music.gd: No music loaded.")
		return

	if volume_tween != null:
		volume_tween.kill()

	player.stop()
	player.volume_db = fade_in_start_db
	player.play(0.0)

	volume_tween = create_tween()
	volume_tween.tween_property(player, "volume_db", default_volume_db, fade_in_duration)

	print(player.playing)
	print(player.stream)
	print(player.bus)


func stop_music() -> void:
	if volume_tween != null:
		volume_tween.kill()
	player.stop()


func is_playing() -> bool:
	return player.playing


func set_bus(bus_name: String) -> void:
	music_bus = bus_name
	if player != null:
		player.bus = bus_name


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
