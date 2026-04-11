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
var counter_max = 1.5;
var counter = 0;	


# 0 - smiec, 1,2,3 - zlom1,2,3 
#warning -> to nie sa procenty tylko prrogi ktore wyznacza funckja _procentage !!!! (line 39)
var srap_distribution = [0,0,0,0];

# x0- prawdopodobienstwo smiecia ,x1,x2,x3 - prawd zlom1,2,3 
func _procentage(x0: float, x1: float, x2: float,x3: float):
	if x0+x1+x2+x3 != 1:
		print("Error: zla dystrybucja ");
		
	srap_distribution[0] = x0;
	srap_distribution[1] = x0+x1;
	srap_distribution[2] = srap_distribution[1]+x2;
	# to w sumie nie potrzebne XD
	srap_distribution[3] = srap_distribution[2]+x3;

func _ready() -> void:
	
	#tu ustawiasz proceny
	
	# x0- prawdopodobienstwo smiecia ,x1,x2,x3 - prawd zlom1,2,3 
	_procentage(0.3,0.4,0.2,0.1)


	randomize()

	# 1. Random Float between 0.0 and 1.0
	
func _spawn(delta: float) -> void:
	counter += delta;
	if counter >= counter_max:
		
		var chance = randf()
		if chance < srap_distribution[0]:
			zlom = smiec.instantiate();
		elif chance < srap_distribution[1]:
			zlom = zlom1.instantiate();
		elif chance < srap_distribution[2]:
			zlom = zlom2.instantiate();
		else:
			zlom = zlom3.instantiate();
			
		zlom.global_position = Vector2(200,400);

		counter = 0;
		add_child(zlom);

		
func _physics_process(delta: float) -> void:
		_spawn(delta);

	
