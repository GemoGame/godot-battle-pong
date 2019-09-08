extends KinematicBody2D

onready var controller = get_node("../../ItemController")
const DROP_AREA_MARGIN = 100
const DROP_START_Y = 100
const SPEED = 400

func _ready():
	randomize_drop_position()
	$AnimationPlayer.play("spin")


func randomize_drop_position():
	var random_x = rand_range(DROP_AREA_MARGIN, Game.GAME_SIZE.x - DROP_AREA_MARGIN)
	global_position = Vector2(random_x, DROP_START_Y)