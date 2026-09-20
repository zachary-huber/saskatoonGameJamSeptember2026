class_name HUD extends Control

enum Commands {
	winGame,
	endRun,
	restartRun,
	killPlayer,
	teleportStart,
	teleportEnd,
	quitGame,
	mainMenu,
	startRun,
	teleportToPrincess
}

func _ready() -> void:
	GameManager.gameHUD = self
	updatesTimeLabel()

func toggleHUD() -> void:
	$developerPanel.visible = !$developerPanel.visible

func updatesTimeLabel() -> void:
	$stopwatchTimeLabel.text = str(getTimeInSeconds()).pad_decimals(2)
	await get_tree().create_timer(0.05).timeout
	if GameManager.isRunOngoing:
		updatesTimeLabel()
	else:
		$stopwatchTimeLabel.text = str(getCompleteRunTimeSeconds()).pad_decimals(2)
		return

func getTimeInSeconds() -> float:
	return (Time.get_ticks_usec() - GameManager.runStartTimeTicks) / 1000000.0

func getCompleteRunTimeSeconds() -> float:
	return (GameManager.runEndTimeTicks - GameManager.runStartTimeTicks) / 1000000.0

func setCollectibleLabel(newText:String) -> void:
	$collectibleTrackLabel.text = newText
