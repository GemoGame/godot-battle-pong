extends KinematicBody2D

signal ball_out

export (int) var SPEED = 300


const PROJECTION_PATH = "res://Scenes/BallProjection.tscn"
const GAME_SIZE = Vector2(576, 1024)
const MAX_VELOCITY = 2000


#onready var ball_size = round($CollisionShape2D.shape.radius * 2)
onready var ball_size = round($CollisionShape2D.shape.extents.x)
var velocity
var has_projection = false

func _ready():
	randomize()
	position = GAME_SIZE/2
	var new_velocity = [0, 0]
	for i in range(2):
		while new_velocity[i] <= 0.5 and new_velocity[i] >= -0.5:
			new_velocity[i] = (rand_range(0, 3) - 1)
	velocity = Vector2(new_velocity[0], new_velocity[1]).normalized() * SPEED
	print("Ball Spawned : " + str(velocity))


func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.normal)
		SPEED_up(1.1)
		if collision.collider.is_in_group("Paddle"):
			get_node("/root/Game/").create_projection()
	if position.y < ball_size * 2:
		ball_out("top")
	if position.y > (GAME_SIZE.y - ball_size * 2):
		ball_out("bottom")


func SPEED_up(modifier):
	velocity *= modifier
	if velocity.x > MAX_VELOCITY:
		velocity.x = MAX_VELOCITY
	if velocity.x < -MAX_VELOCITY:
		velocity.x = -MAX_VELOCITY
	if velocity.y > MAX_VELOCITY:
		velocity.y = MAX_VELOCITY
	if velocity.y < -MAX_VELOCITY:
		velocity.y = -MAX_VELOCITY
	print(velocity)


func ball_out(side):
	var label
	if side == "top":
		label = get_node("/root/Game/Score/Bottom")
	if side == "bottom":
		label = get_node("/root/Game/Score/Top")
	var current_score = int(label.get_text())
	label.set_text(str(current_score + 1))
	get_node("/root/Game/").check_ball_status()
	queue_free()


func create_projection():
	var projection = load(PROJECTION_PATH).instance()
	projection.spawn(position, velocity)
	get_node("/root/Game/").add_child(projection)
	has_projection = true