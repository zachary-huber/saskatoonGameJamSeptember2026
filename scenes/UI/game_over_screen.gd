extends Control
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	await get_tree().create_timer(0.5).timeout
	animation_player.play("new_animation")
	SoundManager.death.play()
