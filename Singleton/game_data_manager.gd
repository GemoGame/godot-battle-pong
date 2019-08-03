extends Node

const SAVE_PATH = "user://save.dat"
const TOTAL_LEVEL = 12
 
var minimum_star = 1
var level_info = {}


func _ready():
	load_data()


func save_data(level, score = 0, star = 0):
	var requirement_met = star >= minimum_star
	if requirement_met:
		unlock_next_level(level)
	if compare_game_progress(level, score):
		level_info[str(level)] = {
			"unlocked" : true,
			"high_score" : score,
			"stars_unlocked" : star
		}
		save_data_file()


func unlock_next_level(level):
	var next_level = str(int(level) + 1)
	level_info[next_level] = {
		"unlocked" : true,
		"high_score" : 0,
		"stars_unlocked" : 0
	}


func save_data_file():
	var data = level_info
	var file = File.new()
	var err = file.open(SAVE_PATH, File.WRITE)
	if err != OK:
		print ("Saving data file error")
		return
	file.store_line(to_json(data))
	file.close()
	print("Saving Data : ")
	print(data)


func compare_game_progress(level, score):
	# Comparing if older save data has better progress than the new one
	if level_info.has(level):
		var old_score = level_info[level]["high_score"]
		if score < old_score:
			return false
	return true


func load_data():
	level_info = load_data_file()


func load_data_file():
	var file = File.new()
	var err = file.open(SAVE_PATH, File.READ)
	if err != OK:
		var default_level_info = {
			"1":{
				"unlocked" : true,
				"high_score" : 0,
				"stars_unlocked" : 0
				}
		}
		print("Load data file error, using default values")
		print("Default data : " + str(default_level_info))
		return default_level_info
	var json = file.get_as_text()
	file.close()
	var data = parse_json(json)
	print("Load data json : " + json)
	return data


func reset_data():
	print("Reseting data")
	var dir = Directory.new()
	dir.remove(SAVE_PATH)
	load_data()


func unlock_all_levels():
	print("Unlocking all levels")
	for i in TOTAL_LEVEL:
		level_info[str(i+1)] = {
			"unlocked" : true,
			"high_score" : 0,
			"stars_unlocked" : 0
		}
	save_data_file()
	load_data()