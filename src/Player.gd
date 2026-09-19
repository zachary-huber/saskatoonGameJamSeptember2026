class_name Player extends RigidBody2D

var standing : bool = false
var timer_activated : bool = false
var setting_direction : bool = false
var increasing : int = -1

var cur_pos : float = 0
var last_pos : float = 0
var velocity : float

@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var left_detector: RayCast2D = $RayCast2D/LeftDetector
@onready var right_detector: RayCast2D = $RayCast2D/RightDetector
@onready var timer: Timer = $Timer
@onready var chair: Sprite2D = $Chair
@onready var head_sprite: Sprite2D = $head/HeadSprite
@onready var right_side: Node2D = $RightSide
@onready var left_side: Node2D = $LeftSide
@onready var anchor: Node2D = $Anchor
@onready var jump_direction_pivot: Marker2D = $Anchor/JumpDirectionPivot
@onready var jump_direction: Marker2D = $Anchor/JumpDirectionPivot/JumpDirection
@export var jumpStrengthProgressBar:TextureProgressBar = null

func _ready() -> void:
	GameManager.player = self
	left_side.visible = false

func _process(delta: float) -> void:
	var time_left = -timer.time_left + 2
	if jumpStrengthProgressBar: jumpStrengthProgressBar.value = remap(time_left, 0.0, 2.0, 0.0, 100.0)
	#if timer_activated:
		#self.scale.y = remap(time_left, 0.0, 2.0, 1.0, 0.5)
	#else:
		#self.scale.y = 1.0

func _input(event: InputEvent) -> void:
	if setting_direction:
		print(jump_direction.global_position)
	
	# set correct direction
	elif event.is_action_pressed("set direction") and standing:
		print("setting direction")
		setting_direction = true
	
	# begin charging jump
	if event.is_action_pressed("jump") and standing:
		timer_activated = true
		timer.start(2)
		# show jump indicator
		if jumpStrengthProgressBar: jumpStrengthProgressBar.visible = true
	
	# release charging and actually jump
	if event.is_action_released("jump") and timer_activated:
		var time_left = -timer.time_left + 2
		var changer : int
		if right_side.visible == true:
			changer = 1
		else:
			changer = -1
		var direction = Vector2(100 * changer,-400) * time_left
		disable_standing()
		apply_impulse(direction)
		timer_activated = false
		# hide jump indicator
		if jumpStrengthProgressBar: jumpStrengthProgressBar.visible = false
	
	# stand up if flopping around
	if event.is_action_pressed("stand up"):
		if standing:
			disable_standing()
		elif ray_cast_2d.is_colliding() and (velocity < 1.0 and velocity > -1.0):
			enable_standing()


func _physics_process(delta: float) -> void:
	var direction : float = Input.get_axis("move left", "move right")
	
	if standing:
		if direction < 0:
			flip_left()
			if left_detector.is_colliding():
				print("should stop")
			else:
				print("moving left")
				apply_movement(direction)
		elif direction > 0:
			flip_right()
			if right_detector.is_colliding():
				print("should stop")
			else:
				print("moving right")
				apply_movement(direction)
				
				
		rotation = lerp(rotation, 0.0, 0.1)
		if ray_cast_2d.is_colliding() == false:
			disable_standing()
	else:
		find_velocity()
		constant_torque = direction * 2000
	
	if setting_direction:
		if jump_direction_pivot.rotation_degrees > 0:
			increasing = -1
		elif jump_direction_pivot.rotation_degrees < -90:
			increasing = 1
		jump_direction_pivot.rotation_degrees += increasing
	ray_cast_2d.rotation = -rotation
	anchor.rotation = -rotation

func apply_movement(direction : int) -> void:
	global_position = lerp(global_position,ray_cast_2d.get_collision_point() + Vector2(direction * 10, -16), 0.1)

func find_velocity() -> void:
	last_pos = cur_pos
	cur_pos = global_position.x
	velocity = last_pos - cur_pos

func disable_standing() -> void:
	standing = false
	freeze = false

func enable_standing() -> void:
	standing = true
	freeze = true

func flip_left() -> void:
	chair.flip_h = false
	head_sprite.flip_h = false
	right_side.visible = false
	left_side.visible = true
	jump_direction.scale.x = -1

func flip_right() -> void:
	chair.flip_h = true
	head_sprite.flip_h = true
	right_side.visible = true
	left_side.visible = false
	jump_direction.scale.x = 1
