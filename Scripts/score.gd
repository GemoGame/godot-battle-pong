extends Control

export (bool) var ENABLED_SCORE_AREA = true


func _ready():
	if !ENABLED_SCORE_AREA:
		$BottomArea/CollisionShape2D.disabled = true
		$TopArea/CollisionShape2D.disabled = true
		visible = false


func ball_out(ball, side):
	var label
	if side == "top":
		label = $Bottom
	else:
		label = $Top
	var current_score = int(label.get_text())
	label.set_text(str(current_score + 1))
	ball.destroy()


func _on_TopArea_body_entered(body):
	ball_out(body, "top")


func _on_BottomArea_body_entered(body):
	ball_out(body, "bottom")