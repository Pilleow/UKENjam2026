extends ColorRect

var t = 0.2
var started = false

signal timeout

func _ready():
	color.a = 0
	hide()

func start():
	show()
	started = true

func _process(delta: float) -> void:
	if not started:
		return
	color.a = max(0, 1-Util.ease_out_expo(t*3))
	if color.a >= 1:
		timeout.emit()
	t -= delta
