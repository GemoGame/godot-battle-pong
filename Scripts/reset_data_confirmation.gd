extends CanvasLayer

signal update_button

func _on_no_pressed():
	SoundManager.play_effect("general", "button_pressed")
	$AnimationPlayer.play("slide_out_right")
	get_tree().paused = false

func _on_yes_pressed():
	SoundManager.play_effect("general", "button_pressed")
	$AnimationPlayer.play("slide_out_right")
	GameDataManager.reset_data()
	get_tree().paused = false
	get_tree().change_scene("res://Menu/scenes/splash_panel.tscn")

func _on_reset_data_button_pressed():
	SoundManager.play_effect("general", "button_pressed")
	$AnimationPlayer.play("slide_in_right")
	get_tree().paused = true
