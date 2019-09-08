extends Node

const DEFAULT_SCORE = 50
var score_limit = 50
var ball_amounts = 5
var ai_difficulty = "hard"

const GAME_SIZE = Vector2(576, 1024)
var is_raycast_active = false


onready var level = {
	"easy" : "res://Scenes/Game/game_easy.tscn",
	"normal" : "res://Scenes/Game/game_normal.tscn",
	"hard" : "res://Scenes/Game/game_hard.tscn"
}


func set_default_limit():
	score_limit = DEFAULT_SCORE


func set_score_limit(limit):
	score_limit = limit


func get_score_limit():
	return score_limit


func set_ball_amounts(total):
	ball_amounts = total


func get_ball_amounts():
	return ball_amounts


func set_difficulty(difficulty):
	ai_difficulty = difficulty


func load_level():
	get_tree().paused = false
	get_tree().change_scene(level[ai_difficulty])