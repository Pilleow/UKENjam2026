extends Node


func _ready() -> void:
	Prst.connect("scrapUpdated", updateScrap)
	Prst.connect("timeUpdated", updateTime)
	Prst.connect("moneyUpdated", updateMoney)
	updateScrap()
	updateTime()
	updateMoney()
	
func updateScrap():
	$scrap_t0.text = str(Prst.scrap_amount[0])
	$scrap_t1.text = str(Prst.scrap_amount[1])
	$scrap_t2.text = str(Prst.scrap_amount[2])
	
	
func updateMoney():
	$money.text = "$" + str(Prst.money)
	
	
func updateTime():
	$time.text = str(Prst.timeLeftSec)
	
