## Game Manager .gd
extends Node

var runStartTimeTicks:int = 0
var runCurrentTimeSeconds:int = 0
var runEndTimeTicks:int = 0
var currentRunStats:RunStats

## UI stuff
var gameHUD:HUD = null

## register elements
# NOTE: set the type for this once it is defined by script.
var player = null


func _ready() -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("escape"):
		if gameHUD: gameHUD.toggleHUD()

# Load and show the main menu scene
func seeMainMenu() -> void:
	get_tree().change_scene_to_file("res://scenes/UI/main_menu.tscn")

# Begins a run from the starting point
func startRun() -> void:
	setRunStartTimeTicks()
	resetRunStats()

# Exit and shutdown the game application
func quitGame() -> void:
	cleanup()
	get_tree().quit()

# Do anything that needs to be done before we quit the game
func cleanup() -> void:
	pass

# Ends the current run session (status = lose)
func endRun() -> void:
	setRunEndTimeTicks()

# Ends the current run session with a WIN status
func winGame() -> void:
	pass

# Start the run from the beginning again, during a run
func restartRun() -> void:
	# check if there is a current run
	resetRunStats()
	# load game scene again ... or just move player back to start perhaps.
	# reload()
	startRun()

# Set current run stats to a new default run stats object
func resetRunStats() -> void:
	currentRunStats = RunStats.new()

func setRunStartTimeTicks() -> void:
	runStartTimeTicks = Time.get_ticks_usec()

func setRunEndTimeTicks() -> void:
	runEndTimeTicks = Time.get_ticks_usec()

# Make player die and probably end the run.
func killPlayer() -> void:
	pass

# Parse command and do something or call some function
func issueCommand(thisCommand:HUD.Commands) -> void:
	match thisCommand:
		HUD.Commands.winGame:
			winGame()
		HUD.Commands.endRun:
			endRun()
		HUD.Commands.restartRun:
			restartRun()
		HUD.Commands.killPlayer:
			killPlayer()
		HUD.Commands.quitGame:
			quitGame()
		HUD.Commands.mainMenu:
			seeMainMenu()
