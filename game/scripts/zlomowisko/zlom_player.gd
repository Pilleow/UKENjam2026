extends CharacterBody2D

@export var speed:float = 200.0;
@export var comeback_speed: float = 300;
@export var target_pos: float = 200.0;
 
@onready var tasma = get_parent();

var catch = false;
var move2startpos = false;

#sprawdz czy gracz oddal juz zlom na smietnik lub do plecaka - jesli tak to odpala animacja do 
var decision = false;
var ready2grab = true;

var start_pos = Vector2(0,0);
var targetblock_pos = Vector2(100,350 );

var time_to_move_back = 0.1;
var current_time = 0;
		
func _ready() -> void:
	start_pos = position;


	
func _move_back(delta:float) -> void:
	
	# zlap zlom i poczekaj time_to_move_back czasu
	if catch:
		current_time += delta;
		velocity.y = 0;
	
	if current_time >= time_to_move_back:
		catch = false;
		velocity.y = comeback_speed;
		move2startpos = true;
	
	#wroc z zlomem do zadanej pozycji	
	if move2startpos:
		if position.y >= start_pos.y:
			move2startpos = false;
			current_time = 0;
			velocity.y = 0;
			position = start_pos;
			

func _getblock2pos(delta:float,pos: Vector2) -> void:
	
	if decision:
		ready2grab = false;
		position = position.move_toward(pos,delta*speed*5);
		if position == pos:
			decision = false;
			#ready2grab = true;
	if not ready2grab and not decision:
		if position != start_pos:
			#print("moving 2 start pos")
			position = position.move_toward(start_pos,delta*speed*5);
		else:
			ready2grab = true;

	
func _physics_process(delta: float) -> void:

	if Input.is_action_just_pressed("w") and ready2grab:
		#print("clicked!")
		velocity.y = -speed;
	
	#velocity.y = velocity.move_toward(velocity.y,spe)
	
	if position.y <= target_pos :
		catch = true;
		#position.y = start_pos;
		#velocity.y = 0;
		#
	_move_back(delta)
	
	_getblock2pos(delta, targetblock_pos)
		
	move_and_slide()
	

		
		
		
