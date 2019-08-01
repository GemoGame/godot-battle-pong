extends KinematicBody2D

export (int) var SPEED = 500

### GAME VARIABLE ###
const GAME_SIZE = Vector2(576, 1024)
onready var batter_size = $CollisionShape2D.shape.extents

### BATTER VARIABLE ###
var velocity = Vector2(0, 0)

func is_at_edge():
	if velocity.x < 0 and position.x <= batter_size.x:
		# Left edge
		return true
	if velocity.x > 0 and position.x >= GAME_SIZE.x - batter_size.x:
		# Right edge
		return true
	return false