extends Control


func _ready():
	show()


func show():
	$AnimationPlayer.play("show")


func hide():
	$AnimationPlayer.play("hide")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "hide":
		queue_free()
