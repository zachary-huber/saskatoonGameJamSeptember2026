class_name DevButton extends Button

@export var devCommand:HUD.Commands = HUD.Commands.winGame


func _on_pressed() -> void:
	GameManager.issueCommand(devCommand)
