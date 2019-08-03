extends KinematicBody2D

### GAME VARIABLE ###
const ENEMY_NORMAL_POSITION = Vector2(288, 48)
const GAME_SIZE = Vector2(576, 1024)

### COLLISION VARIABLE ###
const ACCELERATE_COLLISION_PADDLE = 0.2
const ACCELERATE_COLLISION_OBSTACLE = 0.05

### BALL VARIABLE ###
const BASE_VELOCITY = 500
const MAX_VELOCITY = 5000
var destination = Vector2(0, 0)
var velocity_modifier = 1
var velocity

### RAY PROJECTION ###
onready var rays = {
	1 : $Ray1,
	2 : $Ray2
	}


func _ready():
	setup()


func setup():
	destination = Vector2(0, 0)
	velocity_modifier = 1
	var new_velocity = [0, 0]
	for i in range(2):
		while new_velocity[i] <= 0.5 and new_velocity[i] >= -0.5:
			new_velocity[i] = (rand_range(0, 3) - 1)
	velocity = Vector2(new_velocity[0], new_velocity[1]).normalized() * BASE_VELOCITY


func _physics_process(delta):
	if velocity == null:
		return
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.normal)
		if collision.collider.name == "Enemy":
			destination = ENEMY_NORMAL_POSITION
		if collision.collider.is_in_group("Paddle"):
			velocity_modifier += ACCELERATE_COLLISION_PADDLE
		if collision.collider.is_in_group("Obstacle"):
			velocity_modifier += ACCELERATE_COLLISION_OBSTACLE
	ray_cast()


func ray_cast():
	rays[1].cast_to = velocity * 3
	if rays[1].is_colliding():
		if rays[1].get_collider().name == "BallDetector":
			rays[2].cast_to = Vector2(0, 0)
			destination = rays[1].get_collision_point()
		elif rays[1].get_collision_normal() != Vector2():
				rays[2].global_position = rays[1].get_collision_point()
				rays[2].cast_to = rays[1].cast_to.bounce(rays[1].get_collision_normal())
				if rays[2].is_colliding() && rays[2].get_collider().name == "BallDetector":
					destination = rays[2].get_collision_point()


func check_velocity_limit():
	if velocity.x > MAX_VELOCITY:
		velocity.x = MAX_VELOCITY
	if velocity.x < -MAX_VELOCITY:
		velocity.x = -MAX_VELOCITY
	if velocity.y > MAX_VELOCITY:
		velocity.y = MAX_VELOCITY
	if velocity.y < -MAX_VELOCITY:
		velocity.y = -MAX_VELOCITY
	if abs(velocity.x) > abs(velocity.y) * 2/3:
		velocity.x *= 0.7
		velocity.y *= 1.1