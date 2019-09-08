extends KinematicBody2D

### GAME VARIABLE ###
const GAME_SIZE = Vector2(576, 1024)

### PADDLE VARIABLE ###
export (int) var SPEED = 500
export (int) var DIFFERENCE_TOLERANCE = 300
export (int) var PARTICLE_THRESHOLD = 5
export (int) var PADDLE_SEGMENT = 5
onready var PADDLE_SIZE = $CollisionShape2D.shape.extents
onready var STARTING_POSITION = position
var velocity = Vector2(0, 0)
var speed_modifier = 1 # For player when pick an items

func is_at_edge():
	if velocity.x < 0 and position.x <= PADDLE_SIZE.x:
		# Left edge
		return true
	if velocity.x > 0 and position.x >= GAME_SIZE.x - PADDLE_SIZE.x:
		# Right edge
		return true
	return false


func has_align_target(target):
	return 	position.x <= (target.x + DIFFERENCE_TOLERANCE) and \
			position.x >= (target.x - DIFFERENCE_TOLERANCE)


func calculate_position_difference(target):
	if has_align_target(target) or is_at_edge():
		velocity.x = 0
	elif position.x < target.x:
		velocity.x = SPEED * speed_modifier
	elif position.x > target.x:
		velocity.x = -SPEED * speed_modifier


func calculate_reflect_difference(ball):
	var BASE_SPEED = 50
	var ball_modifier = 1
	if ball.velocity.x < 0:
		ball_modifier = -1
	var difference = abs(position.x - ball.position.x)
	if difference > 100:
		difference = 100
	var modifier = (ceil(difference/(100 / PADDLE_SEGMENT)) * 2) - 1
	var new_velocity_x = rand_range(BASE_SPEED * modifier, BASE_SPEED * modifier * 2) * ball_modifier * (ball.velocity.y / ball.BASE_VELOCITY)
	ball.velocity = Vector2(new_velocity_x, ball.velocity.y).normalized() * \
					ball.BASE_VELOCITY * ball.velocity_modifier


func _process(delta):
	if abs(velocity.x) <= PARTICLE_THRESHOLD:
		$ParticleLeft.emitting = false
		$ParticleRight.emitting = false
	elif velocity.x > PARTICLE_THRESHOLD:
		$ParticleLeft.emitting = true
	elif velocity.x < PARTICLE_THRESHOLD:
		$ParticleRight.emitting = true
	if position.y != STARTING_POSITION.y:
		position.y = STARTING_POSITION.y