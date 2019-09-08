extends Node

const DEFAULT_SCORE = 50
var score_limit = 50
var ball_amounts = 5

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