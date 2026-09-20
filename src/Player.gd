class_name Player extends RigidBody2D

var standing : bool = false
var timer_activated : bool = false
var setting_direction : bool = false
var increasing : int = -1
var can_play : bool = true

var cur_pos : Vector2
var last_pos : Vector2
var velocity : Vector2

var h_jump_dist : int = 150 ## Player can jump 25 blocks horizontally
var v_jump_dist : int = 400 ## PLAYER CAN JUMP 17 BLOCKS HIGH

@onready var middle_1: RayCast2D = $Middle1
@onready var middle_2: RayCast2D = $Middle2
@onready var left_detector: RayCast2D = $LeftDetector
@onready var right_detector: RayCast2D = $RightDetector
@onready var timer: Timer = $Timer
@onready var right_side: Node2D = $RightSide
@onready var left_side: Node2D = $LeftSide
@onready var anchor: Node2D = $Anchor
@onready var interact_area: Area2D = $interactArea
@onready var jump_direction_pivot: Marker2D = $Anchor/JumpDirectionPivot
@onready var jump_direction: Marker2D = $Anchor/JumpDirectionPivot/JumpDirection
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@export var jumpStrengthProgressBar:TextureProgressBar = null

@onready var chair: Sprite2D = $Chair
@onready var r_leg1: Sprite2D = $RightSide/leg1/Sprite2D
@onready var r_horse: Sprite2D = $RightSide/pony/Sprite2D
@onready var r_leg2: Sprite2D = $RightSide/leg2/Sprite2D
@onready var r_forearm: Sprite2D = $RightSide/forearm/Sprite2D
@onready var r_arm: Sprite2D = $RightSide/arm/Sprite2D
@onready var r_pole: Sprite2D = $RightSide/pole/Sprite2D
@onready var r_head: Sprite2D = $RightSide/head/HeadSprite
@onready var r_fether: Sprite2D = $RightSide/fether/Sprite2D
@onready var l_leg1: Sprite2D = $LeftSide/leg1/Sprite2D
@onready var l_horse: Sprite2D = $LeftSide/pony/Sprite2D
@onready var l_leg2: Sprite2D = $LeftSide/leg2/Sprite2D
@onready var l_forearm: Sprite2D = $LeftSide/forearm/Sprite2D
@onready var l_arm: Sprite2D = $LeftSide/arm/Sprite2D
@onready var l_pole: Sprite2D = $LeftSide/pole/Sprite2D
@onready var l_head: Sprite2D = $LeftSide/head/HeadSprite
@onready var l_fether: Sprite2D = $LeftSide/fether/Sprite2D
var sprite_array : Array[Sprite2D]

func _ready() -> void:
	sprite_array.append(chair)
	sprite_array.append(r_leg1)
	sprite_array.append(r_horse)
	sprite_array.append(r_leg2)
	sprite_array.append(r_forearm)
	sprite_array.append(r_arm)
	sprite_array.append(r_pole)
	sprite_array.append(r_head)
	sprite_array.append(r_fether)
	sprite_array.append(l_leg1)
	sprite_array.append(l_horse)
	sprite_array.append(l_leg2)
	sprite_array.append(l_forearm)
	sprite_array.append(l_arm)
	sprite_array.append(l_pole)
	sprite_array.append(l_head)
	sprite_array.append(l_fether)
	
	body_entered.connect(bonk)
	GameManager.player = self
	left_side.visible = false

func _process(delta: float) -> void:
	var time_left = -timer.time_left + 2
	if jumpStrengthProgressBar: jumpStrengthProgressBar.value = remap(time_left, 0.0, 2.0, 0.0, 100.0)
	if timer_activated:
		for i in sprite_array:
			i.scale.y = remap(time_left, 0.0, 2.0, 1.0, 0.5)

func _input(event: InputEvent) -> void:
	if can_play:
		if setting_direction:
			print(jump_direction.global_position)
		
		# set correct direction
		elif event.is_action_pressed("set direction") and standing:
			print("setting direction")
			setting_direction = true
		
		# begin charging jump
		if event.is_action_pressed("jump"):
			if not standing:
				if (middle_1.is_colliding() or middle_2.is_colliding()) and (velocity.x < 1.0 and velocity.x > -1.0):
					enable_standing()
			elif standing:
				timer_activated = true
				timer.start(2)
				# show jump indicator
				if jumpStrengthProgressBar: 
					jumpStrengthProgressBar.visible = true
		
		# release charging and actually jump
		if event.is_action_released("jump") and timer_activated:
			var time_left = -timer.time_left + 2
			var changer : int
			if right_side.visible == true:
				changer = 1
			else:
				changer = -1
			var direction = Vector2(h_jump_dist * changer, -v_jump_dist) * time_left
			for i in sprite_array:
				i.scale.y = 1.0
				SoundManager.jump.play()
			disable_standing()
			apply_impulse(direction)
			timer_activated = false
			# hide jump indicator
			if jumpStrengthProgressBar: jumpStrengthProgressBar.visible = false


func _physics_process(delta: float) -> void:
	var direction : float
	if can_play:
		direction = Input.get_axis("move left", "move right")
	
	if standing:
		if direction < 0:
			flip_left()
			if left_detector.is_colliding():
				pass
			else:
				apply_movement(direction)
		elif direction > 0:
			flip_right()
			if right_detector.is_colliding():
				pass
			else:
				apply_movement(direction)
				
		global_position.y = lerp(global_position.y,middle_1.get_collision_point().y, 0.1)
		rotation = lerp(rotation, 0.0, 0.1)
		if middle_1.is_colliding() == false and middle_2.is_colliding() == false:
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
	middle_1.rotation = -rotation
	middle_2.rotation = -rotation
	anchor.rotation = -rotation

func apply_movement(direction : float) -> void:
	global_position.x = lerp(global_position.x,middle_1.get_collision_point().x + direction * 10, 0.1)

func bonk(body : Node2D) -> void:
	if body.is_in_group("killer"):
		GameManager.killPlayer()
	
	elif abs(velocity.x) > 7 or abs(velocity.y) > 7:
		audio_stream_player_2d.play()

func find_velocity() -> void:
	last_pos = cur_pos
	cur_pos = global_position
	velocity = last_pos - cur_pos

func disable_standing() -> void:
	standing = false
	freeze = false

func enable_standing() -> void:
	if GameManager.princess.player_here:
		print("hello")
		can_play = false
		GameManager.winGame()
	standing = true
	freeze = true

func flip_left() -> void:
	chair.flip_h = false
	right_side.visible = false
	left_side.visible = true
	jump_direction.scale.x = -1

func flip_right() -> void:
	chair.flip_h = true
	right_side.visible = true
	left_side.visible = false
	jump_direction.scale.x = 1


func _on_interact_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("collectible"):
		var collectible = area.get_parent()
		print("collided with collectible: ", collectible.name)
		GameManager.collect(collectible)
		SoundManager.collect.play()
		collectible.queue_free()
		print("deleted collectible: ", collectible.name)
