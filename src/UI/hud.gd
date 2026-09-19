class_name HUD extends Control

func _ready() -> void:
	GameManager.gameHUD = self

func toggleHUD() -> void:
	self.visible = !self.visible
