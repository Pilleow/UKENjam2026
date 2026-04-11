extends RichTextLabel


func _ready():
	#Prst.scrapUpdated.connect(update)
	update()

func update():
	var prices = Prst.inventPrice[Util.nameToInvent[get_parent().name]]
	text = ''
	for i in range(3):
		text += "[color=" + Util.colors['scrap_t' + str(i)] + "]" + str(prices[i]) + '    '
