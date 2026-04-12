extends Node

var sounds: Dictionary = {}
var sound_players: Array[AudioStreamPlayer] = []

var sfx_bus: String = "SFX"
var sounds_folder: String = "res://assets/sounds/"
var player_pool_size: int = 16
var default_volume_db: float = 0.0

func _ready() -> void:
	_create_player_pool()
	load_sounds_from_folder(sounds_folder)


func _create_player_pool() -> void:
	for i in range(player_pool_size):
		var player := AudioStreamPlayer.new()
		player.bus = sfx_bus
		player.volume_db = default_volume_db
		add_child(player)
		sound_players.append(player)


func load_sounds_from_folder(folder_path: String) -> void:
	sounds.clear()

	var files := ResourceLoader.list_directory(folder_path)
	if files.is_empty():
		push_warning("Sound.gd: No files found in folder: " + folder_path)

	for file_name in files:
		if not _is_supported_audio_file(file_name):
			continue

		var file_path := folder_path.path_join(file_name)

		if not ResourceLoader.exists(file_path, "AudioStream"):
			push_warning("Sound.gd: Resource does not exist in export: " + file_path)
			continue

		var stream := ResourceLoader.load(file_path, "AudioStream") as AudioStream
		if stream == null:
			push_error("Sound.gd: Failed to load sound: " + file_path)
			continue

		var sound_name := file_name.get_basename()
		sounds[sound_name] = stream

	print("Sound.gd: Loaded sounds: ", sounds.keys())


func _is_supported_audio_file(file_name: String) -> bool:
	var lower := file_name.to_lower()
	return lower.ends_with(".wav") or lower.ends_with(".ogg") or lower.ends_with(".mp3")


func play_sound(sound_name: String, volume_db: float = default_volume_db, pitch_scale: float = 1.0) -> void:
	if not sounds.has(sound_name):
		push_error("Sound.gd: Sound not found: " + sound_name)
		return

	var player := _get_available_player()
	if player == null:
		push_warning("Sound.gd: No available AudioStreamPlayer for sound: " + sound_name)
		return

	player.stream = sounds[sound_name]
	player.volume_db = volume_db + 4
	player.pitch_scale = pitch_scale
	player.play()


func play_random_sound(sound_names: Array[String], volume_db: float = default_volume_db, pitch_scale: float = 1.0) -> void:
	if sound_names.is_empty():
		push_error("Sound.gd: play_random_sound got empty array.")
		return

	var valid_sounds: Array[String] = []

	for sound_name in sound_names:
		if sounds.has(sound_name):
			valid_sounds.append(sound_name)
		else:
			push_warning("Sound.gd: Random pool missing sound: " + sound_name)

	if valid_sounds.is_empty():
		push_error("Sound.gd: No valid sounds in random pool.")
		return

	var index := randi() % valid_sounds.size()
	play_sound(valid_sounds[index], volume_db, pitch_scale)


func play_random_variation(base_name: String, volume_db: float = default_volume_db, pitch_min: float = 0.95, pitch_max: float = 1.05) -> void:
	var matching_sounds: Array[String] = []

	for sound_name in sounds.keys():
		if String(sound_name).begins_with(base_name):
			matching_sounds.append(sound_name)

	if matching_sounds.is_empty():
		push_error("Sound.gd: No sounds found for variation base: " + base_name)
		return

	var random_name := matching_sounds[randi() % matching_sounds.size()]
	var random_pitch := randf_range(pitch_min, pitch_max)
	play_sound(random_name, volume_db, random_pitch)


func has_sound(sound_name: String) -> bool:
	return sounds.has(sound_name)


func get_sound(sound_name: String) -> AudioStream:
	if sounds.has(sound_name):
		return sounds[sound_name]
	return null


func stop_all_sounds() -> void:
	for player in sound_players:
		player.stop()


func set_bus(bus_name: String) -> void:
	sfx_bus = bus_name
	for player in sound_players:
		player.bus = sfx_bus


func _get_available_player() -> AudioStreamPlayer:
	for player in sound_players:
		if not player.playing:
			return player

	# fallback: jeśli wszystkie zajęte, nadpisz pierwszy
	return sound_players[0] if sound_players.size() > 0 else null
