extends Node2D

@onready var inator = get_parent()
# this should be conected directly to inator object

var availableItems = [
	Util.INVENTIONS.HOVERBOARD,
	Util.INVENTIONS.ROOMBA,
	Util.INVENTIONS.FLYING_CAR,
	Util.INVENTIONS.SEGWAY,
]

func _ready() -> void:
	hideMenu()

func toggleMenu():
	if visible:
		hideMenu()
	else:
		showMenu()

func showMenu():
	show()

func hideMenu():
	hide()

func _input(event: InputEvent) -> void:
	if not visible:
		return
	var choice = [
		event.is_action_pressed("buy_0"),
		event.is_action_pressed("buy_1"),
		event.is_action_pressed("buy_2"),
		event.is_action_pressed("buy_3")
	]
	if true not in choice:
		return
	var cidx = 0
	for c in choice:
		if c:
			break
		cidx += 1
	invent_item(availableItems[cidx])
	
func invent_item(item):
	if not Prst.remove_scrap(Prst.inventPrice[item]):
		print("nie masz scrap")
		return
	var count = Prst.invent(item)
	var nd = get_tree().current_scene.find_child(Util.thingToName[item])
	nd.find_child("count").text = "x " + str(count)
