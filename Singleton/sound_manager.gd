extends Node

## MUSIC RELATED
onready var music_player = $MusicPlayer
var current_music_stream
var pause_position
	
onready var sfx_player = {
	1 : {
		"node" : $EffectPlayer1,
		"sound" : null
		},
	2 : {
		"node" : $EffectPlayer2,
		"sound" : null
		},
	3 : {
		"node" : $EffectPlayer3,
		"sound" : null
	}
}


################################################################
####### Dictionary of available music and sound effects ########

########## Music ##########
var music = {
	"menu" : "res://Menu/sounds/menubgm.ogg",
	"match_game" : "res://MatchGame/sounds/bgm.ogg",
	"match_three" : "res://MatchThree/sounds/bgm.ogg",
	"swipe_card" : "res://SwipeCard/assets/bgm1.ogg",
	"flip_card" : "res://FlipCard/Sound/BGM001.ogg",
	"tamago" : "res://Tamago/Assets/Sfx/bgm1.ogg",
	"fruit_slash" : "res://FruitSlash/Assets/Sfx/bgm5.ogg"
	}
##############################


################################################################
######################### Sound Effect #########################
var effect = {
	"general" : {
		"button_pressed" : "res://Menu/sounds/button_pressed.ogg",
		"effect_button" : "res://Menu/sounds/effect_button.ogg",
		"star" : "res://General/sounds/star.ogg"
		},
		
	
	############################# GAME #########################
	"match_game" : {
		"correct" : "res://MatchGame/sounds/correct.ogg",
		"wrong" : "res://MatchGame/sounds/wrong.ogg",
		"countdown_timer" : "res://MatchGame/sounds/countdown_timer.ogg",
		"countdown_end" : "res://MatchGame/sounds/countdown_end.ogg"
		},
	"match_three" : {
		"correct" : "res://MatchThree/sounds/correct.ogg",
		"swap" : "res://MatchThree/sounds/swap.ogg"
		},
	"swipe_card" : {
		"card_slide" : "res://SwipeCard/assets/cardSlide6.ogg",
		"correct" : "res://SwipeCard/assets/correct.ogg",
		"wrong" : "res://SwipeCard/assets/wrong.ogg"
		},
	"tamago" : {
		"correct" 		: "res://Tamago/Assets/Sfx/correct.ogg",
		"wrong"	  		: "res://Tamago/Assets/Sfx/wrong.ogg",
		"timer_tick"	: "res://Tamago/Assets/Sfx/countdown.ogg",
		"water"			: "res://Tamago/Assets/Sfx/water.ogg"
		},
	"fruit_slash" : {
		"correct"		: "res://FruitSlash/Assets/Sfx/correct.ogg",
		"wrong"			: "res://FruitSlash/Assets/Sfx/wrong.ogg",
		"slash"			: "res://FruitSlash/Assets/Sfx/slash.ogg",

		}
	}
################################################################

func _ready():
	randomize()


func play_random_music():
	var rand = round(rand_range(0, music.size() - 1))
	play_music(music.keys()[rand])
	print("Available Music : " + str(music.keys()))


func play_music(music_name):
	if current_music_stream != null:
		pause_position = get_music_position()
		
	if current_music_stream != music[music_name]:
		current_music_stream = music[music_name]
		music_player.stream = load(current_music_stream)
	
	if ConfigManager.music_on:
		resume_music()
		print("Playing music : " + music_name)


func get_music_position():
	return music_player.get_playback_position()


func pause_music():
	pause_position = get_music_position()
	music_player.stop()
	print("Music paused")


func resume_music():
	if current_music_stream == null:
		play_random_music()
	else:
		if get_music_position() == 0: 
			pause_position = 0
		music_player.play(pause_position)
		print("Music resumed")


func play_effect(game_name, effect_name):
	if ConfigManager.effect_on:
		var stream = effect[game_name][effect_name]
		
		# Checking if sfx overlapped
		for i in range(1, sfx_player.size() + 1):
			if sfx_player[i]["sound"] == stream:
				_sfx_play(i, stream)
				print("Playing effect : " + game_name + " <" + effect_name + ">")
				return
				
		# If SFX not overlapping
		for i in range(1, sfx_player.size() + 1):
			if !sfx_player[i]["node"].playing:
				_sfx_play(i, stream)
				print("Playing effect : " + game_name + " <" + effect_name + ">")
				return


func _sfx_play(index, stream):
	sfx_player[index]["sound"] = stream 
	sfx_player[index]["node"].stream = load(stream)
	sfx_player[index]["node"].play()
	print("Playing SFX Player - " + str(index))
