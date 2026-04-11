extends Node2D

@export var ręka: PackedScene
@export var smiec: PackedScene
@export var zlom1: PackedScene
@export var zlom2: PackedScene
@export var zlom3: PackedScene

var smietnik_pos =  Vector2(100,100);
var koszyk_pos =  Vector2(1000,100);

var zlom = 0;
#odstep czasowy pomiedzy złomem
var counter_max = 1.0;
var counter = 0;	

func _ready() -> void:
	randomize()

	# 1. Random Float between 0.0 and 1.0

func _spawn(delta: float) -> void:
	counter += delta;
	if counter >= counter_max:
		var chance = randf()
		
		if chance < 0.25:
			zlom = smiec.instantiate();
		elif chance < 0.50:
			zlom = zlom1.instantiate();
		elif chance < 0.75:
			zlom = zlom2.instantiate();
		else:
			zlom = zlom3.instantiate();
			
		zlom.global_position = Vector2(200,400);

		counter = 0;
		add_child(zlom);

		
func _physics_process(delta: float) -> void:
		_spawn(delta);

	
