extends RigidBody2D

@onready var ray_cast_2d: RayCast2D = $RayCast2D

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		apply_impulse(Vector2(0,5000))
	
	if event.is_action_pressed("stand up"):
		if ray_cast_2d.is_colliding():
			print("colliding")
			freeze = true
			call_deferred("set_pos")
		

func set_pos() -> void:
	#global_position = lerp(global_position,ray_cast_2d.get_collision_point() + Vector2(0, -70), .1)
	global_position = ray_cast_2d.get_collision_point() + Vector2(0, -70)
	
func _physics_process(delta: float) -> void:
	var direction : float = Input.get_axis("move left", "move right")
	if direction != 0:
		apply_central_force(Vector2(direction,0) * 2000)
