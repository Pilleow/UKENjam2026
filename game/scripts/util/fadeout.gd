extends ColorRect

var t = 0

func _ready():
	show()

func _process(delta: float) -> void:
	color.a = max(0, 1-Util.ease_out_expo(t/1.5))
	if color.a <= 0:
		queue_free()
	t += delta
