extends TextureButton

export (Texture) var on_normal
export (Texture) var on_pressed
export (Texture) var off_normal
export (Texture) var off_pressed


func _ready():
	update_texture()


func update_texture():
	if ConfigManager.effect_on:
		set_normal_texture(on_normal)
		set_pressed_texture(on_pressed)
	else:
		set_normal_texture(off_normal)
		set_pressed_texture(off_pressed)


func change_state():
	ConfigManager.effect_on = !ConfigManager.effect_on
	if ConfigManager.effect_on:
		$AudioStreamPlayer.play()
	ConfigManager.save_config()
	update_texture()
	print("Effect on status : " + str(ConfigManager.effect_on))


func _on_effect_button_pressed():
	change_state()