extends CanvasLayer

@onready var inator = get_parent()
# this should be conected directly to inator object

var availableItems = [
	Util.INVENTIONS.HOVERBOARD,
	Util.INVENTIONS.ROOMBA,
	Util.INVENTIONS.FLYING_CAR,
	Util.INVENTIONS.SEGWAY,
]

@onready var sprites = [
	$hoverboard/Sprite2D,
	$roomba/Sprite2D,
	$flying_car/Sprite2D,
	$segway/Sprite2D
]

var should_hide = true
var state_change_time = 0

func _ready() -> void:
	hide()
	hideMenu()

func _physics_process(delta: float) -> void:
	for s in sprites:
		var target = 5
		if s.scale.x > target:
			s.scale.x = s.scale.x * 0.95
			s.scale.y = s.scale.y * 0.95
			if s.scale.x < target:
				s.scale.x = target
				s.scale.y = target
				
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
	Music.play_music("screen", "res://assets/music/monitor_buzz.wav", 0, .2, 5, 1, "SFX")
	Music.turnLPFon()
	Sound.play_random_variation("monitor_on", 5)
	updateRewards()
	state_change_time = Time.get_ticks_msec() / 1000.0
	should_hide = false

func updateRewards():
	for item in availableItems:
		var reward = get_node(Util.thingToName[item]).get_node("reward")
		reward.text = "$" + str(int(Prst.calcThingValue(item)))

func hideMenu():
	if visible:
		Music.stop_music("screen")
		Sound.play_random_variation("monitor_off", 5)
		Music.turnLPFoff()
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
	if invent_item(availableItems[cidx]):
		sprites[cidx].scale.x = 8
		sprites[cidx].scale.y = 8
	
func invent_item(item):
	if not Prst.remove_scrap(Prst.inventPrice[item]):
		print("nie masz scrap")
		return false
	var count = Prst.invent(item)
	var nd = get_tree().current_scene.find_child(Util.thingToName[item])
	nd.find_child("count").text = "x" + str(count)
	var val = Prst.calcThingValue(item)
	Prst.add_money(val)
	return true

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
