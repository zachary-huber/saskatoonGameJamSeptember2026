class_name Princess extends Node2D


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player:
		interactPrincess()

func interactPrincess() -> void:
	# play whatever win animation on princess
	
	# say some words
	
	# play sound?
	GameManager.winGame()
