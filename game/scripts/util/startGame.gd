extends Node2D

@export_file_path() var nextscene = "res://scenes/levels/levelBase.tscn"

func _input(event: InputEvent) -> void:
	if not event.is_action_pressed("interact"):
		return
	Prst.restart()
	Prst.started = true
	$CanvasLayer/FadeIn.start()
	await $CanvasLayer/FadeIn.timeout
	if get_tree():
		get_tree().change_scene_to_file(nextscene)
