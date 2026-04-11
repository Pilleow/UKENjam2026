extends Node

# skrypt globalny przechowujacy wszystkie dane trwałe (takie jak stan gracza, postęp itd.)

# time

signal timeUpdated
var timeLeftSecRaw: float = 360.0
var timeLeftSec: int = timeLeftSecRaw

func _process(delta: float) -> void:
	timeLeftSecRaw -= delta
	var timeleftSecPrev = timeLeftSec
	timeLeftSec = ceil(timeLeftSecRaw)
	if timeLeftSec != timeleftSecPrev:
		timeUpdated.emit()

# money

signal moneyUpdated
var money: int = 0

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
	Util.UPGRADES.GRAVITY_GLOVES: 3,
	Util.UPGRADES.EXOSKELETON: 3,
	Util.UPGRADES.WD40: 3
}

func upgrade(u):
	upgradesBought[u] += 1
	upgradePrice[u] = ceil(1.2 * upgradePrice[u])
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
	Util.INVENTIONS.HOVERBOARD: [2, 1, 0],
	Util.INVENTIONS.ROOMBA: [4, 0, 0],
	Util.INVENTIONS.FLYING_CAR: [2, 2, 1],
	Util.INVENTIONS.SEGWAY: [1, 1, 2]
}

func calcThingValue(u):
	var mod = [1, 1.1, 1.2]
	var pr = 0
	for st in range(3):
		pr += inventPrice[u][st] * mod[st]
	return pr

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
