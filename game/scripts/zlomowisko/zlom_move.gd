extends Area2D

@onready var speed = 250;
@onready var tasma = get_parent()
@onready var reka = tasma.get_node("Reka")

@export var textures: Array[Texture2D]

@onready var sprite = $Sprite2D;

var max_capacity_pack = 0;
var max_capacity_bin = 0;

#var target_pos = Vector2(100,600);

var catched = false;
var done = false;
var block_size = 50;


#0 -smietnik, 1-koszy
var indx = 0
func _ready() -> void:
	max_capacity_bin = tasma.max_capacity_bin;
	max_capacity_pack = tasma.max_capacity_pack;
	sprite.scale = Vector2(5.0, 5.0)
	block_size = tasma.block_size;
	
	var ind = randi() % textures.size();
	sprite.texture = textures[ind];
	

# ind : 0-smietnik, 1-koszyk
func _position_scrap(ind: int) -> void:
	reka.decision = true;
	if ind == 0:
		reka.targetblock_pos = tasma.smietnik_pos;
		tasma.current_cap[ind] += 1;
	
		
	elif ind == 1:
		reka.targetblock_pos = tasma.koszyk_pos;
		#position = tasma.koszyk_pos;
		#tasma.koszyk_pos.y += block_size;
		tasma.current_cap[ind] += 1;

func _is_scrap_done(ind: int)->void:
			
	if not reka.decision and not reka.ready2grab :
		
		
		if ind == 0:
			if tasma.current_cap[ind] % 2 == 1:
				tasma.smietnik_pos.x += tasma.push_pack_x;
			else:
				tasma.smietnik_pos.y -= block_size;
				tasma.smietnik_pos.x -= tasma.push_pack_x;
		else:
			if tasma.current_cap[ind] % 2 == 1:
				tasma.koszyk_pos.x -= tasma.push_pack_x;
			else:
				tasma.koszyk_pos.y -= block_size;
				tasma.koszyk_pos.x += tasma.push_pack_x;
				
			#tasma.koszyk_pos.y -= block_size

		done = true;
		print("scrap is done") 
	
func _physics_process(delta: float) -> void:
	if not catched:
		position.x += speed*delta;
	else:		
		# wrzucic do kosza
		if not done:
			
			#reka.decision = false;
			position = reka.position;
			position.y -= block_size;
			#position = target_pos;  
			
			# gracz wywala zlom
			if Input.is_action_just_pressed("a") and tasma.current_cap[0] <= max_capacity_bin:
				indx = 0;
				_position_scrap(indx);
			# gracz kupuje zlom
			if Input.is_action_just_pressed("d")  and tasma.current_cap[1] <= max_capacity_pack:
				indx = 1
				_position_scrap(1);
  
			_is_scrap_done(indx);
func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free();
	pass # Replace with function body.

func _on_body_entered(body: Node2D) -> void:
	#if body.is_in_group("reka"):
	#position = Vector2(0,0);
	#print("catched");
	catched = true;
	pass # Replace with function body.
