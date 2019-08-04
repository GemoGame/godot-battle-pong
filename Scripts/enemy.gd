extends "res://Scripts/paddle.gd"

### GAME VARIABEL ###
export (bool) var EASY_MODE = true

### PADDLE VARIABLE ####
const NORMAL_POSITION = Vector2(288, 48)
var current_target = null


func get_target():
	if get_closest_ball() == null:
		return NORMAL_POSITION
	if EASY_MODE:
		return get_closest_ball().position
	else:
		return get_closest_ball().destination


func get_closest_ball():
	var closest_ball = null
	for ball in get_tree().get_nodes_in_group("Ball"):
		if closest_ball == null:
			closest_ball = ball
		if ball.position.y <= closest_ball.position.y and ball.velocity.y <= 0:
			closest_ball = ball
	return closest_ball


func _physics_process(delta):
	current_target = get_target()
	if (current_target == Vector2(0, 0) or 
		current_target.x <= 0 or
		current_target.x >= GAME_SIZE.x):
		calculate_position_difference(NORMAL_POSITION)
	else:
		calculate_position_difference(current_target)
	if is_at_edge():
		velocity.x = 0
	var collision = move_and_collide(velocity * delta)
	if collision:
		if collision.collider.is_in_group("Ball"):
			calculate_reflect_difference(collision.collider)
			current_target = null