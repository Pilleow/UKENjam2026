extends Node2D

@export_file_path() var nextscene = "res://scenes/levels/levelBase.tscn"

func _ready() -> void:
	if not Music.is_playing():
		Music.turnHPFon()
		Music.play_music("res://assets/music/bgm.wav")
	$CanvasLayer/Label.hide()
	get_tree().create_timer(3).connect("timeout", show_start_btn)

func show_start_btn():
	$CanvasLayer/Label.show()

func _input(event: InputEvent) -> void:
	if not event.is_action_pressed("interact"):
		return
	Prst.restart()
	Prst.started = true
	$CanvasLayer/FadeIn.start()
	await $CanvasLayer/FadeIn.timeout
	Music.turnHPFoff()
	if get_tree():
		get_tree().change_scene_to_file(nextscene)
