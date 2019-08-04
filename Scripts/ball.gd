extends KinematicBody2D

### GAME VARIABLE ###
const ENEMY_NORMAL_POSITION = Vector2(288, 48)
const GAME_SIZE = Vector2(576, 1024)
var display_rays = true

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
	1 : {
		"collision" : $Ray1,
		"visual" : $Ray1/Line2D
		},
	2 : {
		"collision" : $Ray2,
		"visual" : $Ray2/Line2D
		}
	}


func _ready():
	setup()


func setup():
	randomize()
	destination = Vector2(0, 0)
	velocity_modifier = 1
	var new_velocity = [0, 0]
	for i in range(2):
		while new_velocity[i] <= 0.5 and new_velocity[i] >= -0.5:
			new_velocity[i] = (rand_range(0, 3) - 1)
	velocity = Vector2(new_velocity[0], new_velocity[1]).normalized() * BASE_VELOCITY


func check_vector_limit(vector):
	if vector.x > MAX_VELOCITY:
		vector.x = MAX_VELOCITY
	if vector.x < -MAX_VELOCITY:
		vector.x = -MAX_VELOCITY
	if vector.y > MAX_VELOCITY:
		vector.y = MAX_VELOCITY
	if vector.y < -MAX_VELOCITY:
		vector.y = -MAX_VELOCITY
	if abs(vector.x) > abs(vector.y) * 2/3:
		vector.x /= 2
		vector = vector.normalized() * BASE_VELOCITY * velocity_modifier
	return vector

func _physics_process(delta):
	if velocity == null:
		return
	var collision = move_and_collide(velocity * delta)
	if collision:
#		print("Velocity Modifier Before : " + str(velocity_modifier))
		velocity = velocity.bounce(collision.normal)
		if collision.collider.name == "Enemy":
			destination = ENEMY_NORMAL_POSITION
		if collision.collider.is_in_group("Paddle"):
			velocity_modifier += ACCELERATE_COLLISION_PADDLE
		if collision.collider.is_in_group("Obstacle"):
			velocity_modifier += ACCELERATE_COLLISION_OBSTACLE
#		print("Velocity Modifier After : " + str(velocity_modifier))
		velocity = check_vector_limit(velocity)
	ray_cast()
#	print("Velocity : " + str(velocity))
#	print("Length : " + str(velocity.length()))
#	print("Velocity Modifier : " + str(velocity_modifier))
	


# -- WARNING NSFW CONTENT---
#
# Oh god what have i done...
# Who the hell wrote this abomination and cursed code
# Wait... i know him, he is me...
# I hope i can get an enlightenment to fix this mess later (but i doubt it lol)
#
# PS : Pls forgive me, my future self (And you who read this nightmarish code)
func ray_cast():
	rays[1]["collision"].cast_to = velocity.normalized() * 1175
	rays[1]["visual"].set_point_position(0, Vector2(0, 0))
	rays[1]["visual"].set_point_position(1, rays[1]["collision"].cast_to)
	if rays[1]["collision"].is_colliding():
		if rays[1]["collision"].get_collider().name == "BallDetector":
			rays[2]["collision"].cast_to = Vector2(0, 0)
			rays[2]["visual"].set_point_position(1, Vector2(0, 0))
			destination = rays[1]["collision"].get_collision_point()
		elif rays[1]["collision"].get_collision_normal() != Vector2():
			rays[2]["collision"].global_position = rays[1]["collision"].get_collision_point()
			rays[2]["collision"].cast_to = check_vector_limit(rays[1]["collision"].cast_to.bounce(rays[1]["collision"].get_collision_normal()))
			rays[2]["visual"].set_point_position(0, Vector2(0, 0))
			rays[2]["visual"].set_point_position(1, rays[2]["collision"].cast_to)
			if rays[2]["collision"].is_colliding() && rays[2]["collision"].get_collider().name == "BallDetector":
				destination = rays[2]["collision"].get_collision_point()
	rays[1]["visual"].visible = display_rays
	rays[2]["visual"].visible = display_rays