extends CharacterBody2D

@onready var animatedSprite = $AnimatedSprite2D
@onready var leftLedgeCheck = $LeftLedgeCheck
@onready var rightLedgeCheck = $RightLedgeCheck
@onready var idleTimer = $IdleTimer
@onready var disappearTimer = $DisappearTimer
@onready var appearTimer = $AppearTimer
@onready var collisionShape = $CollisionShape2D
var direction = Vector2.LEFT
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var move_speed = 40

func _ready():
	animatedSprite.animation = "Idle"
	idleTimer.start()
	

func _physics_process(delta):
	var found_left_ledge = not leftLedgeCheck.is_colliding()
	var found_right_ledge = not rightLedgeCheck.is_colliding()
		
	if found_left_ledge == true:
		direction = Vector2.RIGHT
		velocity = direction * move_speed
		
	if found_right_ledge == true:
		direction = Vector2.LEFT
		velocity = direction * move_speed
		
	if velocity.x == 0:
		velocity = direction * move_speed
		
	flipSprite()
	move_and_slide()

func _on_idle_timer_timeout():
	animatedSprite.animation = "Disappear"
	collisionShape.set_deferred("disabled", true)
	velocity = direction * 80
	disappearTimer.start()
	
	
	

func _on_disappear_timer_timeout():
	animatedSprite.animation = "Appear"
	collisionShape.set_deferred("disabled", false)
	velocity = direction * move_speed
	appearTimer.start()
	


func _on_appear_timer_timeout():
	animatedSprite.animation = "Idle"
	idleTimer.start()
	
func flipSprite():
	if velocity.x >= 1:
		animatedSprite.flip_h = true
	else:
		if velocity.x <= -1:
			animatedSprite.flip_h = false


