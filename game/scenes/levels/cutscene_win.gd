extends Node2D


func _ready() -> void:
	$CanvasLayer/AnimationPlayer.play("intro")
	Music.stop_all_music()
	Music.play_music("win", "res://assets/music/goodend.wav", 0, 1, -20)

var t = 0

func _process(delta: float) -> void:
	t += delta
	var td = (t + 5)/30
	if td <= 1.5:
		td = min(1, td)
		print(td)
		$CanvasLayer/CRT.material.set_shader_parameter("warp_amount",
			0.3 * (1 - 0.8*Util.ease_in_out_quint(td))
		)
		$CanvasLayer/CRT.material.set_shader_parameter("vignette_intensity",
			0.3 * (1 - Util.ease_in_out_quint(td))
		)
		$CanvasLayer/CRT.material.set_shader_parameter("vignette_opacity",
			Util.ease_in_out_quint(td) * (1-0.969) + 0.969
		)

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
