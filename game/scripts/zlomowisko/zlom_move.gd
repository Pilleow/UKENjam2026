extends Area2D

@onready var tasma = get_parent()
var speed;
@onready var reka = tasma.get_node("Reka")

@export var textures: Array[Texture2D]
@onready var sprite:Sprite2D = $Sprite2D;

var max_capacity_pack = 0;
var max_capacity_bin = 0;
var tier = -1;

#var target_pos = Vector2(100,600);

var catched = false;
var done = false;
var block_size = 50;



#0 -smietnik, 1-koszy
var indx = 0
func _ready() -> void:
	speed = tasma.items_speed
	add_to_group("scrap")
	max_capacity_bin = tasma.max_capacity_bin;
	max_capacity_pack = tasma.max_capacity_pack;
	sprite.scale = Vector2(5.0, 5.0)
	if randf() > .5:
		sprite.flip_h = true
	sprite.rotation = randf() * 2 * PI
	sprite.offset.y = randf() * 10 - 5
	block_size = tasma.block_size;
	
	var ind = randi() % textures.size();
	sprite.texture = textures[ind];

# ind : 0-smietnik, 1-koszyk
func _position_scrap(ind: int) -> void:
	if reka.position == reka.start_pos:
		reka.decision = true;
		if ind == 0:
			reka.targetblock_pos = tasma.smietnik_pos;
			#tasma.current_cap[ind] += 1; nie uzywamy juz limitu na koszu
			tasma.updateLimitLabel()

		elif ind == 1:
			reka.targetblock_pos = tasma.koszyk_pos;
			#position = tasma.koszyk_pos;
			#tasma.koszyk_pos.y += block_size;
			tasma.current_cap[1] += 1;
			tasma.updateLimitLabel()

func _is_scrap_done(ind: int)->void:
	
	#position scrab on left and right side 	
	if not reka.decision and not reka.ready2grab :
		
		if ind == 0:
			pass
		else:
			if tasma.current_cap[ind] % 2 == 1:
				tasma.koszyk_pos.x -= tasma.push_pack_x;
			else:
				tasma.koszyk_pos.y -= block_size;
				tasma.koszyk_pos.x += tasma.push_pack_x;
				
			#tasma.koszyk_pos.y -= block_size
		
		reka.open()
		done = true;

func _process(delta: float) -> void:
	if not catched:
		position.x += (speed * Prst.tasmaProperties['roll_speed']) * delta;

func _physics_process(delta: float) -> void:
	if not catched:
		if position.x > 1500:
			queue_free()
	else:		
		
		# wrzucic do kosza
		#reka.ready2grab = false;
		if not done:
			#reka.decision = false;
			position = reka.position;
			position.y -= block_size;
			#position = target_pos;  
			
			# gracz wywala zlom
			if Input.is_action_just_pressed("a") and tasma.current_cap[0] < max_capacity_bin and reka.enable_input:
				print("current bin cap:", tasma.current_cap[0])
				indx = 0;
				_position_scrap(indx);
				add_to_group("smiec")
			# gracz kupuje zlom
			if Input.is_action_just_pressed("d")  and tasma.current_cap[1] < max_capacity_pack and reka.enable_input:
				indx = 1;
				print("current koszyk cap:", tasma.current_cap[1])

				_position_scrap(1);
				add_to_group("save")
  
			_is_scrap_done(indx);
		elif is_in_group("smiec"):
			sprite.scale.x -= 0.1
			sprite.scale.y -= 0.1
			if sprite.scale.x <= 0:
				queue_free()

func _on_body_entered(body: Node2D) -> void:
	#if body.is_in_group("reka"):
	#position = Vector2(0,0);
	if catched:
		return
	for o in get_tree().get_nodes_in_group("scrap"):
		if o.catched and not o.done:
			return
	reka.close()
	catched = true
	sprite.offset.y = 0
	reka.enable_w = false;
	pass # Replace with function body.
