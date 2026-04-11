extends Node

# skrypt globalny przechowujacy wszystkie dane trwałe (takie jak stan gracza, postęp itd.)

# scenes

var previousScene = ""

# invest 

signal investmentChanged
var investTarget = 200
var invested = 0

func investMoney(v=1):
	if money < v:
		return -1
	Prst.remove_money(v)
	invested += v
	investmentChanged.emit()
	return invested

# time

signal timeUpdated
var timeLeftSecRaw: float = 360.0
var timeLeftSec: int = timeLeftSecRaw

func _process(delta: float) -> void:
	decrement_time(delta)

func decrement_time(delta):
	timeLeftSecRaw -= delta
	var timeleftSecPrev = timeLeftSec
	timeLeftSec = ceil(timeLeftSecRaw)
	if timeLeftSec != timeleftSecPrev:
		timeUpdated.emit()

# money

signal moneyUpdated
var money: int = 6

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
	Util.UPGRADES.GRAVITY_GLOVES: 4,
	Util.UPGRADES.EXOSKELETON: 4,
	Util.UPGRADES.WD40: 4
}
var upgradeEffectValues = {
	Util.UPGRADES.GRAVITY_GLOVES: 0.12,
	Util.UPGRADES.EXOSKELETON: 0.06,
	Util.UPGRADES.WD40: 0.03,
}
var tasmaProperties = {
	"arm_reach": 1.0,
	"arm_speed": 1.0,
	"roll_speed": 1.0
}

func upgrade(u):
	upgradesBought[u] += 1
	upgradePrice[u] = ceil(1.2 * upgradePrice[u])
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
	Util.INVENTIONS.HOVERBOARD: 0.10,
	Util.INVENTIONS.ROOMBA: 0,
	Util.INVENTIONS.FLYING_CAR: 0.35,
	Util.INVENTIONS.SEGWAY: 0.20
}

func calcThingValue(u):
	var pr = 0
	for st in range(3):
		pr += inventPrice[u][st] * scrapRarity[0]/scrapRarity[st]
	pr *= (1 + inventPriceComplexity[u])
	return round(pr)

func invent(u):
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
