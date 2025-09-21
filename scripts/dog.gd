extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var bark: AudioStreamPlayer = $bark

func _on_body_entered(body: Node2D) -> void:
	animated_sprite_2d.play("alert")
	bark.play()
	Level02.play_noise_animation()
	Player.lose_game("Alereted the dog!")
