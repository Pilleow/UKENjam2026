extends Area2D

@onready var player = get_tree().get_first_node_in_group("player")
var send = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		send = true
		send_money()
	elif event.is_action_released("interact"):
		send = false

func send_money(hold=0.12):
	if not send or player not in get_overlapping_bodies():
		return
	Prst.investMoney(1, hold)
	var gt = get_tree()
	if not gt:
		return
	var t = gt.create_timer(hold) as SceneTreeTimer
	t.connect("timeout", func(): send_money(hold*0.91))
