extends Node

# skrypt globalny przechowujacy wszystkie globalne funkcje pomocnicze oraz stale zmienne globalne

#enum NAZWA {
	#BURAK,
	#SEWERYN
#}

#func addVectors(v1, v2) ...

# colors 

var colors = {
	"scrap_t0": "#5f5",
	"scrap_t1": "#55f",
	"scrap_t2": "#f55"
}

# upgrades

enum UPGRADES {
	GRAVITY_GLOVES,
	EXOSKELETON,
	WD40
}
var upgradeToName = {
	Util.UPGRADES.GRAVITY_GLOVES: "gravity_gloves",
	Util.UPGRADES.EXOSKELETON: "exoskeleton_arm",
	Util.UPGRADES.WD40: "wd40",
}
var nameToUpgrade = {
	"gravity_gloves": Util.UPGRADES.GRAVITY_GLOVES,
	"exoskeleton_arm": Util.UPGRADES.EXOSKELETON,
	"wd40": Util.UPGRADES.WD40,
}

# inventions

enum INVENTIONS {
	HOVERBOARD,
	ROOMBA,
	FLYING_CAR,
	SEGWAY
}
var thingToName = {
	Util.INVENTIONS.HOVERBOARD: "hoverboard",
	Util.INVENTIONS.ROOMBA: "roomba",
	Util.INVENTIONS.FLYING_CAR: "flying_car",
	Util.INVENTIONS.SEGWAY: "segway"
}
var nameToInvent = {
	"hoverboard": Util.INVENTIONS.HOVERBOARD,
	"roomba": Util.INVENTIONS.ROOMBA,
	"flying_car": Util.INVENTIONS.FLYING_CAR,
	"segway": Util.INVENTIONS.SEGWAY
}

# easing functions

func ease_out_elastic(x: float) -> float:
	if x == 0.0:
		return 0.0
	if x == 1.0:
		return 1.0
	var c4 := (2.0 * PI) / 3.0
	return pow(2.0, -20.0 * x) * sin((x * 9.0 - 0.75) * c4) + 1.0

func ease_in_out_quint(x: float) -> float:
	return 16.0 * x * x * x * x * x if x < 0.5 else 1.0 - pow(-2.0 * x + 2.0, 5.0) / 2.0
