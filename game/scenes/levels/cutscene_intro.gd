extends Node2D


func _ready() -> void:
	$CanvasLayer/AnimationPlayer.play("intro")
	if not Music.is_playing("main"):
		Music.play_music("main", "res://assets/music/bgm.wav", 0, 3, -20)
		Music.turnLPFon()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("w"):
		Sound.play_random_variation("ui", 10)
		$CanvasLayer/AnimationPlayer.seek($CanvasLayer/AnimationPlayer.current_animation_position + 2)
	elif event.is_action_pressed("interact") and not $CanvasLayer/FadeIn.started:
		
		Sound.play_random_variation("ui", 10)
		$CanvasLayer/FadeIn.start()
		await $CanvasLayer/FadeIn.timeout
		if get_tree():
			get_tree().change_scene_to_file("res://scenes/levels/tutorial.tscn")
