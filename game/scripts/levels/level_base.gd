extends Node2D


func _ready():
	if not Prst.counting_down:
		$Player.global_position = Vector2(398, -266)
	if not Music.is_playing("ovAm"):
		Music.play_music("ovAm", "res://assets/music/ambient.wav", 0, .5, -1)
	$AudioStreamPlayer2D.play()
