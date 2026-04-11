extends CanvasLayer

@onready var station = get_parent()
# this should be conected directly to station object

var availableUpgrades = [
	Util.UPGRADES.GRAVITY_GLOVES,
	Util.UPGRADES.EXOSKELETON,
	Util.UPGRADES.WD40
]

var should_hide = true
var state_change_time = 0

func _ready() -> void:
	Prst.connect("upgradeBought", updateItemInfo)
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
	updateItemInfo()
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

func updateItemInfo():
	for item in availableUpgrades:
		var nd = get_tree().current_scene.find_child(Util.upgradeToName[item])
		nd.get_node("cost").text = "$" + str(Prst.upgradePrice[item] as int)
		var rwd = nd.get_node("reward")
		var parts = rwd.text.split(' ')
		parts[1] = str(int(Prst.tasmaProperties[Util.upgradeToProperty[item]] * 100 - 100.0)) + "%"
		rwd.text = ' '.join(parts)

func _input(event: InputEvent) -> void:
	if not visible:
		return
	var choice = [
		event.is_action_pressed("buy_0"),
		event.is_action_pressed("buy_1"),
		event.is_action_pressed("buy_2")
		#event.is_action_pressed("buy_3")
	]
	if true not in choice:
		return
	var cidx = 0
	for c in choice:
		if c:
			break
		cidx += 1
	buy_upgrade(availableUpgrades[cidx])
	
func buy_upgrade(item):
	if -1 == Prst.remove_money(Prst.upgradePrice[item]):
		print("nie masz money")
		return
	var count = Prst.invent(item)
	var nd = get_tree().current_scene.find_child(Util.upgradeToName[item])
	nd.get_node("count").text = "x" + str(count)
	Prst.upgrade(item)
	Prst.moneyUpdated.emit()

func canBuyAnything():
	for item in availableUpgrades:
		if can_afford(Util.upgradeToName[item]):
			return true
	return false

func can_afford(itemName):
	return Prst.upgradePrice[Util.nameToUpgrade[itemName]] <= Prst.money
