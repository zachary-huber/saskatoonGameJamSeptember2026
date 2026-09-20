## Game Manager .gd
extends Node

var runStartTimeTicks:int = 0
var runCurrentTimeSeconds:int = 0
var runEndTimeTicks:int = 0
var currentRunStats:RunStats

var currentCollectibles:int = 0
var maxCollectibles:int = 30


@export var isRunOngoing:bool = false

## register elements
var gameHUD:HUD = null
var player:Player = null
var princess:Princess = null


func _ready() -> void:
	pass

func _input(event: InputEvent) -> void:
	#pass
	if event.is_action_pressed("escape"):
		if gameHUD: gameHUD.toggleHUD()

# Load and show the main menu scene
func seeMainMenu() -> void:
	get_tree().change_scene_to_file("res://scenes/UI/main_menu.tscn")

# Begins a run from the starting point
func startRun() -> void:
	setRunStartTimeTicks()
	resetRunStats()
	get_tree().change_scene_to_file("res://scenes/game.tscn")
	isRunOngoing = true

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
	isRunOngoing = false

# Ends the current run session with a WIN status
func winGame() -> void:
	endRun()

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
	print("we died")
	get_tree().change_scene_to_file("res://scenes/UI/gameOverScreen.tscn")
	pass

func teleportToPrincess() -> void:
	if princess:
		player.global_position = princess.global_position + Vector2(-50.0, -200.0)

func collect(thisCollectible:Collectible) -> void:
	print("collecting collectible: ", thisCollectible.name)
	self.currentCollectibles += 1
	gameHUD.setCollectibleLabel(str(currentCollectibles) + "/" + str(maxCollectibles))

# Parse command and do something or call some function
func issueCommand(thisCommand:HUD.Commands) -> void:
	print("Developer Command: ", HUD.Commands.find_key(thisCommand))
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
		HUD.Commands.startRun:
			startRun()
		HUD.Commands.teleportToPrincess:
			teleportToPrincess()
