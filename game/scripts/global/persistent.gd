extends Node

# skrypt globalny przechowujacy wszystkie dane trwałe (takie jak stan gracza, postęp itd.)

# game state

var started = false
var counting_down = false

var defaults = {
	"invested": 0,
	"money": 0,
	"tasmaProperties": {
		"arm_reach": 1.0,
		"arm_speed": 1.0,
		"roll_speed": 1.0
	},
	"upgradePrice": {
		Util.UPGRADES.GRAVITY_GLOVES: 5,
		Util.UPGRADES.EXOSKELETON: 4,
		Util.UPGRADES.WD40: 3
	},
	"scrapAmount": [
		5,
		2,
		1
	],
	"timeLeft": 400
}

func restart():
	timeLeftSecRaw = defaults['timeLeft'] - 0.5
	timeLeftSec = defaults['timeLeft']
	invested = defaults['invested']
	money = defaults['money']
	tasmaProperties = defaults['tasmaProperties']
	upgradePrice = defaults['upgradePrice']
	scrap_amount = [
		5,
		2,
		1
	]
	print(scrap_amount)
	upgradesBought = {
		Util.UPGRADES.GRAVITY_GLOVES: 0,
		Util.UPGRADES.EXOSKELETON: 0,
		Util.UPGRADES.WD40: 0
	}
	inventedThings = {
		Util.INVENTIONS.HOVERBOARD: 0,
		Util.INVENTIONS.ROOMBA: 0,
		Util.INVENTIONS.FLYING_CAR: 0,
		Util.INVENTIONS.SEGWAY: 0
	}
	investmentChanged.emit()
	moneyUpdated.emit()
	scrapUpdated.emit()
	timeUpdated.emit()

# scenes

var previousScene = ""

# invest 

signal investmentChanged
var investTarget = 100 # 100
var invested = 0

func investMoney(v=1, h=0.12):
	if money < v:
		return -1
	var m12 = 1 + (Util.map_to_one_to_two(h) - 1) / 1.5
	Sound.play_random_variation("coin", Sound.default_volume_db, m12 - 0.05, m12 + 0.05)
	Prst.remove_money(v)
	invested += v
	investmentChanged.emit()
	if started and invested >= investTarget:
		started = false
		counting_down = false
		Music.stop_all_music(['main'])
		if get_tree():
			get_tree().change_scene_to_file("res://scenes/levels/cutsceneWin.tscn")
	return invested

# time

signal timeUpdated
var timeLeftSecRaw: float = 400.0 - 0.5
var timeLeftSec: int = timeLeftSecRaw

func _process(delta: float) -> void:
	if started and counting_down:
			decrement_time(delta)

func decrement_time(delta):
	timeLeftSecRaw -= delta
	var timeleftSecPrev = timeLeftSec
	timeLeftSec = ceil(timeLeftSecRaw)
	if timeLeftSec != timeleftSecPrev:
		timeUpdated.emit()
		if started and timeLeftSec < 0:
			started = false
			counting_down = false
			Music.turnHPFon()
			Music.stop_all_music(['main'])
			if get_tree():
				get_tree().change_scene_to_file("res://scenes/levels/fail.tscn")

# money

signal moneyUpdated
var money: int = 622

func add_money(v):
	money += v
	moneyUpdated.emit()
	return money

func remove_money(v):
	if money >= v:
		money -= v
		moneyUpdated.emit()
		return money
	else:
		return -1

# upgrades

signal upgradeBought
var upgradesBought = {
	Util.UPGRADES.GRAVITY_GLOVES: 0,
	Util.UPGRADES.EXOSKELETON: 0,
	Util.UPGRADES.WD40: 0
}
var upgradePrice = {
	Util.UPGRADES.GRAVITY_GLOVES: 5,
	Util.UPGRADES.EXOSKELETON: 4,
	Util.UPGRADES.WD40: 3
}
var upgradeEffectValues = {
	Util.UPGRADES.GRAVITY_GLOVES: 0.3,
	Util.UPGRADES.EXOSKELETON: 0.3,
	Util.UPGRADES.WD40: 0.25,
}
var tasmaProperties = {
	"arm_reach": 1.0,
	"arm_speed": 1.0,
	"roll_speed": 1.0
}

func upgrade(u):
	Sound.play_random_variation("buy", 5)
	upgradesBought[u] += 1
	upgradePrice[u] = ceil(1.7 * upgradePrice[u])
	match u:
		Util.UPGRADES.GRAVITY_GLOVES:
			tasmaProperties['arm_reach'] += upgradeEffectValues[u]
		Util.UPGRADES.EXOSKELETON:
			tasmaProperties['arm_speed'] += upgradeEffectValues[u]
		Util.UPGRADES.WD40:
			tasmaProperties['roll_speed'] += upgradeEffectValues[u]
	upgradeBought.emit()
	return upgradesBought[u]

# inventions

signal thingInvented
var inventedThings = {
	Util.INVENTIONS.HOVERBOARD: 0,
	Util.INVENTIONS.ROOMBA: 0,
	Util.INVENTIONS.FLYING_CAR: 0,
	Util.INVENTIONS.SEGWAY: 0
}
var inventPrice = {
	Util.INVENTIONS.HOVERBOARD: [2, 1, 1],
	Util.INVENTIONS.ROOMBA: [4, 0, 0],
	Util.INVENTIONS.FLYING_CAR: [0, 1, 3],
	Util.INVENTIONS.SEGWAY: [1, 2, 1]
}
var inventPriceComplexity = {
	Util.INVENTIONS.HOVERBOARD: 0.15,
	Util.INVENTIONS.ROOMBA: 0,
	Util.INVENTIONS.FLYING_CAR: 0.5,
	Util.INVENTIONS.SEGWAY: 0.25
}

func calcThingValue(u):
	var pr = 0
	for st in range(3):
		pr += inventPrice[u][st] * scrapRarity[0]/scrapRarity[st]
	pr *= (1 + inventPriceComplexity[u])
	return round(pr)

func invent(u):
	Sound.play_random_variation("buy", 5)
	inventedThings[u] += 1
	thingInvented.emit()
	return inventedThings[u]

# scrap

signal scrapUpdated
var scrap_amount = [
	5,
	2,
	1
]
var scrapRarity = [
	.5,
	.3,
	.2
]

func add_scrap(v):
	for type in range(3):
		scrap_amount[type] += v[type]
	scrapUpdated.emit()
	return scrap_amount

func remove_scrap(v):
	for type in range(3):
		if scrap_amount[type] < v[type]:
			return null
	for type in range(3):
		scrap_amount[type] -= v[type]
	scrapUpdated.emit()
	return scrap_amount
