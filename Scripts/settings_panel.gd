extends "res://Menu/scripts/base_panel.gd"

signal to_level_select

func _on_level_select_button_pressed():
	SoundManager.play_effect("general", "button_pressed")
	emit_signal("to_level_select")
