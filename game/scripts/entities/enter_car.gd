extends Area2D

@onready var player = get_tree().get_first_node_in_group("player")

@export_node_path() var fadein
@export_file_path("*.tscn") var next_scene = "res://scenes/levels/transition.tscn"

func _input(event):
	if player in get_overlapping_bodies() and event.is_action_pressed("interact"):
		Prst.previousScene = "levelBase"
		var f = get_node(fadein)
		f.start()
		await f.timeout
		if get_tree():
			get_tree().change_scene_to_file(next_scene)
