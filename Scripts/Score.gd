extends Control

func ball_out(ball, side):
	var label
	if side == "top":
		label = $Bottom
	else:
		label = $Top
	var current_score = int(label.get_text())
	label.set_text(str(current_score + 1))
	get_parent().get_node("BallController").reset_ball_state(ball)


func _on_TopArea_body_entered(body):
	ball_out(body, "top")


func _on_BottomArea_body_entered(body):
	ball_out(body, "bottom")