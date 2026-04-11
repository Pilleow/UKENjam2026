extends Node2D


func _ready():
	if not Prst.counting_down:
		$Player.global_position = Vector2(398, -266)
