extends ColorRect

@onready var player = get_tree().get_first_node_in_group("player")
@onready var menuController = $inventionMenu
@onready var interactArea = $invent as Area2D

func _ready() -> void:
	interactArea.connect("body_exited", playerStopInteraction)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and player in interactArea.get_overlapping_bodies():
		menuController.toggleMenu()

func playerStopInteraction(body):
	if body != player:
		return
	menuController.hideMenu()
