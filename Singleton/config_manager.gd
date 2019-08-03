extends Node

onready var path = "user://config.ini"
var effect_on = true
var music_on = true


func _ready():
	load_config()	


func save_config():
	var config = ConfigFile.new()
	config.set_value("audio", "effect", effect_on)
	config.set_value("audio", "music", music_on)
	var err = config.save(path)
	if err != OK:
		print("Error saving config file")


func load_config():
	var config = ConfigFile.new()
	var default_settings = {
		"effect" : true,
		"music" : true
		}
	var err = config.load(path)
	if err != OK:
		print("Load config error, setting to default values")
	effect_on = config.get_value("audio", "effect", default_settings["effect"])
	music_on = config.get_value("audio", "music", default_settings["music"])