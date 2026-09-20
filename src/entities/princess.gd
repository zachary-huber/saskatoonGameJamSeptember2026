class_name Princess extends Node2D

var player_here : bool = false
var play_stat
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	GameManager.princess = self

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player:
		player_here = true
		print(player_here)


func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.get_parent() is Player:
		player_here = false
		print(player_here)
	pass # Replace with function body.
	

func interactPrincess() -> void:
	# play whatever win animation on princess
	animated_sprite_2d.play("happy")
	# say some words
	#$sprite2D/nameTag.text = "WAZZUP"
	#$sprite2D/winText.visible = true
