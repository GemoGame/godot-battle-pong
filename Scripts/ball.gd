extends KinematicBody2D

### GAME VARIABLE ###
const ENEMY_NORMAL_POSITION = Vector2(288, 48)
const GAME_SIZE = Vector2(576, 1024)

### COLLISION VARIABLE ###
const ACCELERATE_COLLISION_PADDLE = 0.2
const ACCELERATE_COLLISION_OBSTACLE = 0.05

### BALL VARIABLE ###
const BALL_SIZE = 15
const BALL_TEXTURE = preload("res://Images/ball.png")
const BALL_EXPLOSION = preload("res://Scenes/ball_explosion_effect.tscn")
const BASE_VELOCITY = 500
const MAX_VELOCITY = 5000
var destination = Vector2(0, 0)
var velocity_modifier = 1
var velocity

### SPEED_POWER UP ###
const FAST_MODIFIER = 2.5 # Larger = Faster
const SLOW_MODIFIER = 0.333
enum {NORMAL_SPEED, FAST, SLOW}
var SPEED_POWER

### SIZE POWER UP ###
const SIZE_MODIFIER = 2
enum {NORMAL_SIZE, BIG, SMALL}
var SIZE_POWER


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
	# Reseting to start default value
	$Sprite.texture = BALL_TEXTURE
	$Ray1.visible = true
	$Ray2.visible = true
	destination = Vector2(0, 0)
	velocity_modifier = 1
	SPEED_POWER = NORMAL_SPEED
	SIZE_POWER = NORMAL_SIZE
	
	# Randomizing certain variable
	randomize_velocity()
	randomize_position()
	
	# Start physics
	set_physics_process(true)


func randomize_position():
	var x = floor(rand_range(100, GAME_SIZE.x - 100))
	var y = floor(rand_range(GAME_SIZE.y/3, GAME_SIZE.y*2/3))
	position = Vector2(x, y)


func randomize_velocity():
	var new_velocity = [0, 0]
	for i in range(2):
		while new_velocity[i] <= 0.5 and new_velocity[i] >= -0.5:
			new_velocity[i] = (rand_range(0, 3) - 1)
	velocity = Vector2(new_velocity[0], new_velocity[1]).normalized() * BASE_VELOCITY


func get_limited_vector(vector):
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
		var collide = collision.collider
#		print("Velocity Modifier Before : " + str(velocity_modifier))
		if !collide.is_in_group("SPEED_POWERUp"):
			velocity = velocity.bounce(collision.normal)
		if collide.is_in_group("Obstacle") and SPEED_POWER == NORMAL_SPEED:
			velocity_modifier += ACCELERATE_COLLISION_OBSTACLE
		if collide.is_in_group("Paddle") and SPEED_POWER == NORMAL_SPEED:
			velocity_modifier += ACCELERATE_COLLISION_PADDLE
			if ConfigManager.effect_on:
				$AudioStreamPlayer2D.play()
		if collide.name == "Enemy":
			destination = ENEMY_NORMAL_POSITION
	if SPEED_POWER == NORMAL_SPEED:
		velocity = get_limited_vector(velocity)
	ray_cast()
#	print("Velocity : " + str(velocity))
#	print("Length : " + str(velocity.length()))
#	print("Velocity Modifier : " + str(velocity_modifier))


func power_fast():
	normalized_velocity_power()
	velocity *= FAST_MODIFIER
	SPEED_POWER = FAST
	$Fast.start()


func power_slow():
	normalized_velocity_power()
	velocity *= SLOW_MODIFIER
	SPEED_POWER = SLOW
	$Slow.start()


func normalized_velocity_power():
	$Fast.stop()
	$Slow.stop()
	if SPEED_POWER == FAST:
		velocity /= FAST_MODIFIER
	if SPEED_POWER == SLOW:
		velocity /= SLOW_MODIFIER
	SPEED_POWER = NORMAL_SPEED


func power_big():
	normalized_size_power()
	change_sprite_collision_scale(SIZE_MODIFIER)
	SIZE_POWER = BIG
	$Size.start()


func power_small():
	normalized_size_power()
	change_sprite_collision_scale(float(1) / SIZE_MODIFIER)
	SIZE_POWER = SMALL
	$Size.start()


func normalized_size_power():
	$Size.stop()
	if SIZE_POWER == BIG:
		change_sprite_collision_scale(float(1) / SIZE_MODIFIER)
	if SIZE_POWER == SMALL:
		change_sprite_collision_scale(SIZE_MODIFIER)
	SIZE_POWER = NORMAL_SIZE


func change_sprite_collision_scale(modifier):
	$Sprite.scale *= modifier
	$CollisionShape2D.scale *= modifier


# -- WARNING NSFW CONTENT---
#
# Oh god what have i done...
# Who the hell wrote this abomination and cursed code ?!
# Wait... i know him, he is me...
# I hope i can get an enlightenment to fix this mess later (but i doubt it lol)
#
# PS : Pls forgive me, my future self or someone who will maintain this mess (also for you who must face this nightmarish code)
func ray_cast():
	rays[1]["collision"].cast_to = velocity.normalized() * 1500
	rays[1]["visual"].set_point_position(0, Vector2(0, 0))
	if rays[1]["collision"].is_colliding():
		var distance = position.distance_to(rays[1]["collision"].get_collision_point())
		rays[1]["visual"].set_point_position(1, rays[1]["collision"].cast_to.normalized() * distance)
		rays[2]["visual"].set_point_position(0, Vector2(0, 0))
		rays[2]["visual"].set_point_position(1, Vector2(0, 0))
		if rays[1]["collision"].get_collider().name == "BallDetector":
			rays[2]["collision"].cast_to = Vector2(0, 0)
			destination = rays[1]["collision"].get_collision_point()
		elif rays[1]["collision"].get_collider().name == "HorizontalBorder":
			rays[2]["collision"].cast_to = Vector2(0, 0)
		elif rays[1]["collision"].get_collision_normal() != Vector2():
			rays[2]["collision"].global_position = rays[1]["collision"].get_collision_point()
			rays[2]["collision"].cast_to = get_limited_vector(rays[1]["collision"].cast_to.bounce(rays[1]["collision"].get_collision_normal())).normalized() * 1500 # OOF
			rays[2]["visual"].set_point_position(1, rays[2]["collision"].cast_to)
			if rays[2]["collision"].is_colliding() && rays[2]["collision"].get_collider().name == "BallDetector":
				destination = rays[2]["collision"].get_collision_point()
	rays[1]["visual"].visible = Game.is_raycast_active
	rays[2]["visual"].visible = Game.is_raycast_active


### SPEED_POWER UP RELATED ###

func _on_Fast_timeout():
	normalized_velocity_power()


func _on_Slow_timeout():
	normalized_velocity_power()


func _on_Size_timeout():
	normalized_size_power()

