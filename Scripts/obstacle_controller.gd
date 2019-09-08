extends Node2D


const OBSTACLES_SCENE = [
	preload("res://Scenes/Obstacle/obstacle_1.tscn"),
	preload("res://Scenes/Obstacle/obstacle_2.tscn"),
	preload("res://Scenes/Obstacle/obstacle_3.tscn"),
	preload("res://Scenes/Obstacle/obstacle_4.tscn"),
	preload("res://Scenes/Obstacle/obstacle_5.tscn")
]

var obstacle_queue = []
var current_obstacle


func _ready():
	randomize()
	next_obstacle()


func randomize_queue():
	obstacle_queue = OBSTACLES_SCENE.duplicate()
	obstacle_queue.shuffle()


func next_obstacle():
	if !has_next_queue():
		randomize_queue()
		print("Randomizing Obstacles Now")
		print("Available Scene ", OBSTACLES_SCENE)
		print("Queue ", obstacle_queue)
	current_obstacle = obstacle_queue.pop_front().instance()
	add_child(current_obstacle)
	$ChangeTimer.start()


func has_next_queue():
	return obstacle_queue.size() > 0


func _on_ChangeTimer_timeout():
	current_obstacle.hide()
	next_obstacle()
