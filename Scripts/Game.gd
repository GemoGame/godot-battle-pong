extends Node2D

const BALL_SCENE = preload("res://Scenes/Ball.tscn")

func _ready():
	create_projection()

func check_ball_status():
	var current_balls = get_tree().get_nodes_in_group("Ball").size() - 1
	if current_balls == 0:
		spawn_ball()


func create_projection():
	remove_projection()
	get_tree().call_group("Ball", "create_projection")


func spawn_ball():
	var ball = BALL_SCENE.instance()
	add_child(ball)

func remove_projection():
	for projection in get_tree().get_nodes_in_group("Projection"):
		projection.queue_free()