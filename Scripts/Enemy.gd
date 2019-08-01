extends "res://Scripts/Paddle.gd"

### INPUT ###
export (int) var DIFFERENCE_TOLERANCE = 20
var input_position = Vector2(576/2, 0)

#
#func get_ball_position():
#	var closest_ball = Vector2(0, GAME_SIZE.y)
#	for ball in get_tree().get_nodes_in_group("Ball"):
#		if ball.position.y <= closest_ball.y:
#			closest_ball = ball.position
#	return closest_ball
#
#
#func has_align_target(target):
#	return position.x <= (target.x + DIFFERENCE_TOLERANCE) and position.x >= (target.x - DIFFERENCE_TOLERANCE)
#
#
#func _physics_process(delta):
#	var ball_target = get_ball_position()
#	if position.x <= ball_target.x:
#		velocity.x = SPEED
#		print("Left")
#	elif position.x >= ball_target.x:
#		velocity.x = -SPEED
#		print("Right")
#	if has_align_target(ball_target) or is_at_edge():
#		velocity.x = 0
#	move_and_collide(velocity * delta)


func get_ball_position():
	var closest_ball = Vector2(0, GAME_SIZE.y)
	for ball in get_tree().get_nodes_in_group("Ball"):
		if ball.position.y <= closest_ball.y:
			closest_ball = ball.position
	return closest_ball


func has_align_target(target):
	return position.x <= (target.x + DIFFERENCE_TOLERANCE) and position.x >= (target.x - DIFFERENCE_TOLERANCE)


func _physics_process(delta):
	var ball_target = get_ball_position()
	if position.x <= ball_target.x:
		velocity.x = SPEED
	elif position.x >= ball_target.x:
		velocity.x = -SPEED
	if has_align_target(ball_target) or is_at_edge():
		velocity.x = 0
	move_and_collide(velocity * delta)