extends Node2D

export (int) var total_ball = 1

const BALL_SCENE = preload("res://Scenes/Ball.tscn")
const GAME_SIZE = Vector2(576, 1024)

func _ready():
	while get_tree().get_nodes_in_group("Ball").size()  < total_ball :
		spawn_ball()


func spawn_ball():
	var ball = BALL_SCENE.instance()
	randomize_ball_position(ball)
	add_child(ball)


func randomize_ball_position(ball):
	var x = floor(rand_range(GAME_SIZE.x/4, GAME_SIZE.x*3/4))
	var y = floor(rand_range(GAME_SIZE.y/3, GAME_SIZE.y*2/3))
	ball.position = Vector2(x, y)


func reset_ball_state(ball):
	randomize_ball_position(ball)
	ball.setup()