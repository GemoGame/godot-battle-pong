extends Node2D


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