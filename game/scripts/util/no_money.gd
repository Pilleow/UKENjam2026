extends Label


func _ready():
	Prst.moneyUpdated.connect(update)
	update()

func update():
	visible = not get_parent().get_parent().can_afford(get_parent().name)
