extends Node2D

signal unpaused

const MENU_PATH = "res://Scenes/menu.tscn"


func _ready():
	$Container/Limit.set_text(str(Game.score_limit))
	$Container.visible = false


func show():
	$Container/AnimationPlayer.play("show")
	get_tree().paused = true


func _on_Continue_pressed():
	$Container/AnimationPlayer.play("hide")



func _on_Retry_pressed():
	Game.load_level()


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "hide":
		get_tree().paused = false
		emit_signal("unpaused")


func _on_BackMenu_pressed():
	get_tree().paused = false
	get_tree().change_scene(MENU_PATH)


func _on_Button_pressed():
	show()