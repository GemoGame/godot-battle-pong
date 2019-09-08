extends Node2D

export (int) var score_to_win = 5
onready var score = {
	"top" : 0,
	"bot" : 0
}

func _ready():
	SoundManager.play_music("game")


func add_score(side):
	score[side] += 1
	var label_node = $Score/Top
	if side == "bot":
		label_node = $Score/Bottom
	label_node.set_text(str(score[side]))
	
	if score[side] == score_to_win:
		win() if side == "bot" else lose()
		get_tree().paused = true


func win():
	print("You Win")


func lose():
	print("You Lose")