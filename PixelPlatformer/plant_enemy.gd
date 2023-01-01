extends CharacterBody2D

@onready var Bullet = preload("res://plant_bullet.tscn").instantiate()
@onready var animatedSprite = $AnimatedSprite2D
@onready var bulletStart = $BulletStartPosition
signal shoot(Bullet, direction, location)


func _on_left_detect_body_entered(body):
	animatedSprite.flip_h = false
	animatedSprite.animation = "Attack"
	shoot.emit()

func _on_right_detect_body_entered(body):
	animatedSprite.flip_h = true
	animatedSprite.animation = "Attack"
	shoot.emit()

func _on_left_detect_body_exited(body):
	animatedSprite.animation = "Idle"


func _on_right_detect_body_exited(body):
	animatedSprite.animation = "Idle"
	
#func shoot():
#
#	Bullet.transform = bulletStart.transform
#	add_child(Bullet)
