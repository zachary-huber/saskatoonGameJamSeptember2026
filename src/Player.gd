class_name Player extends RigidBody2D

var standing : bool = false
var timer_activated : bool = false

@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var timer: Timer = $Timer
@onready var chair: Sprite2D = $Chair
@onready var head_sprite: Sprite2D = $head/HeadSprite
@onready var right_side: Node2D = $RightSide
@onready var left_side: Node2D = $LeftSide

func _ready() -> void:
	left_side.visible = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("jump") and standing:
		print("starting Timer")
		timer_activated = true
		timer.start(3)
	
	if event.is_action_released("jump") and timer_activated:
		var time_left = -timer.time_left + 3
		var changer : int
		if right_side.visible == true:
			changer = 1
		else:
			changer = -1
		var direction = Vector2(100 * changer,-400) * time_left
		disable_standing()
		apply_impulse(direction)
		timer_activated = false
	
	if event.is_action_pressed("stand up"):
		if standing:
			disable_standing()
		elif ray_cast_2d.is_colliding():
			enable_standing()
	
func _physics_process(delta: float) -> void:
	var direction : float = Input.get_axis("move left", "move right")
	
	if standing:
		if direction < 0:
			flip_left()
		elif direction > 0:
			flip_right()
		global_position = lerp(global_position,ray_cast_2d.get_collision_point() + Vector2(direction * 10, -10), 0.1)
		rotation = lerp(rotation, 0.0, 0.1)
		if ray_cast_2d.is_colliding() == false:
			disable_standing()
	else:
		find_velocity()
	ray_cast_2d.rotation = -rotation

func find_velocity() -> void:
	pass

func disable_standing() -> void:
	standing = false
	freeze = false

func enable_standing() -> void:
	standing = true
	freeze = true

func flip_left() -> void:
	chair.flip_h = true
	head_sprite.flip_h = true
	right_side.visible = false
	left_side.visible = true

func flip_right() -> void:
	chair.flip_h = false
	head_sprite.flip_h = false
	right_side.visible = true
	left_side.visible = false
