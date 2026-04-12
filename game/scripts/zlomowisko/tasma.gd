extends Node2D

@onready var reka = find_child("Reka")
@export var smiec: PackedScene
@export var zlom1: PackedScene
@export var zlom2: PackedScene
@export var zlom3: PackedScene

var items_speed = 250

@export var max_capacity_pack = 10;
@export var max_capacity_bin = 999;


var pack_ypos = 0;
var smietnik_pos =  Vector2(200,540);
var koszyk_pos =  Vector2(1100,600);
var spawn_pos = Vector2(0,190);

var block_size = 40;

#0 - bin, 1- backpack
var current_cap = [0,0];

#threshold do przesuwania bloczkow w smietniku/koszyku
# czyli moze byc 4 bloczki 1 pod drugim i potem juz ukladaja sie obok znowu do 4 az do limitu :D
var push_threshold = 4
#o ile popychamy bloczek 
var push_pack_x = 100;
var zlom = 0;
#odstep czasowy pomiedzy złomem
var counter_max = 1 / Prst.tasmaProperties['roll_speed'];
var counter = 0;

# 0 - smiec, 1,2,3 - zlom1,2,3 
#warning -> to nie sa procenty tylko prrogi ktore wyznacza funckja _procentage !!!! (line 39)
var srap_distribution = [0,0,0,0];

# x0- prawdopodobienstwo smiecia ,x1,x2,x3 - prawd zlom1,2,3 
func _procentage(x0: float, x1: float, x2: float,x3: float):
		
	srap_distribution[0] = x0;
	srap_distribution[1] = x0+x1;
	srap_distribution[2] = srap_distribution[1]+x2;
	# to w sumie nie potrzebne XD
	srap_distribution[3] = srap_distribution[2]+x3;

func _ready() -> void:
	Music.stop_music("ovAm")
	Music.play_music("facAm", "res://assets/music/factory ambient.wav", 0, .5, 8)
	Music.play_music("line", "res://assets/music/assembly line.wav", 0, .5, 15, Prst.tasmaProperties['roll_speed'])
	counter = counter_max - 0.5
	#tu ustawiasz proceny
	
	# x0- prawdopodobienstwo smiecia ,x1,x2,x3 - prawd zlom1,2,3 
	pack_ypos = smietnik_pos.y;
	_procentage(0.17,0.45,0.2,0.18)
	randomize()

var pushed = [false,false];
func _updateXpos()->void:

	if current_cap[0] >= push_threshold and not pushed[0]:
		smietnik_pos.x += push_pack_x;
		smietnik_pos.y = pack_ypos + 50;
		pushed[0] = true;
			
	if current_cap[1] >= push_threshold and not pushed[1]:
		koszyk_pos.x -= push_pack_x;
		koszyk_pos.y = pack_ypos+ 50;
		pushed[1] = true;
	# 1. Random Float between 0.0 and 1.0
	
func _spawn(delta: float) -> void:
	counter += delta;
	if counter >= counter_max:
		
		var chance = randf()
		if chance < srap_distribution[0]:
			zlom = smiec.instantiate();
		elif chance < srap_distribution[1]:
			zlom = zlom1.instantiate();
			zlom.tier = 0
		elif chance < srap_distribution[2]:
			zlom = zlom2.instantiate();
			zlom.tier = 1
		else:
			zlom = zlom3.instantiate();
			zlom.tier = 2
			
		zlom.global_position = spawn_pos;

		counter = randf_range(-counter_max/2.0, counter_max/2.0);
		add_child(zlom);

func updateLimitLabel():
	$CanvasLayer/plecak.text = str(current_cap[1]) + "/" + str(max_capacity_pack)
	if current_cap[1] >= max_capacity_pack:
		reka.enable_w = false
		$hints/hint1.hide()
		$hints/hint3.hide()
		$hints/hint4.hide()
		$hints/hint2.position.x -= 242

func _physics_process(delta: float) -> void:
	_spawn(delta);
	$tasma/Parallax2D.autoscroll.x = (items_speed * Prst.tasmaProperties['roll_speed'])
	#_updateXpos()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		Prst.previousScene = "tasma"
		var zloms = get_tree().get_nodes_in_group("save")
		var zlomsAdd = [0, 0, 0]
		for z in zloms:
			zlomsAdd[z.tier] += 1
		Prst.add_scrap(zlomsAdd)
		$CanvasLayer/FadeIn.start()
		await $CanvasLayer/FadeIn.timeout
		if get_tree():
			Music.stop_music("line")
			Music.stop_music("facAm")
			get_tree().change_scene_to_file("res://scenes/levels/walkTasma.tscn")
