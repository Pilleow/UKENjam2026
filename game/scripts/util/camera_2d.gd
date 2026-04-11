extends Camera2D

@onready var player = get_tree().get_first_node_in_group("player")

func _ready() -> void:
	pass


#func _process(delta: float) -> void:
	#var m = 1000
	#var d = 1
	#drag_horizontal_offset = (min(m, max(-m, (player.position.x - 608)/d))) / 1000
