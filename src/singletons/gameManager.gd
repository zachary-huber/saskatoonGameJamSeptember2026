## Game Manager .gd
extends Node

var runStartTimeTicks:int = 0
var runCurrentTimeSeconds:int = 0
var runEndTimeTicks:int = 0
var currentRunStats:RunStats

## UI stuff
var gameHUD:HUD = null

## register elements


func _ready() -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("escape"):
		if gameHUD: gameHUD.toggleHUD()

func startRun() -> void:
	setRunStartTimeTicks()
	resetRunStats()

func endRun() -> void:
	setRunEndTimeTicks()

func resetRunStats() -> void:
	currentRunStats = RunStats.new()

func setRunStartTimeTicks() -> void:
	runStartTimeTicks = Time.get_ticks_usec()

func setRunEndTimeTicks() -> void:
	runEndTimeTicks = Time.get_ticks_usec()
