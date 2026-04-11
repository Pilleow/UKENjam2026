extends Node2D


func _ready() -> void:
	$Sprite2D.material.set_shader_parameter("outline_enabled", false)
	Prst.connect("moneyUpdated", updateGlow)
	updateGlow()

func updateGlow():
	$Sprite2D.material.set_shader_parameter("outline_enabled", 
		Prst.money > 0
	)
