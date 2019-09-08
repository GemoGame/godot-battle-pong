extends "res://Scripts/paddle.gd"

### PADDLE VARIABLE ###
const NORMAL_POSITION = Vector2(288, 976)

### INPUT VARIABLE###
var input_position = Vector2(576/2, 0)


func _ready():
	position = NORMAL_POSITION


func _physics_process(delta):
	if Input.is_action_pressed("ui_touch"):
		input_position = get_global_mouse_position()
		calculate_position_difference(input_position)

	if has_align_target(input_position) or is_at_edge():
		velocity.x = 0
	
	# Keyboard Testing
	if Input.is_action_pressed("ui_right"):
		velocity.x = SPEED
		print("Right")
	elif Input.is_action_pressed("ui_left"):
		velocity.x = -SPEED
		print("Left")
	elif Input.is_action_just_released("ui_right") or Input.is_action_just_released("ui_left"):
		velocity.x = 0
		print("Released")
	
	var collision = move_and_collide(velocity * delta)
	if collision:
		if collision.collider.is_in_group("Ball"):
			calculate_reflect_difference(collision.collider)


func speed_up():
	speed_modifier = 2
	$ItemSpeedEffect.start()


func slow_down():
	speed_modifier = 0.5
	$ItemSpeedEffect.start()


func _on_ItemSpeedEffect_timeout():
	speed_modifier = 1