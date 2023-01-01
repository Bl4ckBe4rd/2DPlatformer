extends Area2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var sprite = $Sprite2D
@onready var sound = $AudioStreamPlayer2D


func _on_body_entered(_body):
	animated_sprite.visible = true
	sprite.visible = false
	animated_sprite.play("collected")
	sound.play()
	
func _on_animated_sprite_2d_animation_finished():
	queue_free()
