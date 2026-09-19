class_name Princess extends Node2D


func _ready() -> void:
	GameManager.princess = self

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player:
		interactPrincess()

func interactPrincess() -> void:
	# play whatever win animation on princess
	
	# say some words
	$sprite2D/nameTag.text = "WAZZUP"
	$sprite2D/winText.visible = true
	
	# play sound?
	GameManager.winGame()
