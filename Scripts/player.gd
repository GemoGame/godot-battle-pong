extends "res://Scripts/paddle.gd"

### PADDLE VARIABLE ###
const NORMAL_POSITION = Vector2(288, 976)

### INPUT VARIABLE###
var input_position = Vector2(576/2, 0)

func _ready():
	position = NORMAL_POSITION


func has_reached_input_target():
	return position.x <= (input_position.x + DIFFERENCE_TOLERANCE) and position.x >= (input_position.x - DIFFERENCE_TOLERANCE)


func _physics_process(delta):
	if Input.is_action_pressed("ui_touch"):
		input_position = get_global_mouse_position()
		calculate_position_difference(input_position)
#	if Input.is_action_pressed("ui_right):
#		velocity.x = SPEED
#		print("Right")
#	elif Input.is_action_pressed("ui_left"):
#		velocity.x = -SPEED
#		print("Left")
#	elif Input.is_action_just_released("ui_right") or Input.is_action_just_released("ui_left"):
#		velocity.x = 0
#		print("Released")
	if has_reached_input_target() or is_at_edge():
		velocity.x = 0
	var collision = move_and_collide(velocity * delta)
	if collision:
		if collision.collider.is_in_group("Ball"):
			calculate_reflect_difference(collision.collider)