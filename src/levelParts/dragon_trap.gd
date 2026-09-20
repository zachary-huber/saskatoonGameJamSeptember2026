class_name DragonTrap extends Node2D


@onready var dragonFireArea:Area2D = $dragon/dragonFireArea

func _ready() -> void:
	resetTrap()

func resetTrap() -> void:
	$dragon.visible = false
	dragonFireArea.monitorable = false
	dragonFireArea.monitoring = false

func activateTrap() -> void:
	$dragon.visible = true
	dragonFireArea.monitorable = true
	dragonFireArea.monitoring = true

func _on_dragon_baby_area_area_entered(area: Area2D) -> void:
	activateTrap()


func _on_dragon_fire_area_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player:
		GameManager.killPlayer()
