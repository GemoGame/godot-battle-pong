extends TextureButton


export (Texture) var on_normal
export (Texture) var on_pressed
export (Texture) var off_normal
export (Texture) var off_pressed

func _ready():
	update_texture()

func update_texture():
	if ConfigManager.music_on:
		set_normal_texture(on_normal)
		set_pressed_texture(on_pressed)
	else:
		set_normal_texture(off_normal)
		set_pressed_texture(off_pressed)

func change_state():
	ConfigManager.music_on = !ConfigManager.music_on
	ConfigManager.save_config()
	if ConfigManager.music_on:
		SoundManager.resume_music()
	else:
		SoundManager.pause_music()
	update_texture()

func _on_music_button_pressed():
	change_state()
