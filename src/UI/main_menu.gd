class_name MainMenu extends Control


func _on_start_run_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_quit_button_pressed() -> void:
	pass


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/UI/credits.tscn")
