extends Area2D

@onready var speed = 250;
@onready var tasma = get_parent()
@onready var reka = tasma.get_node("Reka")

var target_pos = Vector2(100,600);

var catched = false;
var done = false;
var block_size = 50;

	
func _physics_process(delta: float) -> void:
	if not catched:
		position.x += speed*delta;
	else:		
		# wrzucic do kosza
		
		if not done:
			
			reka.decision = false;
			position = reka.position;
			position.y -= block_size;
			#position = target_pos;
			if Input.is_action_just_pressed("a"):
				print("zlom rozjebany!")
				position = tasma.smietnik_pos;
				tasma.smietnik_pos.y += block_size;
				done = true;
				reka.decision = true;

			#kupic 
			if Input.is_action_just_pressed("d"):
				print("zlom kupiony!")
				position = tasma.koszyk_pos;
				tasma.koszyk_pos.y += block_size;
				reka.decision = true;
				done = true;
		
func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free();
	pass # Replace with function body.

func _on_body_entered(body: Node2D) -> void:
	#if body.is_in_group("reka"):
	#position = Vector2(0,0);
	print("catched");
	catched = true;
		
	pass # Replace with function body.
