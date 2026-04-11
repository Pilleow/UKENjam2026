extends Node2D


func _ready() -> void:
	Prst.connect("scrapUpdated", updateScrap)
	Prst.connect("timeUpdated", updateTime)
	Prst.connect("moneyUpdated", updateMoney)
	Prst.connect("investmentChanged", updateInvest)
	updateInvest()
	updateScrap()
	updateTime()
	updateMoney()
	$target.max_value = Prst.investTarget
	
func updateScrap():
	$scrap.text = "[color=" + Util.colors['scrap_t0'] + "]" + str(Prst.scrap_amount[0]) + "    "
	$scrap.text += "[color=" + Util.colors['scrap_t1'] + "]" + str(Prst.scrap_amount[1]) + "    "
	$scrap.text += "[color=" + Util.colors['scrap_t2'] + "]" + str(Prst.scrap_amount[2])

func _physics_process(delta):
	var cnt = $targetText.get_theme_font_size("font_size")
	var delt :float = float(cnt) - 24.0
	if cnt > 24:
		($targetText as Label).add_theme_font_size_override("font_size", 
			24.0 + delt * (1.0 - delta) * 0.8
		)
	if cnt < 24:
		($targetText as Label).add_theme_font_size_override("font_size", 
		24
	)


func updateMoney():
	$money.text = "$" + str(Prst.money)
	
	
func updateTime():
	$time.text = str(Prst.timeLeftSec)
	
func updateInvest():
	var tarM = max(0, min(Prst.investTarget, Prst.invested))
	$target.value = tarM
	$targetText.text = "$" + str(tarM) + " / $" + str(Prst.investTarget)
	($targetText as Label).add_theme_font_size_override("font_size", 38)
