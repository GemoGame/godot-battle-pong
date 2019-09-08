extends Node2D


const BALL_SCENE = preload("res://Scenes/ball.tscn")
const GAME_SIZE = Vector2(576, 1024)


### TOTAL BALL RELATED VARIABLE ###
export (int) var minimum_total_ball = 3
onready var current_total_ball = 0


func _ready():
	check_total_ball()


func check_total_ball():
	while current_total_ball < minimum_total_ball:
		spawn_ball()


func ball_destroyed():
	current_total_ball -= 1
	check_total_ball()


func spawn_ball():
	var ball = BALL_SCENE.instance()
	ball.position = GAME_SIZE/2
	current_total_ball += 1
	add_child(ball)


func ball_out(ball):
	call_deferred("ball_destroyed")
	ball_destroyed_effect(ball.global_position)
	ball.queue_free()


func ball_destroyed_effect(position_target):
	var BALL_EXPLOSION = load("res://Scenes/ball_explosion_effect.tscn")
	var effect = BALL_EXPLOSION.instance()
	get_parent().add_child(effect)
	effect.start(position_target)


func _on_TopArea_body_entered(body):
	ball_out(body)
	get_parent().add_score("bot")


func _on_BottomArea_body_entered(body):
	ball_out(body)
	get_parent().add_score("top")