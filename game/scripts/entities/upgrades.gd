extends Node2D

@onready var player = get_tree().get_first_node_in_group("player")
@onready var menuController = $upgradesMenu
@onready var interactArea = $showUpgrades as Area2D

func _ready() -> void:
	interactArea.connect("body_exited", playerStopInteraction)
	Prst.connect("moneyUpdated", updateGlow)
	updateGlow()

func updateGlow():
	$Sprite2D.material.set_shader_parameter("outline_enabled", 
		menuController.canBuyAnything()
	)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and player in interactArea.get_overlapping_bodies():
		menuController.toggleMenu()

func playerStopInteraction(body):
	if body != player:
		return
	menuController.hideMenu()
