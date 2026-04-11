extends CharacterBody2D

@export var speed = 200;
@export var target_pos = 400;
var catch = false;

var start_pos = 0;

var time_to_move_back = 2.0;
var current_time = 0;
		
func _ready() -> void:
	start_pos = position.y;
	
func _move_back(delta:float) -> void:
	
	if catch:
		current_time += delta;
		velocity.y = 0;
		
	if current_time >= time_to_move_back:
		catch = false;
		velocity.y = speed;
		
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("m_left"):
		print("clicked!")
		velocity.y = -speed;
		
	#velocity.y = velocity.move_toward(velocity.y,spe)
	
	if position.y <= target_pos:
		
		position.y = start_pos;
		velocity.y = 0;
		
	move_and_slide()
		
		
		
