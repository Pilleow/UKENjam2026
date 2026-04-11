extends CharacterBody2D

@export var speed:float = 200.0;
@export var comeback_speed: float = 300;
@export var target_pos: float = 400.0;

var catch = false;
var move2startpos = false;

#sprawdz czy gracz oddal juz zlom na smietnik lub do plecaka 
var decision = true;

var start_pos = 0;

var time_to_move_back = 0.1;
var current_time = 0;
		
func _ready() -> void:
	start_pos = position.y;
	
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
		if position.y >= start_pos:
			move2startpos = false;
			current_time = 0;
			velocity.y = 0;
			position.y = start_pos;
		
func _physics_process(delta: float) -> void:
	

	if Input.is_action_just_pressed("m_left") and decision:
		#print("clicked!")
		velocity.y = -speed;
		
	#velocity.y = velocity.move_toward(velocity.y,spe)
	
	if position.y <= target_pos :
		catch = true;
		#position.y = start_pos;
		#velocity.y = 0;
		#
	_move_back(delta)
		
	move_and_slide()
		
		
		
