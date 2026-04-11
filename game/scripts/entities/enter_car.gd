extends Area2D

@onready var player = get_tree().get_first_node_in_group("player")

@export var previousSceneName = "levelBase"
@export var autoInteract = false
@export_node_path() var fadein
@export_file_path("*.tscn") var next_scene = "res://scenes/levels/transition.tscn"

var blocked = false

func _ready() -> void:
	connect("body_entered", on_body_entered)
	call_deferred("_r_def")
	
func _r_def():
	if autoInteract:
		$label3.hide()

func on_body_entered(b):
	if blocked:
		$label3.text = "Explore first!"
		$label3/AnimatedSprite2D.hide()
	else:
		$label3.text = "Get more scrap"
		$label3/AnimatedSprite2D.show()
	if b == player and autoInteract:
		$CollisionShape2D.disabled = true
		Prst.previousScene = previousSceneName
		var f = get_node(fadein)
		f.start()
		await f.timeout
		if get_tree():
			get_tree().change_scene_to_file(next_scene)

func _input(event):
	if player in get_overlapping_bodies() and event.is_action_pressed("interact") and not blocked:
		Prst.previousScene = previousSceneName
		var f = get_node(fadein)
		f.start()
		await f.timeout
		if get_tree():
			Prst.counting_down = true
			get_tree().change_scene_to_file(next_scene)
