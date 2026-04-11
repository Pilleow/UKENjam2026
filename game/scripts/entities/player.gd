extends CharacterBody2D


const SPEED = 400.0
var extra_speed = 0
const JUMP_VELOCITY = -500.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta * 3

	# Handle jump.
	if Input.is_action_pressed("ui_accept"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
			#extra_speed += 100
	elif is_on_floor():
		extra_speed = 0
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("a", "d")
	if direction:
		$AnimatedSprite2D.animation = "run"
		velocity.x = direction * (SPEED + extra_speed)
		$AnimatedSprite2D.flip_h = direction < 0
	else:
		$AnimatedSprite2D.animation = "idle"
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
