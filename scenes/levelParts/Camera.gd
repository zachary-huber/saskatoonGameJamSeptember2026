extends Camera2D

@onready var player: Node2D = $"../Node2D/chair"

var camera_x_inc : int
var camera_y_inc : int
var cam_grid_loc : Vector2 = Vector2(0,0)
var player_pos : Vector2

func _process(delta: float) -> void:
	player_pos = player.global_position
	camera_x_inc = floor(player_pos.x / 1280)
	camera_y_inc = floor(player_pos.y / 720)
	if camera_x_inc != floor(cam_grid_loc.x / 1280) or camera_y_inc != floor(cam_grid_loc.y / 720) :
		cam_grid_loc = Vector2((camera_x_inc * 1280) + 1280 - 640,(camera_y_inc * 720) + 720 - 360)
		position = cam_grid_loc

		if camera_x_inc == 0 or (camera_x_inc == 2 and camera_y_inc == -3):
			SoundManager.wind.play()
			if SoundManager.indoor.playing:
				SoundManager.indoor.playing = false
		else: 
			SoundManager.indoor.play()
			if SoundManager.wind.playing:
				SoundManager.wind.playing = false
	
