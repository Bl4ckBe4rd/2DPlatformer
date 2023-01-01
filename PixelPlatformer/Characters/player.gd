extends CharacterBody2D



const SPEED = 200.0
const JUMP_VELOCITY = -350.0
var max_jump = 1
var jump_count = 0
var wall_pushback = 150
var coyote_jump = false

@onready var animatedSprite = $AnimatedSprite2D
@onready var wallCheck = $RayCast2D
@onready var coyoteJumpTimer = $CoyoteJumpTimer
@onready var jumpSound = $AudioStreamPlayer2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
func _ready():
	animatedSprite.playing = true

func _physics_process(delta):
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta / 1.2
		
		if velocity.y <= 0:
			animatedSprite.animation = "Jump"
		else:
			animatedSprite.animation = "Fall"
	else:
		if velocity.x == 0:
			animatedSprite.animation = "Idle"
		else:
			animatedSprite.animation = "Run"
			
	
	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jumpSound.play()
	
	if Input.is_action_just_pressed("jump") and not is_on_floor() and jump_count < max_jump:
		velocity.y = JUMP_VELOCITY
		jumpSound.play()
		jump_count += 1
			
	if is_on_floor() and jump_count != 0:
		jump_count = 0
		
		
	if is_near_wall() and not is_on_floor():
		animatedSprite.animation = "Wall"
		if Input.is_action_just_pressed("jump"):
			velocity.y = JUMP_VELOCITY / 1.2
			jumpSound.play()
			if $RayCast2D.rotation == -90:
				velocity.x -= 1200 * .7
			if $RayCast2D.rotation == 90:
				velocity.x += 1200 * .7
	if is_near_wall() and velocity.y > 30:
		velocity.y = 30
	
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if velocity.x > 0:
		animatedSprite.flip_h = false
		$RayCast2D.rotation = -90
	else:
		if velocity.x < 0:
			animatedSprite.flip_h = true
			$RayCast2D.rotation = 90
			
	var was_on_floor = is_on_floor()
	
			
	move_and_slide()
	if was_on_floor and not is_on_floor():
		coyote_jump = true
		coyoteJumpTimer.start()

func is_near_wall():
	return $RayCast2D.is_colliding()


func _on_coyote_jump_timer_timeout():
	coyote_jump = false
