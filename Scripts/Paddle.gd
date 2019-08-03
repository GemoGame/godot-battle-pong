extends KinematicBody2D

### GAME VARIABLE ###
const GAME_SIZE = Vector2(576, 1024)

### PADDLE VARIABLE ###
export (int) var SPEED = 500
export (int) var DIFFERENCE_TOLERANCE = 300
export (int) var PADDLE_SEGMENT = 5
onready var PADDLE_SIZE = $CollisionShape2D.shape.extents
var velocity = Vector2(0, 0)


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
		velocity.x = SPEED
	elif position.x > target.x:
		velocity.x = -SPEED


func calculate_reflect_difference(ball):
	var difference = abs(position.x - ball.position.x)
	if difference > 100:
		difference = 100
	var segment_size = PADDLE_SIZE.x/PADDLE_SEGMENT
	var modifier = (difference/segment_size)
	# If hitting middle paddle
	if difference < 10:
		modifier = 0.1
	if difference < 25:
		modifier = 0.5
	var new_velocity_x = (ball.velocity.x * modifier * 1.1)
	ball.velocity = Vector2(new_velocity_x, ball.velocity.y).normalized() * \
					ball.BASE_VELOCITY * ball.velocity_modifier
	ball.check_velocity_limit()