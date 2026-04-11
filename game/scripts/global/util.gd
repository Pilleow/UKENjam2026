extends Node

# skrypt globalny przechowujacy wszystkie globalne funkcje pomocnicze oraz stale zmienne globalne

#enum NAZWA {
	#BURAK,
	#SEWERYN
#}

#func addVectors(v1, v2) ...

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
