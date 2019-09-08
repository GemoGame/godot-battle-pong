extends Control


func show():
	$AnimationPlayer.play("fade_in")


func hide():
	$AnimationPlayer.play("fade_out")