class_name HUD extends Control

enum Commands {
	winGame,
	endRun,
	restartRun,
	killPlayer,
	teleportStart,
	teleportEnd,
	quitGame,
	mainMenu
}

func _ready() -> void:
	GameManager.gameHUD = self

func toggleHUD() -> void:
	self.visible = !self.visible
