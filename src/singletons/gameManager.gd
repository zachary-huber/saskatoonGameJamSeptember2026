## Game Manager .gd
extends Node

var runStartTimeTicks:int = 0
var runCurrentTimeTicks:int = 0
var runEndTimeTicks:int = 0
var currentRunStats:RunStats

func _ready() -> void:
	pass

func startRun() -> void:
	setRunStartTimeTicks()
	resetRunStats()

func endRun() -> void:
	setRunEndTimeTicks()

func resetRunStats() -> void:
	currentRunStats = RunStats.new()

func setRunStartTimeTicks() -> void:
	runCurrentTimeTicks = Time.get_ticks_usec()

func setRunEndTimeTicks() -> void:
	runEndTimeTicks = Time.get_ticks_usec()
