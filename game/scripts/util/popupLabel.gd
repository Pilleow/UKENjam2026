extends Label

@onready var player = get_tree().get_first_node_in_group("player")
@onready var parArea = get_parent() as Area2D
# this object should be connected directly to Area2D

func _ready() -> void:
	parArea.connect("body_entered", showLabel)
	parArea.connect("body_exited", hideLabel)
	hide()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		hide()


func showLabel(body):
	if player == body:
		show()
		
		
func hideLabel(body):
	if player == body:
		hide()
