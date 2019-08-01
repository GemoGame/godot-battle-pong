extends KinematicBody2D

const GAME_SIZE = Vector2(576, 1024)
const MAX_VELOCITY = 2000

#onready var ball_size = round($CollisionShape2D.shape.radius * 2)
onready var ball_size = round($CollisionShape2D.shape.extents.x)
var velocity

func _ready():
	collision_layer = 0
	collision_mask = 0
	set_collision_layer_bit(3, true)
	set_collision_mask_bit(0, true)
	set_collision_mask_bit(1, true)
	set_collision_mask_bit(3, true)
	remove_from_group("Ball")
	add_to_group("Projection")


func spawn(pos, velocity):
	position = pos
	self.velocity = velocity * 3


func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.normal)
		SPEED_up(1.1)
#	if position.y < ball_size:
#		velocity *= 0
#	if position.y > (GAME_SIZE.y - ball_size):
#		velocity *= 0


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
		label = get_node("/root/Game/Score/Top")
	if side == "bottom":
		label = get_node("/root/Game/Score/Bottom")
	var current_score = int(label.get_text())
	label.set_text(str(current_score + 1))
	get_node("/root/Game/Enemy").check_ball_status()
	queue_free()