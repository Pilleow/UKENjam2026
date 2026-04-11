extends Node2D

@export var init_time_sec:float = 1.5
var time_sec: float

func _ready() -> void:
	$CanvasLayer/overlay.show()
	time_sec = init_time_sec
	if Prst.previousScene == "levelBase":
		$CanvasLayer/Label.text = "Going to scrapyard"
	if Prst.previousScene == "tasma":
		$CanvasLayer/Label.text = "Going to base"

func _process(delta: float) -> void:
	Prst.decrement_time(delta)
	time_sec -= delta
	var t_start:float = min(1, max(0, init_time_sec - time_sec))
	var t_end:float = min(1, max(0, time_sec))
	$CanvasLayer/overlay.color.a = 1-min(
		Util.ease_in_out_quint(t_start*3),
		Util.ease_in_out_quint(t_end*3)
	)
	if time_sec < 0:
		if Prst.previousScene == "levelBase":
			get_tree().change_scene_to_file("res://scenes/levels/tasma.tscn")
		if Prst.previousScene == "tasma":
			get_tree().change_scene_to_file("res://scenes/levels/levelBase.tscn")
