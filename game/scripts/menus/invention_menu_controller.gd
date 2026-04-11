extends CanvasLayer

@onready var inator = get_parent()
# this should be conected directly to inator object

var availableItems = [
	Util.INVENTIONS.HOVERBOARD,
	Util.INVENTIONS.ROOMBA,
	Util.INVENTIONS.FLYING_CAR,
	Util.INVENTIONS.SEGWAY,
]

var should_hide = true
var state_change_time = 0

func _ready() -> void:
	hide()
	hideMenu()

func _process(delta):
	if should_hide and offset.y < 700:
		var t : float = Time.get_ticks_msec()/1000.0 - state_change_time
		offset.y = Util.ease_out_elastic(t) * 700
		if offset.y >= 700: 
			hide()
	elif not should_hide:
		var t : float = Time.get_ticks_msec()/1000.0 - state_change_time
		offset.y = (1 - Util.ease_out_elastic(t)) * 700 + 22

func showMenu():
	show()
	state_change_time = Time.get_ticks_msec() / 1000.0
	should_hide = false

func hideMenu():
	state_change_time = Time.get_ticks_msec() / 1000.0
	should_hide = true
	
func toggleMenu():
	if visible:
		hideMenu()
	else:
		showMenu()

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
	nd.find_child("count").text = "x" + str(count)
	var val = Prst.calcThingValue(item)
	Prst.add_money(val)

func canBuyAnything():
	for item in availableItems:
		if can_afford(Util.thingToName[item]):
			return true
	return false

func can_afford(itemName):
	var item = Util.nameToInvent[itemName]
	for type in range(3):
		if Prst.scrap_amount[type] < Prst.inventPrice[item][type]:
			return false
	return true
