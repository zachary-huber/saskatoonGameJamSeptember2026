## Game Manager .gd
extends Node

var runStartTimeTicks:int = 0
var runCurrentTimeTicks:int = 0

func _ready() -> void:
	pass

func startRun() -> void:
	setRunStartTimeTicks()

func endRun() -> void:
	# return runStats
	pass

func setRunStartTimeTicks() -> void:
	runCurrentTimeTicks = Time.get_ticks_usec()
