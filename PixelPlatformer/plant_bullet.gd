extends Area2D

var speed = 2
var velocity = Vector2.ZERO

func _physics_process(delta):
	position += Vector2.LEFT * delta
