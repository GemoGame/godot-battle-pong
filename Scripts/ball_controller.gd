extends Node2D

export (int) var total_ball = 1

const BALL_SCENE = preload("res://Scenes/ball.tscn")
const GAME_SIZE = Vector2(576, 1024)

func _ready():
	while get_tree().get_nodes_in_group("Ball").size()  < total_ball :
		spawn_ball()


func spawn_ball():
	var ball = BALL_SCENE.instance()
	ball.position = GAME_SIZE/2
	add_child(ball)